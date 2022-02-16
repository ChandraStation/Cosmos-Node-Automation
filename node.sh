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
    0) pacman -Syyu aria2 atop autoconf automake base binutils bison bmon btrfs-progs btop clang cronie cryptsetup docker dstat fakeroot flex gcc git go gptfdisk groff grub haveged htop iftop iptraf-ng jq llvm lvm2 m4 make mdadm neovim net-tools nethogs openssh patch pkgconf python rsync rustup screen sudo texinfo unzip vi vim vnstat wget which xfsprogs hddtemp python-setuptools npm python-bottle python-docker python-matplotlib python-netifaces python-zeroconf python-pystache time nload nmon glances gtop bwm-ng bpytop duf go-ipfs fish pigz zerotier-one sysstat github-cli pm2;;


#Ubuntu
    1) apt-get update -y && apt install -y tar unzip wget curl gcc make snap && snapd install go --classic;;


#Already set up
    2) break;;


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
case `select_opt "Akash" "Chihuahua" "Comdex" "Dig" "e-Money" "G-Bridge" "OmniFlix" "Osmosis" "Sentinel" "Logs" "Cancel"` in
    

#AKASH    
    0)      tput setaf 1; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 1; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 1; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 1; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 1; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 1; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 1;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"

#Akash cont...
            git clone https://github.com/ovrclk/akash -P ~/root/
            cd akash 
            git checkout v0.14.1 
	        make install 
            mv ~/go/bin/akash /usr/bin/ 
            akash init $NAME --chain-id akashnet-2 
            sed -i 's/seeds = ""/seeds ="27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656"/g' ~/.akash/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656,9180b99a5be3443677e0f57fc5f40e8f071bdcd8@161.35.239.0:51656,47c9acc0e7d9b244a6404458e76d50b6284bfbbb@142.93.77.25:26656,ab7b55588ea3f4f7a477e852aa262959e54117cd@3.235.249.94:26656,4acf579e2744268f834c713e894850995bbf0ffa@50.18.31.225:26656,3691ac1f56389ffec8579c13a6eb8eca41cf8ae3@54.219.88.246:26656,86afe23f116ba4754a19819a55d153008eb74b48@15.164.87.75:26656,6fbc3808f7d6c961e84944ae2d8c800a8bbffbb4@138.201.159.100:26656,a2a3ffe7ac122a218e1f59c32a670f04b8fd3033@165.22.69.102:26656"/g' ~/.akash/config/config.toml 
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uakt"/g' ~/.akash/config/app.toml
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:16657"/g' ~/.akash/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:16656"/g' ~/.akash/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:1090"/g' ~/.akash/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:1091"/g' ~/.akash/config/app.toml 
            sudo rm -i ~/.akash/config/genesis.json 
            wget https://github.com/ovrclk/net/raw/master/mainnet/genesis.json -P ~/.akash/config/ 
            cat << EOF > /etc/systemd/system/akash.service 
[Unit] 
Description=Akash Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/akash start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            rm ~/.akash/data/priv_validator_state.json 
            wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data 
            tar -xvf ~/.akash/data/akashnet-2_$(date +"%Y-%m-%d").tar -C ~/.akash/data/ 
            sudo systemctl daemon-reload 
            sudo systemctl enable akash
            sudo systemctl start akash;;


#CHIHUAHUA    
    1)      tput setaf 3; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 3; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 3; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 3; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 3; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 3; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 3;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"

