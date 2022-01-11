#!/bin/bash

#Archlinux Setup
while true; do
    read -p "Is this a new Archlinux server?" yn
    case $yn in
        [Yy]* ) pacman -Syyu aria2 atop autoconf automake base binutils bison bmon btrfs-progs btop clang cronie cryptsetup docker dstat fakeroot flex gcc git go gptfdisk groff grub haveged htop iftop iptraf-ng jq llvm lvm2 m4 make mdadm neovim net-tools nethogs openssh patch pkgconf python rsync rustup screen sudo texinfo unzip vi vim vnstat wget which xfsprogs hddtemp python-setuptools npm python-bottle python-docker python-matplotlib python-netifaces python-zeroconf python-pystache time nload nmon glances gtop bwm-ng bpytop duf go-ipfs fish pigz zerotier-one sysstat github-cli pm2; break;;
        [Nn]* ) break;;
	    [Ss]* ) exit;;
        * ) echo "Please answer yes no or stop.";;
    esac
done

#Ubuntu Setup
while true; do
    read -p "Is this a new Ubuntu server?" yn
    case $yn in
        [Yy]* ) apt-get update -y && apt install wget curl gcc make snap; break;;
        [Nn]* ) break;;
	    [Ss]* ) exit;;
        * ) echo "Please answer yes no or stop.";;
    esac
done

#Golang install for Ubuntu
while true; do
    read -p "Need golang on Ubuntu?" yn
    case $yn in
        [Yy]* ) snapd install go --classic; break;;
        [Nn]* ) break;;
	    [Ss]* ) exit;;
        * ) echo "Please answer yes no or stop.";;
    esac
done

#Akash Node
while true; do
    read -p "Do you want to run an Akash Node?" yn
    case $yn in
        [Yy]* ) wget https://github.com/ovrclk/akash/releases/download/v0.14.1/akash_0.14.1_linux_amd64.zip
                unzip akash_0.14.1_linux_amd64.zip
                sudo rm akash_0.14.1_linux_amd64.zip
                mv akash_0.14.1_linux_amd64/akash /usr/bin/
                sudo rm -i -rf akash_0.14.1_linux_amd64/
                akash init node --chain-id akashnet-2
                sed -i 's/seeds = ""/seeds ="27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656,8e2f56098f182ffe2f6fb09280ba" ~/.akash/config/config.toml
                sed -i 's/persistent_peers = ""/persistent_peers = "27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656,47c9acc0e7d9b244a6404458e76d50b6284bfbbb@142.93.77.25:26656,ab7b55588ea3f4f7a477e852aa262959e54117cd@3.235.249.94:26656,4acf579e2744268f834c713e894850995bbf0ffa@50.18.31.225:26656,3691ac1f56389ffec8579c13a6eb8eca41cf8ae3@54.219.88.246:26656,86afe23f116ba4754a19819a55d153008eb74b48@15.164.87.75:26656,6fbc3808f7d6c961e84944ae2d8c800a8bbffbb4@138.201.159.100:26656,a2a3ffe7ac122a218e1f59c32a670f04b8fd3033@165.22.69.102:26656" ~/.akash/config/config.toml
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
                sudo systemctl enable akash
                sudo systemctl daemon-reload
                sudo systemctl start akash && journalctl -u akash -f; break;;
        [Nn]* ) break;;
        [Ss]* ) exit;;
        * ) echo "Please answer yes, no, or stop.";;
    esac
done

#Akash Snapshot
while true; do
    read -p "Snapshot 4 Akash bb?" yn
    case $yn in
        [Yy]* ) rm ~/.akash/data/priv_validator_state.json
                wget http://135.181.60.250/akash/akashnet-2_$(date +"%Y-%m-%d").tar -P ~/.akash/data
                tar -xvf ~/.akash/data break;;
        [Nn]* ) break;;
        [Ss]* ) exit;;
        * ) echo "Please answer yes no or stop.";;
    esac
done

