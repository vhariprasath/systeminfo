#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '
options=("System Info" "CPU/Memory Usage" "Disk Usage" "check for listening ports" "System Users" "Active Users" "Active Connection" "Generate file" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "System Info")
            echo -e "-------------------------------System Information----------------------------"
            echo ""
            echo -e "Hostname:\t\t"`hostname`
            echo -e "uptime:\t\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`
            echo -e "Manufacturer:\t\t"`cat /sys/class/dmi/id/chassis_vendor`
            echo -e "Product Name:\t\t"`cat /sys/class/dmi/id/product_name`
            echo -e "Version:\t\t"`cat /sys/class/dmi/id/product_version`
            # echo -e "Serial Number:\t\t"`cat /sys/class/dmi/id/product_serial`
            echo -e "Machine Type:\t\t"`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`
            echo -e "Operating System:\t"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
            echo -e "Kernel:\t\t\t"`uname -r`
            echo -e "Architecture:\t\t"`arch`
            echo -e "Processor Name:\t\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
            echo -e "System Main IP:\t\t"`hostname -I`
            echo ""

            ;;
        "CPU/Memory Usage")
            echo ""
            echo -e "-------------------------------CPU/Memory Usage------------------------------"
            echo ""
            echo -e "Memory Usage:\t"`free | awk '/Mem/{printf("%.2f%"), $3/$2*100}'`
            echo -e "Swap Usage:\t"`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}'`
            echo -e "CPU Usage:\t"`cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' |  awk '{print $0}' | head -1`
            echo ""

            ;;
        "Disk Usage")
            echo ""
            echo -e "-------------------------------Disk Usage -------------------------------"
            echo ""
            df -m
            echo -e "Total Number of disks :" `expr $(df -h | wc -l) - 1`
            echo ""

            ;;

        "check for listening ports")
            echo -e "-------------------------------Check for open ports-------------------------------"
            echo ""
            netstat -lntu
            echo ""


            ;;

        "System Users")
            echo ""
            echo -e "-------------------------------System Users-------------------------------"
            echo ""
            awk -F: '{ print $1}' /etc/passwd
            echo ""

            ;;
        
        "Active Users")
            echo ""
            echo -e "-------------------------------Active Users-------------------------------"
            echo ""
            users
            echo ""


            ;;
        
        "Active Connection")
            echo ""
            echo -e "-------------------------------Active Connection-------------------------------"
            echo ""
            w
            echo ""



            ;;

        "Generate file")
            bash https://github.com/vhariprasath/systeminfo/blob/master/sysinfo.sh > systeminfo.txt
            echo "file saved as systeminfo.txt"
            echo ""
            ;;

        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
