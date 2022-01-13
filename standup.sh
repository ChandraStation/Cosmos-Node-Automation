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
options=("Arch Linux" "Ubuntu" "My OS is set up" "Quit")
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
options=("Akash" "Chihuahua" "Comdex" "Dig" "e-Money" "G-Bridge" "Omniflix" "Osmosis" "Sentinel" "Quit")
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
                                        break;;
                                "Go Back")
                                        break;;
                        esac
                done

            ;;
        "Chihuahua")
                PS3='Would you like to run a Mainnet or Testnet Node?'
                options=("Mainnet" "Testnet" "Go Back")
                select opt in "${options[@]}"
                do
                        case $opt in
                                "Mainnet")
                                        git clone https://github.com/ChihuahuaChain/chihuahua.git
                                        #cd chihuahua
                                        make install chihuahua/
                                        chihuahuad init $MONIKER_NAME --chain-id chihuahua-1
                                        sed -i 's/seeds = ""/seeds ="4936e377b4d4f17048f8961838a5035a4d21240c@chihuahua-seed-01.mercury-nodes.net:29540" ~/.chihuahua/config/config.toml
                                        sed -i 's/persistent_peers = ""/persistent_peers = "b140eb36b20f3d201936c4757d5a1dcbf03a42f1@216.238.79.138:26656,19900e1d2b10be9c6672dae7abd1827c8e1aad1e@161.97.96.253:26656,c382a9a0d4c0606d785d2c7c2673a0825f7c53b2@88.99.94.120:26656,a5dfb048e4ed5c3b7d246aea317ab302426b37a1@137.184.250.180:26656,3bad0326026ca4e29c64c8d206c90a968f38edbe@128.199.165.78:26656,89b576c3eb72a4f0c66dc0899bec7c21552ea2a5@23.88.7.73:29538,38547b7b6868f93af1664d9ab0e718949b8853ec@54.184.20.240:30758,a9640eb569620d1f7be018a9e1919b0357a18b8c@38.146.3.160:26656,7e2239a0d4a0176fe4daf7a3fecd15ac663a8eb6@144.91.126.23:26656" ~/.chihuahua/config/config.toml
                                        sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uhuahua"/g' ~/.chihuahua/config/app.toml
                                        sudo rm -i ~/.chihuahua/config/genesis.json
                                        wget https://github.com/ChihuahuaChain/mainnet/blob/main/genesis.json~/.chihuahua/config/
                                        cat > /etc/systemd/system/chihuahua.service
                                        echo "[Unit]
                                        Description=Chihuahua Node
                                        After=network.target

                                        [Service]
                                        Type=simple
                                        User=root
                                        WorkingDirectory=/root/
                                        ExecStart=/usr/bin/chihuahua start
                                        Restart=on-failure
                                        StartLimitInterval=0
                                        RestartSec=3
                                        LimitNOFILE=65535
                                        LimitMEMLOCK=209715200

                                        [Install]
                                        WantedBy=multi-user.target" > /etc/systemd/system/chihuahua.service
                                        #rm ~/.chihuahua/data/priv_validator_state.json
                                        #wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data
                                        #tar -xvf ~/.akash/data/akashnet-2_$(date +"%Y-%m-%d").tar
                                        sudo systemctl enable chihuahua
                                        sudo systemctl daemon-reload
                                        sudo systemctl start chihuahua && journalctl -u chihuahua -f; break;;

                                "Testnet")
                                        break;;
                                "Go Back")
                                        break;;
                        esac
                done

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