#Chihuahua Node
while true; do
    read -p "Do you want to run a Chihuahuah Node?" yn
    case $yn in
        [Yy]* ) git clone https://github.com/ChihuahuaChain/chihuahua.git
                make install chihuahua/
                chihuahua init node --chain-id chihuahua-1
                sed -i 's/seeds = ""/seeds = "4936e377b4d4f17048f8961838a5035a4d21240c@chihuahua-seed-01.mercury-nodes.net:29540" ~/.chihuahua/config/confi>
                sed -i 's/persistent_peers = ""/persistent_peers = "b140eb36b20f3d201936c4757d5a1dcbf03a42f1@216.238.79.138:26656,19900e1d2b10be9c6672dae7abd1827c8e1aad1e@161.97.96.253:26656,c382a9a0d4c0606d785d2c7c2673a0825f7c53b2@88.99.94.120:26656,a5dfb048e4ed5c3b7d246aea317ab302426b37a1@137.184.250.180:26656,3bad0326026ca4e29c64c8d206c90a968f38edbe@128.199.165.78:26656,89b576c3eb72a4f0c66dc0899bec7c21552ea2a5@23.88.7.73:29538,38547b7b6868f93af1664d9ab0e718949b8853ec@54.184.20.240:30758,a9640eb569620d1f7be018a9e1919b0357a18b8c@38.146.3.160:26656,7e2239a0d4a0176fe4daf7a3fecd15ac663a8eb6@144.91.126.23:26656" ~/.chihuahua/config/confi>
                sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uhuahua"/g' ~/.chihuahua/config/app.toml
		sudo rm -i ~/.chihuahua/config/genesis.json
                wget https://github.com/ChihuahuaChain/mainnet/blob/main/genesis.json ~/.chihuahua/config/
                chihuahua start
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
                sudo systemctl enable chihuahua
                sudo systemctl daemon-reload
                sudo systemctl start chihuahua && journalctl -u chihuahua -f; break;;
        [Nn]* ) break;;
        [Ss]* ) exit;;
        * ) echo "Please answer yes, no, or stop.";;
    esac
done

#Comdex Node

#Dig Node

#E-Money Node
while true; do
    read -p "Do you want to run an e-Money Node?" yn
    case $yn in
        [Yy]* ) 
                e-money init node --chain-id osmosis-1
                sed -i 's/seeds = ""/seeds = "" ~/.e-money/config/config.toml
                sed -i 's/persistent_peers = ""/persistent_peers = "" ~/.e-money/config/config.toml
                sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uosmo"/g' ~/.e-money/config/app.toml
                sudo rm -i ~/.e-money/config/genesis.json
                wget https://github.com/ChihuahuaChain/mainnet/blob/main/genesis.json ~/.e-money/config/
                e-money start
                cat > /etc/systemd/system/e-money.service
                echo "[Unit]
                Description=e-Money Node
                After=network.target

                [Service]
                Type=simple
                User=root
                WorkingDirectory=/root/
                ExecStart=/usr/bin/e-money start
                Restart=on-failure
                StartLimitInterval=0
                RestartSec=3
                LimitNOFILE=65535
                LimitMEMLOCK=209715200

                [Install]
                WantedBy=multi-user.target" > /etc/systemd/system/e-money.service
                sudo systemctl enable e-money
                sudo systemctl daemon-reload
                sudo systemctl start e-money && journalctl -u e-money -f; break;;
        [Nn]* ) break;;
        [Ss]* ) exit;;
        * ) echo "Please answer yes, no, or stop.";;
    esac
done

