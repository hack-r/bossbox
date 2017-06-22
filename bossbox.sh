#!/bin/bash

HCI=$1
RM_ADDR=$2
RM_NAME="NONE"
LQ_PREV=255
PING_COUNT=0

if [ "$HCI" = "" ] || [ "$RM_ADDR" = "" ]
then
        echo -e "**************************************************"
        echo -e "* BossBox: The Bluetooth Early Warning System    *"
        echo -e "* by Jason D. Miller (hack-r)                    *"
        echo -e "* www.hack-r.com                                 *"
        echo -e "* Based on BlueRanger by Mr. JP Dunning (.ronin) *"
        echo -e "* (c) 2017 Miller Intelligence, LLC.             *"
        echo -e "**************************************************"
        echo -e "\nNAME"
        echo -e "       bossbox"
        echo -e "\nSYNOPSIS"
        echo -e "        bossbox.sh <hciX> <bdaddr>"
        echo -e "\nDESCRIPTION"
        echo -e "       <hciX>         Local interface"
        echo -e "       <bdaddr>       Remote Device Address\n"
        echo -e "\nINSTRUCTIONS"
        echo -e "First, determine your boss' (wife's, kids', parents', etc)  Bluetooth MAC address with a hcitool or pybluez inquiry."
        echo -e "\n Then use this MAC address as the bdaddr, and your bluetooth interface, which is usually hci0, as the parameters with which you run this script."
        echo -e "\n Finally, watch the LED activate when their Bluetooth network is in range, and it will blink faster as they approach."
        echo -e "\n See the Instructables.com post for more info. Enjoy!"
else

        echo -e "\nStarting ...\n"
        echo -e "Close with 2 X Crtl+C"
        RM_NAME=`hcitool -i $HCI name $RM_ADDR`

        while /bin/true
        do

                l2ping -i $HCI -c 1 $RM_ADDR | grep NULL; LQ=`hcitool -i $HCI lq $RM_ADDR | grep Link | awk '{print $3}'`
                PING_COUNT=$(($PING_COUNT+1))
                clear

                echo -e "\n      (((B(o(s(s(B)o)x)))\n"
                echo -e "By Jason D. Miller \nwww.hack-r.com\n"
                echo -e "Locating: $RM_NAME ($RM_ADDR)"
                echo -e "Ping Count: $PING_COUNT\n"

                if [ "$LQ" = "" ]
                then
                        echo "Connection Error"
                else
                                echo -e "Proximity Change       Link Quality\n----------------  ------------"
                        if [ $LQ -eq 255 ]
                        then
                                echo -e "FOUND                  $LQ/255"
                        elif [ $LQ -lt $LQ_PREV ]
                        then
                                echo -e "COLDER                 $LQ/255"
                        elif [ $LQ -gt $LQ_PREV ]
                                                then
                                echo -e "WARMER                 $LQ/255"
                        else
                                echo -e "NEUTRAL                        $LQ/255"
                        fi

                        echo -e "\nRange\n------------------------------------"

                        if [ $LQ -eq 255 ]
                        then
                                echo -e "|*"
                        elif [ $LQ -gt 249 ] && [ $LQ -lt 255 ]
                        then
                                echo -e "|    *"
                        elif [ $LQ -gt 239 ] && [ $LQ -lt 250 ]
                        then
                                echo -e "|        *"
                        elif [ $LQ -gt 229 ] && [ $LQ -lt 240 ]
                        then
                                echo -e "|            *"
                        elif [ $LQ -gt 219 ] && [ $LQ -lt 230 ]
                        then
                                echo -e "|                *"
                        elif [ $LQ -gt 209 ] && [ $LQ -lt 220 ]
                        then
                                echo -e "|                    *"
                        elif [ $LQ -gt 199 ] && [ $LQ -lt 210 ]
                        then
                                echo -e "|                        *"
                        elif [ $LQ -gt 189 ] && [ $LQ -lt 200 ]
                        then
                                echo -e "|                            *"
                        elif [ $LQ -gt 179 ] && [ $LQ -lt 190 ]
                        then
                                echo -e "|                               *"
                        else
                                echo -e "|                                  *"
                        fi

                        echo -e "------------------------------------"

                        LQ_PREV=$LQ
                fi
        done
fi
