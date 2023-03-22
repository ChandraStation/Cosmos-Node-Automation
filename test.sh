#!/usr/bin/env bash

tput setaf 6; echo '
░█████╗░██╗░░██╗░█████╗░███╗░░██╗██████╗░██████╗░░█████╗░  ░██████╗████████╗░█████╗░████████╗██╗░█████╗░███╗░░██╗
██╔══██╗██║░░██║██╔══██╗████╗░██║██╔══██╗██╔══██╗██╔══██╗  ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║
██║░░╚═╝███████║███████║██╔██╗██║██║░░██║██████╔╝███████║  ╚█████╗░░░░██║░░░███████║░░░██║░░░██║██║░░██║██╔██╗██║
██║░░██╗██╔══██║██╔══██║██║╚████║██║░░██║██╔══██╗██╔══██║  ░╚═══██╗░░░██║░░░██╔══██║░░░██║░░░██║██║░░██║██║╚████║
╚█████╔╝██║░░██║██║░░██║██║░╚███║██████╔╝██║░░██║██║░░██║  ██████╔╝░░░██║░░░██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║
░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝  ╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝


███╗░░██╗░█████╗░██████╗░███████╗  ███╗░░░███╗░█████╗░███╗░░██╗░█████╗░░██████╗░███████╗██████╗░
████╗░██║██╔══██╗██╔══██╗██╔════╝  ████╗░████║██╔══██╗████╗░██║██╔══██╗██╔════╝░██╔════╝██╔══██╗
██╔██╗██║██║░░██║██║░░██║█████╗░░  ██╔████╔██║███████║██╔██╗██║███████║██║░░██╗░█████╗░░██████╔╝
██║╚████║██║░░██║██║░░██║██╔══╝░░  ██║╚██╔╝██║██╔══██║██║╚████║██╔══██║██║░░╚██╗██╔══╝░░██╔══██╗
██║░╚███║╚█████╔╝██████╔╝███████╗  ██║░╚═╝░██║██║░░██║██║░╚███║██║░░██║╚██████╔╝███████╗██║░░██║
╚═╝░░╚══╝░╚════╝░╚═════╝░╚══════╝  ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝░╚═════╝░╚══════╝╚═╝░░╚═╝'; tput sgr0



# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

tput setaf 6; 
    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on
    tput sgr0

    return $selected
}


#Choice Selection

echo "Select an OS using up/down keys and enter to confirm:"

function select_opt {
    select_option "$@" 1>&2
    local result=$?
    echo $result
    return $result
}

case `select_opt "Arch Linux" "Ubuntu" "Os is set up" "Quit"` in

#Arch    
    0) sudo pacman -Syyu ansible aria2 atop autoconf automake base binutils bison bmon btrfs-progs btop clang cronie cryptsetup docker dstat fakeroot flex gcc git go gptfdisk groff grub haveged htop iftop iptraf-ng jq llvm lvm2 m4 make mdadm neovim net-tools nethogs openssh patch pkgconf python rsync rustup screen sudo texinfo unzip vi vim vnstat wget which xfsprogs hddtemp python-setuptools npm python-bottle python-docker python-matplotlib python-netifaces python-zeroconf python-pystache time nload nmon glances gtop bwm-ng bpytop duf go-ipfs fish pigz zerotier-one sysstat github-cli pm2 jq;;


#Ubuntu
    1) sudo apt install -y ansible tar unzip wget curl gcc make snap && sudo snap install go --classic && sudo snap install jq;;


#Already set up
    2) ;;


#Quit
    3) exit;;



esac

echo "Select a network option using up/down keys and enter to confirm:"

function select_opt {
    select_option "$@" 1>&2
    local result=$?
    echo $result
    return $result
}

my_array= (Akash Canto Chihuahua Comdex Evmos Gravity Kava Osmosis Passage Stride)

case `select_opt "Mainnet" "Backup" "Relayer" "Cancel"` in
    0)  
        echo 'Where is this directory saved at (example /root/github-repos/Validatorautomation)'; 
            read DIRECTORY
            cp $DIRECTORY/inventory.sample $DIRECTORY/inventory    
        printf '%s\n' "${my_array[@]}"
        echo "What network will this node be for"
            read NETWORK
            sudo sed -i '[juno]/[$NETWORK]' $DIRECTORY/inventory
            sudo sed -i 'juno_main/$NETWORK_main' $DIRECTORY/inventory
            sudo sed -i 'juno_backup/$NETWORK_backup' $DIRECTORY/inventory
            sudo sed -i 'juno_relayer/$NETWORK_relayer' $DIRECTORY/inventory
            sudo sed -i 'juno_seed/$NETWORK_seed' $DIRECTORY/inventory
            sudo sed -i 'juno_tenderduty/$NETWORK_tenderduty' $DIRECTORY/inventory
            sudo sed -i 'promtail=true/promtail=false' $DIRECTORY/inventory
            sudo sed -i 'node_exporter=true/node_exporter=false' $DIRECTORY/inventory
        echo 'Input Your System Username, This user will need sudo privilege'; tput sgr0 
            read USERNAME
                sudo sed -i 'ansible_user=ubuntu/ansible_user=$USERNAME' $DIRECTORY/inventory
        echo 'Input your port, the default is set to 22'
            read PORT 
                sudo sed -i 'ansible_port=22/ansible_port=$PORT' $DIRECTORY/inventory
        echo 'Input your ssh key directory, it is set to ~/.ssh/id_rsa by default'
            read SSH_DIRECTORY
                sudo sed -i 'ansible_ssh_private_key_file="~/.ssh/id_rsa"/ansible_ssh_private_key_file="$SSH_DIRECTORY"' $DIRECTORY/inventory
        echo 'Input your User Directory (example /home/user) Assumes that its not a root user and its a home directory'
            read USER_DIRECTORY
                sudo sed -i 'user_dir="/home/{{ansible_user}}"/user_dir="$USER_DIRECTORY"' $DIRECTORY/inventory
        echo 'What would you like your node name to be?'; 
	        read NAME
                sudo sed -i 'node_name="BRAND-{{ network }}-{{ type }}/node_name="$NAME"' $DIRECTORY/inventory

        echo 'Input Your Home Directory Path'; 

esac

sudo sed -i 's/minimum-gas-prices = "0acanto"/minimum-gas-prices = "4000000000000acanto"/g' $WORKINGDIRECTORY/.cantod/config/app.toml