#Chihuahua cont...
            git clone https://github.com/ChihuahuaChain/chihuahua.git 
            cd chihuahua
            git checkout v
            make install 
            mv ~/go/bin/chihuahuad /usr/bin/ 
            chihuahuad init $NAME --chain-id chihuahua-1 
            sed -i 's/seeds = ""/seeds = "4936e377b4d4f17048f8961838a5035a4d21240c@chihuahua-seed-01.mercury-nodes.net:29540"/g' ~/.chihuahua/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers="b140eb36b20f3d201936c4757d5a1dcbf03a42f1@216.238.79.138:26656,19900e1d2b10be9c6672dae7abd1827c8e1aad1e@161.97.96.253:26656,c382a9a0d4c0606d785d2c7c2673a0825f7c53b2@88.99.94.120:26656,a5dfb048e4ed5c3b7d246aea317ab302426b37a1@137.184.250.180:26656,3bad0326026ca4e29c64c8d206c90a968f38edbe@128.199.165.78:26656,89b576c3eb72a4f0c66dc0899bec7c21552ea2a5@23.88.7.73:29538,38547b7b6868f93af1664d9ab0e718949b8853ec@54.184.20.240:30758,a9640eb569620d1f7be018a9e1919b0357a18b8c@38.146.3.160:26656,7e2239a0d4a0176fe4daf7a3fecd15ac663a8eb6@144.91.126.23:26656""/g' ~/.chihuahua/config/config.toml
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:86657"/g' ~/.chihuahua/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:86656"/g' ~/.chihuahua/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:8090"/g' ~/.chihuahua/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:8091"/g' ~/.chihuahua/config/app.toml
            sed -i 's/minimum-gas-prices = "0stake"/minimum-gas-prices = "0.025uhuahua"/g' ~/.chihuahua/config/app.toml 
            wget -O ~/.chihuahua/config/genesis.json https://raw.githubusercontent.com/ChihuahuaChain/mainnet/main/genesis.json -P ~/.chihuahua/config/ 
            cat << EOF > /etc/systemd/system/chihuahuad.service 
[Unit] 
Description=Chihuahua Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/chihuahuad start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            wget https://tendermint-snapshots.polkachu.xyz/chihuahua/chihuahua_887041.tar.lz4 -P ~/.chihuahua/data 
            lz4 ~/.chihuahua/data/chihuahua_887041.tar.lz4 -C ~/.chihuahua/data/ 
            tar -xvf ~/.chihuahua/data/chihuahua_887041.tar -C ~/.chihuahua/data/
            systemctl daemon-reload 
            systemctl enable chihuahuad
            systemctl start chihuahuad
            printf '\nFinished!\n';;


#COMDEX
    2) tput setaf 1; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 1; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 1; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 1; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 1; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 1; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 1;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"


#Comdex cont...
            git clone https://github.com/comdex-official/comdex ||
            cd comdex ||
            git checkout v0.0.4 ||
            make install || 
            cp ~/go/bin/comdex /usr/bin/comdex ||
            comdex init $NAME ||
            sed -i 's/seeds = ""/seeds ="aef35f45db2d9f5590baa088c27883ac3d5e0b33@3.108.102.92:26656"/g' ~/.comdex/config/config.toml ||
            sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656"/g' ~/.comdex/config/config.toml ||
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' ~/.comdex/config/app.toml ||
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:56657"/g' ~/.comdex/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:56656"/g' ~/.comdex/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:5090"/g' ~/.comdex/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:5091"/g' ~/.comdex/config/app.toml 
            sudo rm -i ~/.comdex/config/genesis.json ||
            wget https://github.com/comdex-official/networks/raw/main/mainnet/comdex-1/genesis.json -P ~/.comdex/config/ ||
            cat << EOF > /etc/systemd/system/comdex.service 
[Unit] 
Description=Comdex Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/comdex start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            sudo systemctl daemon-reload ||
            sudo systemctl enable comdex ||
            sudo systemctl start comdex ||
            printf '\nFinished!\n';;


#DIG            
    3) tput setaf 3; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 3; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 3; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 3; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 3; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 3; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 3;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"

