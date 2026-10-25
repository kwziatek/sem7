#!/bin/bash

finished=0

while [ $finished -ne 1 ]
do

    echo "What is your favorite Linux distribution?"

    echo "1 - Ubuntu"
    echo "2 - Archlinux"
    echo "3 - Debian"
    echo "4 - Mint"
    echo "5 - CentOS"
    echo "6 - Something else..."
    echo "7 - Exit the script"
    read distro

    case $distro in 
    1) echo "Ubuntu is popular on both servers and laptops";;
    2) echo "Arch is a rolling release";;
    3) echo "Debian is community distribution";;
    4) echo "Mint is popular on desktops and laptops";;
    5) echo "CentOS is popular on servers";;
    6) echo "There are many distributions out there";;
    7) finished=1;;
    *) echo "You didn't enter an appropriate choice";;
    esac
done

echo "Thank you for using this dscript."
