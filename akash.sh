#!/bin/bash

#Stops the bash from looping
#trap "exit" INT

#Downloading the most recent release
wget https://github.com/ovrclk/akash/releases/download/v0.14.1/akash_0.14.1_linux_amd64.zip
unzip akash_0.14.1_linux_amd64.zip
sudo rm akash_0.14.1_linux_amd64.zip
cd akash_0.14.1_linux_amd64/
mv akash /usr/bin/
cd ..
sudo rm -i -rf akash_0.14.1_linux_amd64/

#Initialization
akash init node-1 --chain-id akashnet-2

#Adding Seeds
sed -i 's/seeds = ""/seeds ="27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656,8e2f56098f182ffe2f6fb09280ba" .akash/config/config.toml

#Adding Peers
sed -i 's/persistent_peers = ""/persistent_peers = "27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656,47c9a" .akash/config/config.toml

#Adding the gas fee
sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uakt"/g' .akash/config/app.toml

#Adding the ports
#sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uakt"/g' .akash/config/app.toml

#Genesis Update
sudo rm -i .akash/config/genesis.json
wget --directory-prefix=.akash/config/ https://github.com/ovrclk/net/raw/master/mainnet/genesis.json

#Starting Node
#akash start

#Service File
cat > akash.service

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
WantedBy=multi-user.target
" > akash.service
mv akash.service /etc/systemd/system/

#Starting & Journal
sudo systemctl enable akash
sudo systemctl daemon-reload
sudo systemctl start akash && journalctl -u akash -f