#Dig cont...
            git clone https://github.com/notional-labs/dig ||
            cd dig ||
            git checkout v1.1.0 ||
            cd cmd/digd ||
            go install ./... ||
            cd ||
            cp ~/go/bin/digd /usr/bin/digd ||
            digd init $NAME ||
            sed -i 's/seeds = ""/seeds ="37b2839da4463b22a51b1fe20d97992164270eba@62.171.157.192:26656,e2c96b96d4c3a461fb246edac3b3cdbf47768838@65.21.202.37:6969"/g' ~/.dig/config/config.toml ||
            sed -i 's/persistent_peers = ""/persistent_peers = "33f4788e1c6a378b929c66f31e8d253b9fd47c47@194.163.154.251:26656,64eccffdc60a206227032d3a021fbf9dfc686a17@194.163.156.84:26656,be7598b2d56fb42a27821259ad14aff24c40f3d2@172.16.152.118:26656,f446e37e47297ce9f8951957d17a2ae9a16db0b8@137.184.67.162:26656,ab2fa2789f481e2856a5d83a2c3028c5b215421d@144.91.117.49:26656,e9e89250b40b4512237c77bd04dc76c06a3f8560@185.214.135.205:26656,1539976f4ee196f172369e6f348d60a6e3ec9e93@159.69.147.189:26656,85316823bee88f7b05d0cfc671bee861c0237154@95.217.198.243:26656,eb55b70c9fd8fc0d5530d0662336377668aab3f9@185.194.219.128:26656"/g' ~/.dig/config/config.toml ||
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.025udig"/g' ~/.dig/config/app.toml ||
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:66657"/g' ~/.dig/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:66656"/g' ~/.dig/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:6090"/g' ~/.dig/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:6091"/g' ~/.dig/config/app.toml 
            sudo rm -i ~/.dig/config/genesis.json ||
            wget https://raw.githubusercontent.com/notional-labs/dig/master/networks/mainnets/dig-1/genesis.json -P ~/.dig/config/ ||
            cat << EOF > /etc/systemd/system/dig.service 
[Unit] 
Description=Dig Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/dig start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            sudo systemctl daemon-reload ||
            sudo systemctl enable dig ||
            sudo systemctl start dig ||
            printf '\nFinished!\n';;


#E-MONEY            
    4) tput setaf 2; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 2; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 2; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 2; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 2; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 2; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 2;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"

#e-Money cont...
            git clone https://github.com/e-money/em-ledger ||
            cd em-ledger ||
            git checkout v1.1.4 || 
            make install ||
            cd ||
            cp ~/go/bin/emd /usr/bin/emd ||
            emd init $NAME ||
            sed -i 's/seeds = ""/seeds ="708e559271d4d75d7ea2c3842e87d2e71a465684@seed-1.emoney.validator.network:28656,336cdb655ea16413a8337e730683ddc0a24af9de@seed-2.emoney.validator.network:28656"/g' ~/.emd/config/config.toml ||
            sed -i 's/persistent_peers = ""/persistent_peers = "ecec8933d80da5fccda6bdd72befe7e064279fc1@207.180.213.123:26676,0ad7bc7687112e212bac404670aa24cd6116d097@50.18.83.75:26656,1723e34f45f54584f44d193ce9fd9c65271ca0b3@13.124.62.83:26656,34eca4a9142bf9c087a987b572c114dad67a8cc5@172.105.148.191:26656,c2766f7f6dfe95f2eb33e99a538acf3d6ec608b1@162.55.132.230:2140,eed66085c975189e3d498fe61af2fcfb3da34924@217.79.184.40:26656"/g' ~/.emd/config/config.toml ||
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.025ungm"/g' ~/.emd/config/app.toml ||
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:46657"/g' ~/.emd/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:46656"/g' ~/.emd/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:4090"/g' ~/.emd/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:4091"/g' ~/.emd/config/app.toml 
            sudo rm -i ~/.dig/config/genesis.json ||
            wget https://raw.githubusercontent.com/notional-labs/dig/master/networks/mainnets/dig-1/genesis.json -P ~/.emd/config/ ||
            cat << EOF > /etc/systemd/system/emd.service 
[Unit] 
Description=e-Money Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/emd start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            sudo systemctl daemon-reload ||
            sudo systemctl enable emoney ||
            sudo systemctl start emoney ||
            printf '\nFinished!\n';;

#G-Bridge            
    5) tput setaf 2; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 2; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 2; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 2; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 2; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 2; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 6;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"

