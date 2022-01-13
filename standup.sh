#!/bin/bash

cat << "EOF"

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
╚═╝░░╚══╝░╚════╝░╚═════╝░╚══════╝  ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝░╚═════╝░╚══════╝╚═╝░░╚═╝
                                                                                                                                                                              

EOF

# OS Select 

PS3='Select your OS: '
options=("Arch Linux" "Ubuntu" "Quit" "My OS is set up")
select opt in "${options[@]}"
do
    case $opt in
        "Arch Linux")
            pacman -Syyu aria2 atop autoconf automake base binutils bison bmon btrfs-progs btop clang cronie cryptsetup docker dstat fakeroot flex gcc git go gptfdisk groff grub haveged htop iftop iptraf-ng jq llvm lvm2 m4 make mdadm neovim net-tools nethogs openssh patch pkgconf python rsync rustup screen sudo texinfo unzip vi vim vnstat wget which xfsprogs hddtemp python-setuptools npm python-bottle python-docker python-matplotlib python-netifaces python-zeroconf python-pystache time nload nmon glances gtop bwm-ng bpytop duf go-ipfs fish pigz zerotier-one sysstat github-cli pm2; break;;


        "Ubuntu")
            apt-get update -y && apt install -y tar unzip wget curl gcc make snap && snapd install go --classic; break;;

	"My OS is set up")
		break;;
        "Quit")
            exit;;

    esac
done

# Network Select

PS3='Select a network: '
options=("Akash" "Sentinel" "Chihuahua" "Comdex" "Dig" "e-Money" "G-Bridge" "Omniflix" "Osmosis" "Sentinel" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Akash")
                PS3='Would you like to run a Mainnet or Testnet Node?'
                options=("Mainnet" "Testnet" "Go Back")
                select opt in "${options[@]}"
                do
                        case $opt in
                                "Mainnet")
                                        wget https://github.com/ovrclk/akash/releases/download/v0.14.1/akash_0.14.1_linux_amd64.zip
                                        unzip akash_0.14.1_linux_amd64.zip
                                        sudo rm akash_0.14.1_linux_amd64.zip
                                        mv akash_0.14.1_linux_amd64/akash /usr/bin/
                                        sudo rm -i -rf akash_0.14.1_linux_amd64/
                                        akash init node --chain-id akashnet-2
                                        sed -i 's/seeds = ""/seeds ="27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656,8e2f56098f182ffe2f6fb09280ba" ~/.akash/config/config.toml
                                        sed -i 's/persistent_peers = ""/persistent_peers = "27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656" ~/.akash/config/config.toml
                                        sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uakt"/g' ~/.akash/config/app.toml
                                        sudo rm -i ~/.akash/config/genesis.json
                                        wget https://github.com/ovrclk/net/raw/master/mainnet/genesis.json ~/.akash/config/
                                        akash start
                                        cat > /etc/systemd/system/akash.service
                                        echo "[Unit]
                                        Description=Akash Node
                                        After=network.target

                                        [Service]
                                        Type=simple
                                        User=root
                                        WorkingDirectory=/root/
                                        ExecStart=/usr/bin/akash start
                                        Restart=on-failure
                                        StartLimitInterval=0
                                        RestartSec=3
                                        LimitNOFILE=65535
                                        LimitMEMLOCK=209715200

                                        [Install]
                                        WantedBy=multi-user.target" > /etc/systemd/system/akash.service
                                        rm ~/.akash/data/priv_validator_state.json
                                        wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data
                                        tar -xvf ~/.akash/data/akashnet-2_$(date +"%Y-%m-%d").tar
                                        sudo systemctl enable akash
                                        sudo systemctl daemon-reload
                                        sudo systemctl start akash && journalctl -u akash -f; break;;

                                "Testnet")
                                        echo "Sorry this is still a work in progress"
                                        ;;

                                "Go Back")
                                        exit;;
                        esac
                done

            ;;
        "Chihuahua")
            echo "you chose choice 2"

            ;;
        "Comdex")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Dig")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "e-Money")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "G-Bridge")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Omniflix")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Osmosis")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Sentinel")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            exit
            ;;
    esac
done

echo "Delegate to Chandra Station"
