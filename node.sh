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
options=("Akash" "Chihuahua" "Comdex" "Dig" "e-Money" "G-Bridge" "Omniflix" "Osmosis" "Sentinel" "Logs" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Akash")
            echo "What would you like your node name to be?"
	        read NAME
	        echo "Your node $NAME is now set"
            wget https://github.com/ovrclk/akash/releases/download/v0.14.1/akash_0.14.1_linux_amd64.zip
            unzip akash_0.14.1_linux_amd64.zip
            sudo rm akash_0.14.1_linux_amd64.zip
            mv akash_0.14.1_linux_amd64/akash /usr/bin/
            sudo rm -i -rf akash_0.14.1_linux_amd64/
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
            sudo systemctl start akash; break;;

        "Chihuahua")
			echo "What would you like your node name to be?"
			read NAME
			echo "Your node $NAME is now set"
            git clone https://github.com/ChihuahuaChain/chihuahua.git
            cd chihuahua
            git checkout v1.0.0
            make install
            cp ~/go/bin/chihuahuad /usr/bin/chihuahuad
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
            sudo systemctl start chihuahua; break;;

        "Comdex")
			echo "What would you like your node name to be?"
			read NAME
			echo "Your node $NAME is now set"
            git clone https://github.com/comdex-official/comdex
            cd comdex
            git checkout v0.0.4
            make install
            cp ~/go/bin/comdex /usr/bin/comdex
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
            sudo systemctl start comdex; break;;
            
        "Dig")
			echo "What would you like your node name to be?"
			read NAME
			echo "Your node $NAME is now set"
            git clone https://github.com/notional-labs/dig
            cd dig
            git checkout v1.1.0
            cd cmd/digd
            go install ./...
            cd
            cp ~/go/bin/digd /usr/bin/digd
            digd init $NAME
            sed -i 's/seeds = ""/seeds ="37b2839da4463b22a51b1fe20d97992164270eba@62.171.157.192:26656,e2c96b96d4c3a461fb246edac3b3cdbf47768838@65.21.202.37:6969" ~/.dig/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "33f4788e1c6a378b929c66f31e8d253b9fd47c47@194.163.154.251:26656,64eccffdc60a206227032d3a021fbf9dfc686a17@194.163.156.84:26656,be7598b2d56fb42a27821259ad14aff24c40f3d2@172.16.152.118:26656,f446e37e47297ce9f8951957d17a2ae9a16db0b8@137.184.67.162:26656,ab2fa2789f481e2856a5d83a2c3028c5b215421d@144.91.117.49:26656,e9e89250b40b4512237c77bd04dc76c06a3f8560@185.214.135.205:26656,1539976f4ee196f172369e6f348d60a6e3ec9e93@159.69.147.189:26656,85316823bee88f7b05d0cfc671bee861c0237154@95.217.198.243:26656,eb55b70c9fd8fc0d5530d0662336377668aab3f9@185.194.219.128:26656" ~/.dig/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.025udig"/g' ~/.dig/config/app.toml
            sudo rm -i ~/.dig/config/genesis.json
            wget https://raw.githubusercontent.com/notional-labs/dig/master/networks/mainnets/dig-1/genesis.json ~/.dig/config/
            cat > /etc/systemd/system/dig.service
            echo "[Unit]
            Description=Dig Node
            After=network.target

            [Service]
            Type=simple
            User=$(whoami)
            WorkingDirectory=~/
            ExecStart=/usr/bin/digd start
            Restart=on-failure
            StartLimitInterval=0
            RestartSec=3
            LimitNOFILE=65535
            LimitMEMLOCK=209715200

            [Install]
            WantedBy=multi-user.target" > /etc/systemd/system/dig.service
            #rm ~/.chihuahua/data/priv_validator_state.json
            #wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data
            #tar -xvf ~/.akash/data/akashnet-2_$(date +"%Y-%m-%d").tar
            sudo systemctl daemon-reload
            sudo systemctl enable dig
            sudo systemctl start dig; break;;

        "e-Money")
			echo "What would you like your node name to be?"
			read NAME
			echo "Your node $NAME is now set"
            ;;
        "G-Bridge")
			echo "What would you like your node name to be?"
			read NAME
			echo "Your node $NAME is now set"
            ;;
        "Omniflix")
			echo "What would you like your node name to be?"
			read NAME
			echo "Your node $NAME is now set"
            ;;
        "Osmosis")
			echo "What would you like your node name to be?"
			read NAME
			echo "Your node $NAME is now set"
            git clone https://github.com/osmosis-labs/osmosis
            cd osmosis
            git checkout v6.1.0
            make install
            cp ~/go/bin/osmosisd /usr/bin/osmosisd
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
            sudo systemctl start osmosis; break;;

        "Sentinel")
			echo "What would you like your node name to be?"
			read NAME
			echo "Your node $NAME is now set"
            git clone https://github.com/sentinel-official/hub
            cd hub
            git checkout v0.8.3
            make install
            cp ~/go/bin/sentinelhub /usr/bin/sentinelhub
            osmosisd init $NAME
            sed -i 's/seeds = ""/seeds ="c7859082468bcb21c914e9cedac4b9a7850347de@167.71.28.11:26656" ~/.sentinelhub/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656" ~/.sentinelhub/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01udvpn"/g' ~/.sentinelhub/config/app.toml
            sudo rm -i ~/.sentinelhub/config/genesis.json
            wget https://github.com/sentinel-official/networks/raw/main/sentinelhub-1/genesis.zip ~/.sentinelhub/config/
            unzip ~/.sentinelhub/config/genesis.zip
            cat > /etc/systemd/system/sentinel.service
            echo "[Unit]
            Description=Sentinel Node
            After=network.target

            [Service]
            Type=simple
            User=$(whoami)
            WorkingDirectory=~/
            ExecStart=/usr/bin/sentinelhub start
            Restart=on-failure
            StartLimitInterval=0
            RestartSec=3
            LimitNOFILE=65535
            LimitMEMLOCK=209715200

            [Install]
            WantedBy=multi-user.target" > /etc/systemd/system/sentinel.service
            #rm ~/.chihuahua/data/priv_validator_state.json
            #wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data
            #tar -xvf ~/.akash/data/akashnet-2_$(date +"%Y-%m-%d").tar
            sudo systemctl daemon-reload
            sudo systemctl enable sentinel
            sudo systemctl start sentinel; break;;

        "Quit")
            exit
            ;;
    esac
done

echo "Delegate to Chandra Station"
