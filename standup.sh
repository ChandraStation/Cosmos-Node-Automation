#!/bin/bash

tput setaf 4; echo '
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
					echo "What would you like your node name to be?"
					read NAME
					echo "Your node $NAME is now set"
                                        akash init $NAME --chain-id akashnet-2
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
                                        User=$(whoami)
                                        WorkingDirectory=~/
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
                                        cd chihuahua
                                        git checkout v1.0.0
                                        make install
                                        cp ~/go/bin/chihuahuad /usr/bin/chihuahuad
					echo "What would you like your node name to be?"
					read NAME
					echo "Your node $NAME is now set"
                                        chihuahuad init $NAME --chain-id chihuahua-1
                                        sed -i 's/seeds = ""/seeds ="4936e377b4d4f17048f8961838a5035a4d21240c@chihuahua-seed-01.mercury-nodes.net:29540" ~/.chihuahua/config/config.toml
                                        sed -i 's/persistent_peers = ""/persistent_peers = "b140eb36b20f3d201936c4757d5a1dcbf03a42f1@216.238.79.138:26656,19900e1d2b10be9c6672dae7abd1827c8e1aad1e@161.97.96.253:26656,c382a9a0d4c0606d785d2c7c2673a0825f7c53b2@88.99.94.120:26656,a5dfb048e4ed5c3b7d246aea317ab302426b37a1@137.184.250.180:26656,3bad0326026ca4e29c64c8d206c90a968f38edbe@128.199.165.78:26656,89b576c3eb72a4f0c66dc0899bec7c21552ea2a5@23.88.7.73:29538,38547b7b6868f93af1664d9ab0e718949b8853ec@54.184.20.240:30758,a9640eb569620d1f7be018a9e1919b0357a18b8c@38.146.3.160:26656,7e2239a0d4a0176fe4daf7a3fecd15ac663a8eb6@144.91.126.23:26656" ~/.chihuahua/config/config.toml
                                        sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uhuahua"/g' ~/.chihuahua/config/app.toml
                                        sudo rm -i ~/.chihuahua/config/genesis.json
                                        wget https://github.com/ChihuahuaChain/mainnet/blob/main/genesis.json ~/.chihuahua/config/
                                        cat > /etc/systemd/system/chihuahua.service
                                        echo "[Unit]
                                        Description=Chihuahua Node
                                        After=network.target

                                        [Service]
                                        Type=simple
                                        User=$(whoami)
                                        WorkingDirectory=~/
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
                                        sudo systemctl daemon-reload
                                        sudo systemctl enable chihuahua
                                        sudo systemctl start chihuahua && journalctl -u chihuahua -f; break;;

                                "Testnet")
                                        break;;
                                "Go Back")
                                        break;;
                        esac
                done

            ;;

        "Comdex")
                                        git clone https://github.com/comdex-official/comdex
                                        cd comdex
                                        git checkout v0.0.4
                                        make install
                                        cp ~/go/bin/comdex /usr/bin/comdex
					echo "What would you like your node name to be?"
					read NAME
					echo "Your node $NAME is now set"
                                        comdex init $NAME
                                        sed -i 's/seeds = ""/seeds ="aef35f45db2d9f5590baa088c27883ac3d5e0b33@3.108.102.92:26656" ~/.comdex/config/config.toml
                                        sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656" ~/.comdex/config/config.toml
                                        sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' ~/.comdex/config/app.toml
                                        sudo rm -i ~/.comdex/config/genesis.json
                                        wget https://github.com/comdex-official/networks/raw/main/mainnet/comdex-1/genesis.json ~/.comdex/config/
                                        cat > /etc/systemd/system/comdex.service
                                        echo "[Unit]
                                        Description=Comdex Node
                                        After=network.target

                                        [Service]
                                        Type=simple
                                        User=$(whoami)
                                        WorkingDirectory=~/
                                        ExecStart=/usr/bin/comdex start
                                        Restart=on-failure
                                        StartLimitInterval=0
                                        RestartSec=3
                                        LimitNOFILE=65535
                                        LimitMEMLOCK=209715200

                                        [Install]
                                        WantedBy=multi-user.target" > /etc/systemd/system/comdex.service
                                        #rm ~/.chihuahua/data/priv_validator_state.json
                                        #wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data
                                        #tar -xvf ~/.akash/data/akashnet-2_$(date +"%Y-%m-%d").tar
                                        sudo systemctl daemon-reload
                                        sudo systemctl enable comdex
                                        sudo systemctl start comdex && journalctl -u comdex -f; break;;
            
        "Dig")
                                        git clone https://github.com/osmosis-labs/osmosis
                                        cd osmosis
                                        git checkout v6.1.0
                                        make install
                                        cp ~/go/bin/osmosisd /usr/bin/osmosisd
					echo "What would you like your node name to be?"
					read NAME
					echo "Your node $NAME is now set"
                                        osmosisd init $NAME
                                        sed -i 's/seeds = ""/seeds ="6bcdbcfd5d2c6ba58460f10dbcfde58278212833@osmosis.artifact-staking.io:26656" ~/.osmosis/config/config.toml
                                        sed -i 's/persistent_peers = ""/persistent_peers = "8d9967d5f865c68f6fe2630c0f725b0363554e77@134.255.252.173:26656,785bc83577e3980545bac051de8f57a9fd82695f@194.233.164.146:26656,778fdedf6effe996f039f22901a3360bc838b52e@161.97.187.189:36657,8f67a2fcdd7ade970b1983bf1697111d35dfdd6f@52.79.199.137:26656,00c328a33578466c711874ec5ee7ada75951f99a@35.82.201.64:26656,cfb6f2d686014135d4a6034aa6645abd0020cac6@52.79.88.57:26656" ~/.osmosis/config/config.toml
                                        sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.0uosmo"/g' ~/.osmosis/config/app.toml
                                        sudo rm -i ~/.osmosis/config/genesis.json
                                        wget https://github.com/osmosis-labs/osmosis/raw/main/networks/osmosis-1/genesis.json ~/.osmosis/config/
                                        cat > /etc/systemd/system/osmosis.service
                                        echo "[Unit]
                                        Description=Osmosis Node
                                        After=network.target

                                        [Service]
                                        Type=simple
                                        User=$(whoami)
                                        WorkingDirectory=~/
                                        ExecStart=/usr/bin/osmosisd start
                                        Restart=on-failure
                                        StartLimitInterval=0
                                        RestartSec=3
                                        LimitNOFILE=65535
                                        LimitMEMLOCK=209715200

                                        [Install]
                                        WantedBy=multi-user.target" > /etc/systemd/system/osmosis.service
                                        #rm ~/.chihuahua/data/priv_validator_state.json
                                        #wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data
                                        #tar -xvf ~/.akash/data/akashnet-2_$(date +"%Y-%m-%d").tar
                                        sudo systemctl daemon-reload
                                        sudo systemctl enable osmosis
                                        sudo systemctl start osmosis && journalctl -u osmosis -f; break;;
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
                                        git clone https://github.com/osmosis-labs/osmosis
                                        cd osmosis
                                        git checkout v6.1.0
                                        make install
                                        cp ~/go/bin/osmosisd /usr/bin/osmosisd
					echo "What would you like your node name to be?"
					read NAME
					echo "Your node $NAME is now set"
                                        osmosisd init $NAME
                                        sed -i 's/seeds = ""/seeds ="aef35f45db2d9f5590baa088c27883ac3d5e0b33@3.108.102.92:26656" ~/.osmosis/config/config.toml
                                        sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656" ~/.osmosis/config/config.toml
                                        sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' ~/.osmosis/config/app.toml
                                        sudo rm -i ~/.osmosis/config/genesis.json
                                        wget https://github.com/comdex-official/networks/raw/main/mainnet/comdex-1/genesis.json ~/.osmosis/config/
                                        cat > /etc/systemd/system/osmosis.service
                                        echo "[Unit]
                                        Description=Osmosis Node
                                        After=network.target

                                        [Service]
                                        Type=simple
                                        User=$(whoami)
                                        WorkingDirectory=~/
                                        ExecStart=/usr/bin/osmosisd start
                                        Restart=on-failure
                                        StartLimitInterval=0
                                        RestartSec=3
                                        LimitNOFILE=65535
                                        LimitMEMLOCK=209715200

                                        [Install]
                                        WantedBy=multi-user.target" > /etc/systemd/system/osmosis.service
                                        #rm ~/.chihuahua/data/priv_validator_state.json
                                        #wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data
                                        #tar -xvf ~/.akash/data/akashnet-2_$(date +"%Y-%m-%d").tar
                                        sudo systemctl daemon-reload
                                        sudo systemctl enable osmosis
                                        sudo systemctl start osmosis && journalctl -u osmosis -f; break;;
        "Sentinel")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            exit
            ;;
    esac
done

echo "Delegate to Chandra Station"