#G-Bridge Node
while true; do
    read -p "Do you want to run an Osmosis Node?" yn
    case $yn in
        [Yy]* ) 
                gravity init node --chain-id gravity-2
                sed -i 's/seeds = ""/seeds = "" ~/.gravity/config/config.toml
                sed -i 's/persistent_peers = ""/persistent_peers = "" ~/.gravity/config/config.toml
                sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uosmo"/g' ~/.gravity/config/app.toml
                sudo rm -i ~/.gravity/config/genesis.json
                wget https://github.com/ChihuahuaChain/mainnet/blob/main/genesis.json ~/.gravity/config/
                gravity start
                cat > /etc/systemd/system/gravity.service
                echo "[Unit]
                Description=Gravity Node
                After=network.target

                [Service]
                Type=simple
                User=root
                WorkingDirectory=/root/
                ExecStart=/usr/bin/gravity start
                Restart=on-failure
                StartLimitInterval=0
                RestartSec=3
                LimitNOFILE=65535
                LimitMEMLOCK=209715200

                [Install]
                WantedBy=multi-user.target" > /etc/systemd/system/gravity.service
                sudo systemctl enable gravity
                sudo systemctl daemon-reload
                sudo systemctl start gravity && journalctl -u gravity -f; break;;
        [Nn]* ) break;;
        [Ss]* ) exit;;
        * ) echo "Please answer yes, no, or stop.";;
    esac
done

#Sentinel Node
while true; do
    read -p "Do you want to run an Osmosis Node?" yn
    case $yn in
        [Yy]* ) 
                sentinel init node --chain-id sentinel-1
                sed -i 's/seeds = ""/seeds = "" ~/.sentinel/config/config.toml
                sed -i 's/persistent_peers = ""/persistent_peers = "" ~/.sentinel/config/config.toml
                sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01udvpn"/g' ~/.sentinel/config/app.toml
                sudo rm -i ~/.sentinel/config/genesis.json
                wget https://github.com/ChihuahuaChain/mainnet/blob/main/genesis.json ~/.sentinel/config/
                sentinel start
                cat > /etc/systemd/system/sentinel.service
                echo "[Unit]
                Description=Sentinel Node
                After=network.target

                [Service]
                Type=simple
                User=root
                WorkingDirectory=/root/
                ExecStart=/usr/bin/sentinel start
                Restart=on-failure
                StartLimitInterval=0
                RestartSec=3
                LimitNOFILE=65535
                LimitMEMLOCK=209715200

                [Install]
                WantedBy=multi-user.target" > /etc/systemd/system/sentinel.service
                sudo systemctl enable sentinel
                sudo systemctl daemon-reload
                sudo systemctl start sentinel && journalctl -u sentinel -f; break;;
        [Nn]* ) break;;
        [Ss]* ) exit;;
        * ) echo "Please answer yes, no, or stop.";;
    esac
done

#Osmosis Node
while true; do
    read -p "Do you want to run an Osmosis Node?" yn
    case $yn in
        [Yy]* ) 
                osmosis init node --chain-id osmosis-1
                sed -i 's/seeds = ""/seeds = "" ~/.osmosis/config/config.toml
                sed -i 's/persistent_peers = ""/persistent_peers = "" ~/.osmosis/config/config.toml
                sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uosmo"/g' ~/.osmosis/config/app.toml
                sudo rm -i ~/.osmosis/config/genesis.json
                wget https://github.com/ChihuahuaChain/mainnet/blob/main/genesis.json ~/.chihuahua/config/
                osmosis start
                cat > /etc/systemd/system/osmosis.service
                echo "[Unit]
                Description=Osmosis Node
                After=network.target

                [Service]
                Type=simple
                User=root
                WorkingDirectory=/root/
                ExecStart=/usr/bin/osmosis start
                Restart=on-failure
                StartLimitInterval=0
                RestartSec=3
                LimitNOFILE=65535
                LimitMEMLOCK=209715200

                [Install]
                WantedBy=multi-user.target" > /etc/systemd/system/osmosis.service
                sudo systemctl enable osmosis
                sudo systemctl daemon-reload
                sudo systemctl start osmosis && journalctl -u osmosis -f; break;;
        [Nn]* ) break;;
        [Ss]* ) exit;;
        * ) echo "Please answer yes, no, or stop.";;
    esac
done