#G-Bridge cont...
            git clone https://github.com/e-money/em-ledger ||
            cd em-ledger ||
            git checkout v1.1.4 || 
            make install ||
            cd ||
            cp ~/go/bin/emd /usr/bin/emd ||
            emd init $NAME ||
            sed -i 's/seeds = ""/seeds ="708e559271d4d75d7ea2c3842e87d2e71a465684@seed-1.emoney.validator.network:28656,336cdb655ea16413a8337e730683ddc0a24af9de@seed-2.emoney.validator.network:28656"/g' ~/.emd/config/config.toml ||
            sed -i 's/persistent_peers = ""/persistent_peers = "ecec8933d80da5fccda6bdd72befe7e064279fc1@207.180.213.123:26676,0ad7bc7687112e212bac404670aa24cd6116d097@50.18.83.75:26656,1723e34f45f54584f44d193ce9fd9c65271ca0b3@13.124.62.83:26656,34eca4a9142bf9c087a987b572c114dad67a8cc5@172.105.148.191:26656,c2766f7f6dfe95f2eb33e99a538acf3d6ec608b1@162.55.132.230:2140,eed66085c975189e3d498fe61af2fcfb3da34924@217.79.184.40:26656"/g' ~/.emd/config/config.toml ||
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.025ungm"/g' ~/.emd/config/app.toml ||
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:46657"/g' ~/.emd/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:46656"/g' ~/.emd/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:4090"/g' ~/.emd/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:4091"/g' ~/.emd/config/app.toml 
            sudo rm -i ~/.dig/config/genesis.json ||
            wget https://raw.githubusercontent.com/notional-labs/dig/master/networks/mainnets/dig-1/genesis.json -P ~/.emd/config/ ||
            cat << EOF > /etc/systemd/system/emd.service 
[Unit] 
Description=e-Money Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/emd start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            sudo systemctl daemon-reload ||
            sudo systemctl enable emoney ||
            sudo systemctl start emoney ||
            printf '\nFinished!\n';;

#OMNIFLIX            
    6) tput setaf 5; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 5; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 5; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 5; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 5; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 5; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 5;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"

#OmniFlix cont...
            git clone https://github.com/OmniFlix/omniflixhub ||
            cd omniflixhub ||
            git checkout v0.3.0 ||
            make install ||
            cd ||
            cp ~/go/bin/omniflixhubd /usr/bin/omniflixhubd ||
            emd init $NAME ||
            sed -i 's/seeds = ""/seeds ="75a6d3a3b387947e272dab5b4647556e8a3f9fc1@45.72.100.122:26656"/g' ~/.omniflixhub/config/config.toml ||
            sed -i 's/persistent_peers = ""/persistent_peers = "f05968e78c84fd3997583fabeb3733a4861f53bf@45.72.100.120:26656,b29fad915c9bcaf866b0a8ad88493224118e8b78@104.154.172.193:26656,28ea934fbe330df2ca8f0ddd7a57a8a68c39a1a2@45.72.100.110:26656,94326ddc5661a1b571ea10c0626f6411f4926230@45.72.100.111:26656"/g' ~/.omniflixhub/config/config.toml ||
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.025ungm"/g' ~/.omniflixhub/config/app.toml ||
        #Port number TBD all 9 others are in use
            #sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:16657"/g' ~/.omniflixhub/config/config.toml 
            #sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:16656"/g' ~/.omniflixhub/config/config.toml 
            #sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:1090"/g' ~/.omniflixhub/config/app.toml 
            #sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:1091"/g' ~/.omniflixhub/config/app.toml 
            sudo rm -i ~/.omniflixhub/config/genesis.json ||
            wget https://raw.githubusercontent.com/OmniFlix/testnets/main/flixnet-3/genesis.json -P ~/.omniflixhub/config/ ||
            cat << EOF > /etc/systemd/system/omniflixhub.service 
[Unit] 
Description=OmniFlix Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/omniflixhub start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            sudo systemctl daemon-reload ||
            sudo systemctl enable omniflix ||
            sudo systemctl start omniflix ||
            printf '\nFinished!\n';;


#OSMOSIS            
    7) tput setaf 4; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 4; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 4; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 4; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 4; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 4; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 4;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"

