#!/bin/bash
version=$(uname -a)
CPUp=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
CPUv=$(grep -c "processor" /proc/cpuinfo)
Mem=$(free --mega | grep "Mem" | awk '{ printf("%d/%dMB (%.2f%%)", $3, $2, $3/$2 * 100)}')
Disk=$(df | awk '(NR != 1) {total+=$4; used+=$3} END{printf("%d/%dGb (%.1f%%)", used/1000, total/1000000, (used/total)* 100)}')
Usage=$(grep "cpu" /proc/stat | awk '(NR == 1) {total=($2 + $4 + $5); used=($2 + $4); printf("%.1f%%", used/total * 100)}')
Last=$(who -b | awk '{ printf("%s %s\n", $3, $4)}')
LVM=$(lsblk | grep "lvm" | wc -l)
LVMr=$(if [[ $lvmt == 0 ]]; then echo no; else echo yes; fi)
Connections=$(cat /proc/net/sockstat | awk '(NR != 1) {if ($3 >= 1) printf("%s %d", $1, $3)}')
Users=$(users | wc -w)
ip=$(hostname -I)
MAC=$(ip a | grep "link/ether" | awk '{ print $2 }')
sudo=$(journalctl _COMM=sudo -q | wc -l)
wall "	#Architecture: $version
	#CPU physical: $CPUp
	#vCPU: $CPUv
	#Memory Usage: $Mem
	#Disk Usage: $Disk
	#CPU load: $Usage
	#Last boot: $Last
	#LVM use: $LVMr
	#Connections $Connections
	#User log: $Users
	#Network: $ip ($MAC)
	#Sudo: $sudo cmd"