#Osmosis cont...
            git clone https://github.com/osmosis-labs/osmosis ||
            cd osmosis ||
            git checkout v6.1.0 || 
            make install ||
            cp ~/go/bin/osmosisd /usr/bin/osmosisd ||
            osmosisd init $NAME ||
            sed -i 's/seeds = ""/seeds ="aef35f45db2d9f5590baa088c27883ac3d5e0b33@3.108.102.92:26656"/g' ~/.osmosis/config/config.toml ||
            sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656"/g' ~/.osmosis/config/config.toml ||
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' ~/.osmosis/config/app.toml ||
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:36657"/g' ~/.osmosis/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:36656"/g' ~/.osmosis/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:3090"/g' ~/.osmosis/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:3091"/g' ~/.osmosis/config/app.toml 
            sudo rm -i ~/.osmosis/config/genesis.json ||
            wget https://github.com/comdex-official/networks/raw/main/mainnet/comdex-1/genesis.json -P ~/.osmosis/config/ ||
            cat << EOF > /etc/systemd/system/osmosis.service 
[Unit] 
Description=Osmosis Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/osmsis start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            sudo systemctl daemon-reload ||
            sudo systemctl enable osmosis ||
            sudo systemctl start osmosis ||
            printf '\nFinished!\n';;


#SENTINEL            
    8) tput setaf 6; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	        tput setaf 6; echo 'Your node $NAME is now set'; tput sgr0
            tput setaf 6; echo 'Input Your System Username'; tput sgr0
            read USERNAME
            tput setaf 6; echo 'Your username $USERNAME is now set'; tput sgr0
            tput setaf 6; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	        tput setaf 6; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0


#Starting Progress Bar
            printf '\nStarting...\n'
            function ProgressBar {
            let _progress=(${1}*100/${2}*100)/100
            let _done=(${_progress}*10)/10
            let _left=100-$_done
            _fill=$(printf "%${_done}s")
            _empty=$(printf "%${_left}s")
            tput setaf 6;
            printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"; tput sgr0
            }           
            _start=1
            _end=100
            for number in $(seq ${_start} ${_end})
            do
            sleep 0.1
            ProgressBar ${number} ${_end}
            done  &&
            printf "\n"

#Sentinel cont...
            git clone https://github.com/sentinel-official/hub ||
            cd hub ||
            git checkout v0.8.3 ||
            make install ||
            cd ||
            cp go/bin/sentinelhub /usr/bin/sentinelhub ||
            sentinelhubs init $NAME ||
            sed -i 's/seeds = ""/seeds ="c7859082468bcb21c914e9cedac4b9a7850347de@167.71.28.11:26656"/g' ~/.sentinelhub/config/config.toml ||
            sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656"/g' ~/.sentinelhub/config/config.toml ||
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01udvpn"/g' ~/.sentinelhub/config/app.toml ||
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:26657"/g' ~/.sentinelhub/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:26656"/g' ~/.sentinelhub/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:2090"/g' ~/.sentinelhub/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:2091"/g' ~/.sentinelhub/config/app.toml 
            sudo rm -i ~/.sentinelhub/config/genesis.json ||
            wget https://github.com/sentinel-official/networks/raw/main/sentinelhub-1/genesis.zip -P ~/.sentinelhub/config/ ||
            unzip ~/.sentinelhub/config/genesis.zip ||
            cat << EOF > /etc/systemd/system/sentinel.service 
[Unit] 
Description=Sentinel Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/sentinel start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF
            rm ~/.sentinelhub/data/priv_validator_state.json ||
            wget http://135.181.60.250:8083/sentinel/sentinelhub-2_$(date +"%Y-%m-%d").tar -P ~/.sentinelhub/data ||
            tar -xvf ~/.sentinelhub/data/sentinelhub-2_$(date +"%Y-%m-%d").tar ||
            sudo systemctl daemon-reload ||
            sudo systemctl enable sentinel ||
            sudo systemctl start sentinel ||
            printf '\nFinished!\n';;
    9) echo "selected Logs";;
    10) echo "selected Cancel";;
esac
