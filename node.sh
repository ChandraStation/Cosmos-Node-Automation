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
    0) pacman -Syyu aria2 atop autoconf automake base binutils bison bmon btrfs-progs btop clang cronie cryptsetup docker dstat fakeroot flex gcc git go gptfdisk groff grub haveged htop iftop iptraf-ng jq llvm lvm2 m4 make mdadm neovim net-tools nethogs openssh patch pkgconf python rsync rustup screen sudo texinfo unzip vi vim vnstat wget which xfsprogs hddtemp python-setuptools npm python-bottle python-docker python-matplotlib python-netifaces python-zeroconf python-pystache time nload nmon glances gtop bwm-ng bpytop duf go-ipfs fish pigz zerotier-one sysstat github-cli pm2 jq;;


#Ubuntu
    1) apt-get update -y && apt install -y tar unzip wget curl gcc make snap && snapd install go --classic && snapd install jq;;


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

case `select_opt "Akash" "Canto" "Chihuahua" "Comdex" "Evmos" "Gravity" "Kava" "Osmosis" "Passage" "Stride" "Cancel"` in
    
#AKASH = DONE
    0)  tput setaf 1; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 1; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 1; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 1; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 1; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 1; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
            response_akash=$(curl -s https://akash.api.chandrastation.com/node_info)
            export AKASH_VERSION=$(echo $response_akash | jq -r '.application_version.version')
            git clone https://github.com/ovrclk/akash
            cd akash/
            git checkout $AKASH_VERSION
	        make install 
        cp ~/go/bin/akash /usr/bin/ 
        akash init $NAME --chain-id akashnet-2 --home $WORKINGDIRECTORY/.akash/
        SNAP_RPC_1="https://akash-rpc.polkachu.com:443"
        SNAP_RPC_2="http://akashsentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds ="27eb432ccd5e895c5c659659120d68b393dd8c60@35.247.65.183:26656"/g' $WORKINGDIRECTORY/.akash/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "ba4ea7c936a3321bb4c65c057f7d5792b5011a25@103.180.28.208:26656,79f5ccf894f33bf81d9379e7bf1a95b80f75cf91@62.133.229.34:26656,9abcfdd6b42ed85b2dbec2e7f839611df396ff1f@194.146.12.226:26656,2a3ba81a7ddb00016af1593f925aed390c4bcca9@64.227.108.195:26656,cb6ae22e1e89d029c55f2cb400b0caa19cbe5523@99.79.123.92:26603,47f7b7a021497ad7a338ea041f19a1a11ae06795@38.75.136.93:26656,c1474d697ca6d9acb19522c2ef23b9e59aac8081@68.142.182.44:26656,d5d9ea4c83e4debe23a40df77ada937177a922ce@81.6.58.121:26656,13e17b356b5e97ce754c94aeb9c74e846d018bdb@85.237.193.106:26656,bbf7cbfd305c89ef4a19c5cd9c9b4ae272dd72ea@104.238.221.73:28656,7001280de176c2ce4d9c06c05179a6ebe25a46fc@13.228.88.45:26656,c124ce0b508e8b9ed1c5b6957f362225659b5343@134.65.192.97:26656,0252235785795eb2e379fca929ac4441b6da087e@95.216.97.167:12856,6adc00bef235246c90757547d5f0703d6a548460@178.128.82.28:26656,601462e3538bad99a06013bc2e30cfddcf4cded7@193.70.45.106:12856,30b8008d4ea5069a8724a0aa73833493efa88e67@65.108.140.62:26656,0af9b517def63d7d0ef1b22ff7bccabd2f2c6b68@50.21.167.157:26656,05c30fd95b888ca8df8171ce65a06f1de683d6e3@84.252.129.17:26656,a5a3681d5b0eb4113fb7f0e49c232d3b5bf9ac15@85.203.164.153:26656,ae80e704ee143075ebd1a92996f4eb5c208ebcee@172.105.110.122:2020,e98cda983054e8507d8e4d37910a9cdb1ff978a8@149.56.18.196:26656,bd2525f1a86af8b1a3798c04387f47f0c0627d24@159.223.201.38:26656,6e82ac725aa4d8df49c1e9277606e1d75199537a@51.91.70.90:39656,42f173cf91e2ed30a9ad2526a61c1bb8a5f94448@89.149.218.76:26656,5c7644833f9c2cac09f05deba75e72038f18811d@89.149.218.66:26656,f9ab65d13095d615e65393f57f12a037660b6d1f@125.253.92.221:36656,af1258e2853d14b0a14baf4462dfb9bb57eeb6f0@74.50.94.66:46656,f31426d9fb39c2d97653722a34b4c72db71904c2@93.115.25.106:29656,86afe23f116ba4754a19819a55d153008eb74b48@15.164.87.75:26656,ff3e588cbfb126cff4737ebd8dbcdc7d0f61d4c5@86.32.74.154:26656,8e81452f92a87acd45c071d6e7f87d967ab9db9e@95.111.246.150:26656,d2247f7b919f0781c90ee61958d7044665a22d38@134.65.193.200:26656,cb75f43879cc240982b69f4441fe568eed3ea21b@86.111.48.109:26656,20180c45451739668f6e272e007818139dba31e7@88.198.62.198:2020,dda1f59957f767e20b0fc64b1c915b4799fc0cc5@159.223.201.93:26656,4acf579e2744268f834c713e894850995bbf0ffa@50.18.31.225:26656,429651030eb3b48f728c8b11036b0a43328611b6@51.81.106.55:36656,02b5a74f0cc909045efe170da3cc5706de2c0be5@88.208.243.62:26656,dc2e6597aa6065a16d1b0067930db042eaf45871@135.148.55.229:12856,3dd862780dde4b86688c086fcf27a2ac08d29e3a@188.214.129.233:29656,5a7599058e1bb208c6d8fe1e8e514d7bd6559980@146.59.81.92:29656,f9073ba85d59efcb4cc4ffebd5c1ba981350a717@142.54.191.218:26656,cd2ead0b80f99ff57a7499efe6a10faa819169d0@188.243.63.8:26656,30da0ee2c35abce21e6160e43f03ece0f18cdfe7@144.76.63.67:26219,cca5fa8c0cdf2c85fcf3100b3863f67099d74ebb@144.91.95.105:26656,ebc272824924ea1a27ea3183dd0b9ba713494f83@95.214.55.198:26696,e7340561cb84ff46311b5fbae582a146a9f97393@65.108.6.185:26656,1e8aaf3654887a05caeb0c1f73ce39e859e2f0c9@159.223.201.86:26656,d04313506795e4d6fa94c8d92ce46de47e8d2263@38.242.154.140:26656,0fb2aedf31480ebadaa7f27a14077ad9b2241bdb@44.224.104.33:26656"/g' $WORKINGDIRECTORY/.akash/config/config.toml 
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01uakt"/g' $WORKINGDIRECTORY/.akash/config/app.toml
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.akash/config/config.toml
        sudo rm $WORKINGDIRECTORY/.akash/config/genesis.json 
            wget https://github.com/ovrclk/net/raw/master/mainnet/genesis.json -P $WORKINGDIRECTORY/.akash/config/ 
            cat << EOF > /etc/systemd/system/akash.service 
[Unit] 
Description=Akash Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/akash start --home $WORKINGDIRECTORY/.akash/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload 
        sudo systemctl enable akash
        sudo systemctl start akash
	    tput setaf 1; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u akash -f --no-hostname -o cat`'; tput sgr0;;

#CANTO = DONE
    1)  tput setaf 2; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 2; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 2; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 2; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 2; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 2; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
            response_canto=$(curl -s https://canto.api.chandrastation.com/node_info)
            export CANTO_VERSION=$(echo $response_canto | jq -r '.application_version.version')
            git clone https://github.com/Canto-Network/Canto 
            cd Canto/
            git checkout $CANTO_VERSION
            make install
        cp ~/go/bin/cantod /usr/bin/
        cantod init $NAME --chain-id canto_7700-1 --home $WORKINGDIRECTORY/.cantod/
        SNAP_RPC_1="https://canto-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://cantosentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:15556"/g' $WORKINGDIRECTORY/.cantod/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "744294d2ecf5ddf14065be6d325e68dcbdf0c646@66.172.36.136:51656,f9fc759eb2fa4eb2159825cae149ba1065efa236@66.172.36.134:51656,81f89cfa6dd6ec4cb2ee297e67dd4613657c4194@88.198.32.17:30656,bea21c6cc721726a486dbd7f14c5e81ee12f6eaa@35.83.23.119:26656,f9f8f88dfde1bacca2f152089bb20c600dbb9d04@43.204.152.200:26656,510e68d0b0ccb903663637547bf641961c4c9987@185.229.119.216:26656,2d7826e04685c4afb7baf6a045a3098c1306e1cc@5.9.108.156:35095,8cb9419ede1d830e78b4dd1318bdbd4e6be000d7@144.76.27.79:36656,f3a0c2e660defc476dfe555ab128790422db1cf9@195.201.171.173:27656,76789b7d030697abbb9b0f1bed103abb4a66c029@138.201.85.176:26676,a441b9fec8006f28fb2add0517fa823b886834d6@5.79.79.80:35095,1d3ab5cc05452e29d8dafb4f96fcf3841c485287@51.210.223.185:35095,9723b0dac535d9e5c28e62413ddda54386ff8955@138.201.249.155:26656,bc091cdde82ad9a27a6b2b279b280aab1041d9bf@13.53.40.117:26656,8b2ac4899b5a0b6e289850bde707f45421d1e9a4@213.239.207.175:30656,43393ba9763a9b1b95785330c5059811e5ed7f91@95.217.122.80:17656,685c48cbc2ba54e20f49645d48b0878d6944d8e4@65.109.94.221:32656,978a3730fc791492c009ff380d8e8bb25997da1b@65.109.65.210:29656,b8cc93a20982f6e7dd0201757c642d2ddc76eee9@148.251.53.202:26656,484e252942ffcc0c6e31278ac0f47a3ca1317aef@142.132.238.165:26656,2ba20f6ff6be62590447ec964bb51bd67460f492@5.9.107.174:36656,16a92f17853f21032161829ef567c66bd483e387@137.184.225.205:26656,61c8c3dce43e7221a5dab1a3c86366f34d2edddd@213.239.215.77:26656,876a17aa48201ec9b8937d81e28b44bfcb4d318c@15.235.115.149:10004,34828d479df21e65068b6aa7b885cfaa6acb4118@5.75.140.177:26656,f724d16c43147bad59a036f243aa79c6f4455d2d@23.88.69.167:26858,cdad27c5be53788cbf42dd1336adeabc253b6e52@38.242.251.238:26656,82956d94714ded8fd785acb498a0aeb7aafad7ff@85.17.6.142:26656,5401995b201605a03d9e1fd0460cbef49218bbf5@65.108.126.46:32656,6ed040a6d393738c1bbeebd200c2e2f660614907@135.181.222.179:28656,bedcf918f53967cd37a0d03e67997d1b40c6c152@5.161.113.61:26656,fa20e4f196268858f56213c77bfa5481aeab4547@66.206.15.130:26656,f74639c33b7647b0462e634974147c20505747a6@213.239.216.252:23656,6085683689776e7103ea5ea87c0f74d9a69e21a2@167.235.200.184:26656,e6d62aa5215719eb1b7434e19bca4e7f62923ef4@65.108.106.172:58656,0da4f6242164ea9ce74bf6e8602c32d408140693@95.217.77.23:27656,c9e39b78c37b1bd360676d1e68f40a1f6c36d528@109.236.86.96:36656,69c21a89c74d08cb4a3c463dc813fe279fe4f080@51.79.160.214:26656,4fb5a871a1f263752da75e323e2ed73ed315a17f@95.214.52.138:26666,4a6ff3311b13fea6db8e6f28bb4a1527df3371bf@65.109.162.26:26656,54316791649b65af344432bf4bd31f46df0cb79c@51.195.234.49:27756,7be1b2faf6a308b6d445edb40f9598195f2455d9@148.251.41.20:26656,ab88f189db7825f376050a034d8bf0028442cfc3@34.89.161.101:26656,5ce67581ef51b30c70212a870f2e5ede27c31929@65.109.20.109:26656,ebd18bdf64ac9b8d0e38ab8706fcf9ee1d54e70a@95.217.35.186:60656,6e7e9341fba194988d448393b2d77464107385c5@65.108.199.222:22496,d36a57b72f12cc648aeb0b417002a2dc390c76c2@89.58.19.40:26656,a0a165866cf5408ed26459ff91e3968807fb13dd@152.228.215.7:26656,439d6746ec2ddeb03a4328e9ab1d0806e5d46ccd@34.252.21.196:26656,8e4d886e7c333e73cdf1f0271b05511a1866d515@65.109.49.163:56656,ec623695c6dfaa265d9d7f5e3b058c51bca63f4f@65.108.124.219:27656,9188d4b9b9e1a7e86ac6a0e6bee343e4c5f6fa25@114.32.170.200:26656,325eaed0931fc7d743c6ee9b124bca334ff8dc2c@65.109.92.241:21216,a93a2839d71a1a705c912163fcf3280e674c5647@204.93.241.110:27650,95296d725bf8d869147e33d236c3cb6102601529@95.217.192.230:46656,855dc3bfa1303bc8de211181918de78f1d9be7c8@67.205.146.202:26656,c7e5de7911802a8c7f80c046ad93152476898d56@202.61.194.254:36656,1797a6e3a45ea538dc669e296e5f76a3b510d101@65.109.29.150:26656,f77128aa0e32853a5938642521990a69b4ae95e7@144.76.195.147:26656,3b25a50bf0fd8f5e776d2e17f4a0d75883bca7fb@65.108.227.42:26656,f15b2375cbfb2b9200096e311b8a1f703e7c2a68@149.102.153.162:26656,81fc7f83e9961790a279a1fbe3e2835cea032d0c@37.252.184.229:26656,43882ebdac4fef48671b35c236122cfcefef413c@63.141.239.202:26656,80e65f207db973bc98d5b02daf5db0607b0a382e@66.172.36.133:51656,26c20d0d4875abfbb9269e5cd57e8f9245ff4c71@65.108.126.35:27656,36707368a40d6bffc78607932a6ab1041058c337@54.228.70.29:26656,74346567ad07541f8163be580c2b6667a1f97fe5@95.214.53.105:36656,0ea8451a880b469be9f94a379dc2b63ea829d16a@208.91.106.29:26656,42e5c9923c06e2100a19814c2fffbbdea641032d@15.235.114.194:10456,7c148e004ec16f7849e148ba56e6a985202105a3@34.207.111.238:26656,6b90bb94063007ff88c14585debd84ababd7d637@65.108.79.198:26766,21fbfac4b643d06ed0edf92e22b2836a1a6e06a2@195.201.123.208:26656,64172382922c636354387436d7e3b494b1abf577@46.10.221.196:26656,cf5dc9c8eb848ce339e4ce7af7db50a46799edef@146.190.136.204:26656,174f015f606fd1f139447158b81a1824f6352854@65.108.75.107:16656,acabacac1035aa397986dc4857df3e02c75af3b0@209.195.12.133:26678,59402a36fad885b6ebf39a218a49c1a833f074ad@206.189.20.122:26656,e8c319413af0063eedca8a8116c969eb34606571@65.1.127.238:26656,626de9047438626ba9a90840ad053dd5d6628844@3.7.14.149:26656"/g' $WORKINGDIRECTORY/.cantod/config/config.toml
            sed -i 's/minimum-gas-prices = "0acanto"/minimum-gas-prices = "4000000000000acanto"/g' $WORKINGDIRECTORY/.cantod/config/app.toml 
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.cantod/config/config.toml
        sudo rm $WORKINGDIRECTORY/.cantod/config/genesis.json 
            wget https://snapshots.polkachu.com/genesis/canto/genesis.json -P $WORKINGDIRECTORY/.cantod/config/ 
            cat << EOF > /etc/systemd/system/cantod.service 
[Unit] 
Description=Canto Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/cantod start --home $WORKINGDIRECTORY/.cantod/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        systemctl daemon-reload 
        systemctl enable cantod
        systemctl start cantod
	    tput setaf 2; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u cantod -f --no-hostname -o cat`'; tput sgr0;;

#CHIHUAHUA = DONE
    2)  tput setaf 3; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 3; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 3; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 3; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 3; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 3; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_chihuahua=$(curl -s https://chihuahua.api.chandrastation.com/node_info)
            export CHIHUAHUA_VERSION=$(echo $response_chihuahua | jq -r '.application_version.version')
            git clone https://github.com/ChihuahuaChain/chihuahua.git
            cd chihuahua
            git checkout $CHIHUAHUA_VERSION
            make install
        mv ~/go/bin/chihuahuad /usr/bin/
        chihuahuad init $NAME --chain-id chihuahua-1 --home $WORKINGDIRECTORY/.chihuahuad/
        SNAP_RPC_1="https://chihuahua-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://chihuahuasentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:12956"/g' $WORKINGDIRECTORY/.chihuahuad/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "b212d5740b2e11e54f56b072dc13b6134650cfb5@169.155.45.138:26656,471518432477e31ea348af246c0b54095d41352c@88.198.129.77:26656,b90228e67cf53c0856d035f5572c4145038d1226@15.204.198.82:26656,62af33efd5bf492038baff03bdc7924dd7528a10@155.133.22.8:23356,8e538cc06ef5493a12c5238831dc81ebd8f0dcb3@167.235.240.250:26656,02786af13c2da91969f5d56f056671bf91f208a5@190.2.146.45:26656,561eb93e3d8a09afd5cb3bb4ce988d4767ab1698@142.44.138.212:26656,55aa7aac517b85bad6ee7fb41707029a331ccba0@15.235.66.89:10556,f924bd81748ec9aa8ac6b2f976bb0c4d477d685d@95.214.55.210:26656,f0266cd6868233b94e94c986cca8fce5ee16246e@65.108.126.215:26656,447faf8fc9f5376987c15e5f260fced9c34e3cdd@135.148.169.198:12956,35c4ddfed043793d0c9fb8555cd1623fb46f5128@148.251.13.186:12956,0f97f82883b409652a2b23ba8c2e05d5d85aa530@73.190.98.73:26656,c2ef001f240ba7951a0bf851e5be6975382ca683@198.244.179.233:26656,8e4e1f1e087c76c71c64e477e95495833da82aa2@135.181.172.189:26656,982e8c3c0c7e335bec561df5b1434faf6ab21fa3@185.111.159.232:2000,363de2b6a56db5f255e3af573416866f2a90abbe@162.55.3.46:26656,a13b0de5c0d520d927f426730018bb7ab5b31de9@130.193.58.105:26656,dc5b51a337b6467e568f255ef0b5d52872edd05a@95.216.144.130:26656,a8f339d59480908c9b1c420735ed15f577f218c5@185.119.118.112:3000,b5bee8a47c6034b8bfb8a07379417e099cea3ed0@65.108.71.166:58656,d542a7b1798285c7d2dd58defbe5cddc811bdc75@138.68.40.251:26656,43d4cb032bb5992425ca1e8765bd78442b9dfa24@89.58.18.61:2000,2e1e9ccd68c1f25016168fc050aed900b553fdb0@185.242.112.32:56646,43300b110d3ff8df2de151a45af8ec8b8463cc50@65.108.207.236:27656,aa30ee7e94ac37b86edad53c32a65df74dc2bad8@95.217.41.162:26656,1384c83c733a54f55b0be8411df4afad2ec1441b@43.130.40.236:26656,89757803f40da51678451735445ad40d5b15e059@169.155.169.156:26656,e726816f42831689eab9378d5d577f1d06d25716@176.9.188.21:26656,4e1c2471efb89239fb04a4b75f9f87177fd91d00@135.181.172.237:26656,2faf86d3587c1f6ee4cfce8434a6b5ef61e54c21@65.21.228.161:2000,d2247f7b919f0781c90ee61958d7044665a22d38@169.155.168.193:26656,e1b058e5cfa2b836ddaa496b10911da62dcf182e@138.201.8.248:26656,00e2874c161411f023e9df6a4847646b0214bff1@38.242.199.168:26656,2f4a46092cb03e5d284e77dd6f147572dd20ebda@142.132.147.146:26656,a7d96dc929824613315dcc1c90fee119f28cc51f@169.155.45.237:26656,f1c7ced9a638bf1a4655401f96c28d750299294e@3.115.224.9:26656,d40a6fa0d2592ee3ac5d8ffa0ea2646ad76a18ce@188.165.230.75:12956,dde6d562c36d78fa2e3e4d62cde94a99c43f2c25@65.109.89.19:12956,acfd8c6af6b3ecbe729ebecc6e30f0c850f20ede@65.108.238.102:12956,b1c5cd0537fee4ae20b91d8def5610f3768479f4@65.144.145.234:26656,2bc2e7c2df7bd56edf4c88c237cf917504392c86@162.55.92.114:2050,f01a0195f6e00e4384be16950a50f677c9abc60d@193.70.45.106:12956,16b233ebedd6a88ba298f37cbe8a9fb2e6358fa5@135.181.215.62:3440,37457d8dc778b7b5bb9de619c15a06f9231cacdd@194.163.183.83:26656,2c82317311aba7f42bfdfb7a0fb466f460721ea0@116.202.36.240:10356,7d312859acdc6af2d0798b5ea81204424c4ae0f5@162.19.89.8:10156,015506eb1e6599a9a204fdd12ad66ab098011d1d@104.131.31.5:26656,0afa8c9ee6d1e15e664467b10393cb9a0f9efd7c@207.244.255.229:10023,08c9e9249390355982d8b6fb68e2dbfb90a1c4ce@167.172.23.189:26656,c382a9a0d4c0606d785d2c7c2673a0825f7c53b2@65.21.131.216:27756"/g' $WORKINGDIRECTORY/.chihuahuad/config/config.toml
            sed -i 's/minimum-gas-prices = "0stake"/minimum-gas-prices = "0.025uhuahua"/g' $WORKINGDIRECTORY/.chihuahuad/config/app.toml 
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.chihuahuad/config/config.toml
        sudo rm $WORKINGDIRECTORY/.chihuahuad/config/genesis.json             
            wget https://snapshots.polkachu.com/genesis/chihuahua/genesis.json -P $WORKINGDIRECTORY/.chihuahuad/config/ 
            cat << EOF > /etc/systemd/system/chihuahuad.service 
[Unit] 
Description=Chihuahua Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/chihuahuad start --home $WORKINGDIRECTORY/.chihuahuad/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        systemctl daemon-reload 
        systemctl enable chihuahuad
        systemctl start chihuahuad
	    tput setaf 3; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u chihuahuad -f --no-hostname -o cat`'; tput sgr0;;

#COMDEX = DONE
    3)  tput setaf 1; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 1; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 1; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 1; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 1; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 1; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_comdex=$(curl -s https://comdex.api.chandrastation.com/node_info)
            export COMDEX_VERSION=$(echo $response_comdex | jq -r '.application_version.version')
            git clone https://github.com/comdex-official/comdex 
            cd comdex 
            git checkout $COMDEX_VERSION
            make install 
        cp ~/go/bin/comdex /usr/bin/comdex 
        comdex init $NAME --home $WORKINGDIRECTORY/.comdex/
        SNAP_RPC_1="https://comdex-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://comdexsentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds ="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:13156"/g' $WORKINGDIRECTORY/.comdex/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "7a0cb2144a384d4359e67733e08c10fa916ee77a@65.108.122.246:26706,8fd49b7a948fe6752c3f62b4e453e27a203b0b61@188.214.134.115:26656,89763aa7dc65b79bb5075d410c2eb3194aef1fbe@107.135.15.67:26686,a6da9c608d54ce51c0cc7d311741bc1c3657df73@157.245.57.113:26656,2bafe904ac0bf8e7a835bb78c81c04dadf1d18cb@3.110.36.74:26656,0cebbf0c1a00173134a341865d3f2f952abe9cde@23.88.11.28:12060,3b6a09c1960b6d2a5aa065e95b66e261e081b130@95.216.21.37:28656,d5ca0cdf23da8e99d1104ec08fb7d14455b44715@31.187.74.76:26656,debc3cd82d2c2b43544bfb8bab21de94650c0b69@15.235.9.222:26656,11a0dae6a28e9a3db7c5e55f8d0e7bc6f9de769d@135.181.138.95:2040,b43441ca4475a8396ba39be2d1360dfdcd1e167e@116.202.174.253:26656,d6c9b6539fd34a6126fbea118027d4d854f606e8@116.203.47.167:26656,e146d14968e5b26b86b98aa52dbb48501ba1468c@95.217.170.202:27001,e726816f42831689eab9378d5d577f1d06d25716@176.9.188.21:26656,8a210f1bcfc9015a7bc18dcc5add29c0dce3f2dc@135.181.173.57:26656,abf7faa9922bfaa288f091e10c61c3e61c1f2e54@135.181.215.62:3040,382474b127efc4d5deb252e3329f36907d24042b@193.70.45.106:13156,61a177d8a62d8e9d8e406fc04aa1ca22166c7b02@162.55.92.114:2160,345fdb527948bc0c39f9833a353fbb78098f7dc6@198.244.213.94:23556,be5dd72685203006bd0af81d2ef506530a7ea92a@185.119.118.117:2000,148d8b7752f4df4403945330427e551994c2143a@80.90.238.121:26676,55b750e80ddf3d8d35b88a72923527fae61604fc@198.244.165.175:14656,b4a3580c569dd215f7c9634e6f1d33c59521bcc7@207.244.245.6:46656,882b30a1c4f80351b56ea1ed354be5735aebbba9@65.109.37.154:2000,944af4307943629014af52160fd1407699959fb6@148.251.13.186:13156,641c012766b33b94ac6461921602a79db4939795@142.132.209.97:26656,453e3bf267ae68518b1a0186830bbed0033de28a@15.235.114.194:10556,4e4929786927c9d9ba4cf29ce7fab14dda4ebdd8@65.109.89.19:13156,471518432477e31ea348af246c0b54095d41352c@88.198.129.73:26656,8025d29475d51304315b420b088739c2b42ce9fe@144.76.63.67:26119,fea9534383283e0c6d91e4d73f7adac29f992160@51.255.66.46:3040,922c1ed272134ed3db251066917cc3f07aae012f@135.148.169.198:13156,261e571925261dcb6f6505733fc86fb9f6dd3fc1@142.132.158.93:13156,c71be7ba7eddac04723bc5bfbd0c6d9ae1ddc115@54.246.159.234:26656,82588f011491c6100d922d133f52fc23460b9231@135.181.172.177:26656,e091e09473674dfdf46e67333bb664aa2b2b7e14@44.197.232.128:26656,bba10290da32f3cb41e15c3a192413666ce05cee@136.243.115.113:26656,d2247f7b919f0781c90ee61958d7044665a22d38@169.155.45.180:26656,57bb50ee8b0e6dc4d04ba566596572be6f664637@178.211.139.224:26786,4e1c2471efb89239fb04a4b75f9f87177fd91d00@135.181.172.233:26656,8e4e1f1e087c76c71c64e477e95495833da82aa2@135.181.172.185:26656,c124ce0b508e8b9ed1c5b6957f362225659b5343@136.243.208.25:26656,79d327b3216984f80bcaa2bcaeccf2729ebd1b00@142.132.248.138:26179,6cceba286b498d4a1931f85e35ea0fa433373057@78.47.208.17:26656,b16863037367e706ab0fb8fc1bdbc3330b59a6ab@65.21.136.170:26656,fbf876fe45566f27f3c6f940da19d22ef8bd1fb4@67.10.178.120:26656,b99b6831355ad05ce04996092f2ebf66da7e99db@178.18.255.244:36656,97e4468ac589eac505a800411c635b14511a61bb@5.9.196.233:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,5e091c274da21b4a4b309bb76e854d58f1c800df@116.202.36.240:10556"/g' $WORKINGDIRECTORY/.comdex/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' $WORKINGDIRECTORY/.comdex/config/app.toml
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.comdex/config/config.toml
        sudo rm $WORKINGDIRECTORY/.comdex/config/genesis.json
            wget https://snapshots.polkachu.com/genesis/comdex/genesis.json -P $WORKINGDIRECTORY/.comdex/config/ 
            cat << EOF > /etc/systemd/system/comdex.service 
[Unit] 
Description=Comdex Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/comdex start --home $WORKINGDIRECTORY/.comdex/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable comdex
        sudo systemctl start comdex
        tput setaf 1; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u comdex -f --no-hostname -o cat`'; tput sgr0;;


#EVMOS = DONE
    4)  tput setaf 1; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 1; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 1; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 1; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 1; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 1; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_evmos=$(curl -s https://evmos.api.chandrastation.com/node_info)
            export EVMOS_VERSION=$(echo $response_evmos | jq -r '.application_version.version')
            git clone https://github.com/evmos/evmos 
            cd evmos/
            git checkout $EVMOS_VERSION
            make install
        cp ~/go/bin/evmosd /usr/bin/evmosd
        evmosd init $NAME --home $WORKINGDIRECTORY/.evmosd/
        SNAP_RPC_1="https://evmos-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://comdexsentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds ="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:13456"/g' $WORKINGDIRECTORY/.evmosd/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "cbe46b04c4a0a4e1a8d68d77ec0b894ca2b8458b@93.92.132.73:26656,104e98c20c131668564d10ad64dc52bb230f18f6@65.21.127.197:27856,109092451cee1ca052912c09406e6ea6d7d42e43@15.235.13.144:26656,6032873edbaf1bc3c7ef7610d5fc4addc0b48971@169.155.44.90:26656,b8a49a985afe3b66a72ff7e2462d8c08d4c6fb95@164.152.160.179:26656,05f336c16299ec9f480f29c09988db3897e876e5@162.55.103.20:26656,b86bc9529ee94fa6d6c18f3ab8d5fb86efa58416@162.19.169.164:26656,be4ab9b1689e3a0012ce04d67103a7458a34f7b5@145.239.9.99:26618,da49bd3c159fdabc7ffaaedc6bc54a56183e9ce9@66.94.126.62:26656,b18132c3ecf1c7057d418a72c82807080d8a7053@65.21.93.108:10756,181ffa1d33cef4e26b672defafb1cda1b43de6d4@195.3.221.10:26736,85c3ea9adade9a24d38eed9cbf9825007d7fa1de@65.109.48.230:30004,04756c753a8aee0f7c316ed1b94107878c8a8df3@51.79.228.51:26656,f4bf57c116cb7324407d6ed1a9db485380de361d@151.106.40.38:26656,6e91c9f077eafc1014e06be6c7e4394bf4b1c960@38.242.255.29:26656,a7d96dc929824613315dcc1c90fee119f28cc51f@164.152.160.103:26656,ed6518c8cbd9636f1f793dd634f79825104d9651@65.108.137.22:26656,e867b7265917adeafc3379f77e440a483fa98ffb@65.108.200.142:26656,4d1f489e851511de403734f0d0c0cee1204f2d42@162.19.136.45:26656,e48731a1434907e26c67cf9e131fbdd449436855@15.235.165.62:26656,0c00c374966dafb5b14b7cd1fea25d3c05eb4435@65.108.103.40:26656,0a26405b529f0e563b641df0c757d2f87d6e07fd@144.76.63.67:26199,8a733fd26f3ff1974cc2eb72a57f6c344da8d026@15.204.196.180:26656,5d4a67dac324ca252d22fc92fb4776e1195e34f6@141.95.105.60:26656,f84869ac720b1ca0cfcee771629a0da113b3a5a4@54.38.46.12:26656,c9136e3cf46f46fc400fb7ae7717421e2d16fb6a@51.89.155.2:21656,04daeba73dc9c5cd3f0580869f51debe89815220@57.128.81.235:26656,ff1778dd3efe597033671780db55ed0508971921@5.9.138.213:26656,384cd06ac005a2162e8a41e28eeaa5ef00467c1b@15.204.197.68:26656,4e95bf034a3abaecfe4cf0310e710435de439f12@18.178.48.176:26656,df810a487725520c7a3153ff733cd70fa6c81323@66.234.207.67:26666,bd1425ea168f51e10b836b6fa8502078d08d4ada@135.181.5.219:13455,3db31759ebc801911f62f676d0f34f6539c8a5db@162.55.88.232:26656,dd5f59df7abc03c068c362c3c7f27c581938221b@162.55.92.114:12070,d81424ae8fc4973359b2bade68ccd402a5491550@162.19.171.42:11956,4de2d5f7a806acd3407ebf58ec95ce8384e629a0@65.108.142.81:26673,f9b100779650e64f7a66dd16c76b3e86477ccb5b@34.106.233.103:26656,e297dce87ff7ca4d4c7fbc1cf7c81b0033f8dccc@88.198.34.206:26656,6fe993d412221e187e86f4b35a31c936e156cf15@162.19.232.153:13456,105a87f6bb8aca8e8475ad8fb5e044acc4096cd4@95.216.16.205:13456,f22d85993985f7cb8c4e3b1086708eefef54bf06@157.90.179.182:26256,7f06ec15a94c2b0f99b4f74331e2fcae51c20a1c@69.46.15.82:26656,d3abb4dbf82f5f0d1d30f0706c077b2a90379601@178.63.86.221:26656,1f78076e068b4726314a834851e05c1d46e7204a@198.244.165.175:10656,d739b69ec44d12c06fb5b8c526348cc7136b2798@81.0.220.94:22456,2be90ecc844a071ff56b1a94dc48ff0cc386bf08@135.181.20.164:26656,50ce5537afa78216741c1a283b253a895f2869dd@149.202.72.176:26618,55e8b7d62153a92dfdd2d187d3f3ef80ad67d9a3@173.234.17.203:26656,ab4ee41c7a2d9d7f0e3f7c85071460b513292b75@15.204.197.51:26656,96557e26aabf3b23e8ff5282d03196892a7776fc@204.16.242.187:26656,8a5288b84f8a3b70215609da5e3b2da28c3886da@157.90.213.21:2000,7cb741da246b987be99ddd44bfcf390d4279f59b@65.108.192.173:26656,43730f5c0d348d566f0aef15ed32660123f98b14@35.245.211.8:26656,e1e2a2a46af11cb3bcd72194a968cd4c3c83f361@65.109.64.49:26656,293063c5a6114256ad520b9b45c53acdbe34cd68@66.172.36.136:21656,b0f021a272f296e3d9ef9aa8f4a2d76d3792a8bd@51.161.86.56:26656,617c72274d28bf0c4ef56a399261227e389ab09f@161.97.130.97:17369,c8d0c8c1f7c1906f29e57c5295b6de16ee74856c@95.217.37.135:26656,779fb316568513b3d136b8aca2f8070855eb227e@65.109.18.166:32656,85e014ff39dd6a5ddd66dde3033fe370b5c7427a@203.135.141.17:26656,a1e0ae7538cc6d040824499dd1b3080fb2b80488@195.14.6.45:26656,3f4d8369c915aef20a62bbece26ec9b858244138@108.209.99.68:26634,bf47b6377af442936fb698c6c1c9fcd82dccca42@65.108.234.22:26656,8d8124fa3ee8a12b94bcf4536dda7b94b197b449@134.65.193.235:26656,3e2ad33ab8f19e699568aa483e0111101d845638@142.132.214.190:26656,944f85c7fd7540124c6cff0496e0805010b141db@5.9.102.204:36656,41a695fdd1c0bc6923d136d1eb5a71673dc168b3@173.234.17.196:27656,fd569890721157a9ac4312c68bda4594dc74d109@65.108.106.241:26656,40f4fac63da8b1ce8f850b0fa0f79b2699d2ce72@144.76.76.109:26656,6047f6c52c556bf9f0c48630eee5ab793615f1b5@67.209.54.83:26661,dcefe58ac9c7d880230d08815ea3d6cd0215c3e2@195.201.198.231:27856,76def3aefea10e9422d8672a042363fe70b5a87b@185.119.118.114:2000,fc1d8ad92dd1a6522cee9a185d843ffbefd38e55@3.249.180.171:26656,d19cba5e3b35abd8c9eeec4b56fce803d0d1945c@35.230.149.229:26656,5d0e9415713d97da8d37f0d068cdf3040bd9846d@67.209.54.38:26656,717c7a08cda6b3962921f5230c093a6fec61ddbb@147.135.65.173:26656,594dec14d75bdd98a86ad838db4cb97bb3fd7cbf@35.237.82.161:26656,7b252239d9dde91961c4f39b5ed99252f153c088@35.215.41.6:26656,0ea549e4fc360b5252e15bfe34c98ea3154d244f@65.108.0.165:13456,3742ff16bf95c49fcec4eb9cbbef01d98b5759c2@136.243.40.41:26656,323cc67324666e3bcc85582bfd348499e9978f32@65.108.51.155:26656,7062c01d579f1a8bfa97bf977561beba96882408@65.108.64.98:27856,bfa7a6b41bf1755c5eeeb3efc9910e0d8a4ade12@142.132.135.125:26656,7112cea114102a9c56b6940c0cdd8404127f3adc@167.235.102.90:26656,d76cae129069fb8cf7ea15735ee102b88855ffe7@192.99.63.196:26656,b9988bbf6aa53177104c41f92b65da7e3e4a362f@185.242.112.130:36656,5f0299aff280e15b5570521f5aadb0fbd67550a8@142.132.132.182:26656,59672298c98e934db908e4214e85bee81ed7deac@3.17.153.24:26656,06ba2a7b8f1f791cfeb580e0d0eb6f42d45f3fc8@145.239.2.52:26656,fcff1c82ebdc234580d97e59babe9cd61afb068d@13.212.218.97:26656,67dca2fe3700b1c2298aab50f6028399c65d6944@169.155.44.29:26656,850a5c8af7e21d196fb6e12b063292ca053a8594@65.21.72.115:26656,db2fb8af6aa80e472ca174c308994481ade46cb1@65.109.59.174:26656,d3d7a0c107994c7388a075b5bef1cfe0dc672cb3@65.21.90.137:10956,126255d17456bea8c3c1677c2cada6a9dd4cc0bf@107.135.15.66:26666,5b03fb91d5373312d845575671c7bd2d86593f5f@65.109.35.90:27656,f5c86603e49dd43a01f374b8a24d0d7a97a54086@147.135.65.22:27656,e726816f42831689eab9378d5d577f1d06d25716@176.9.188.21:26656,4ba8c28640d974c079fac73d363a2495b26bdbf8@3.250.201.243:26656,716df7122c34f08b98dc12d17f993f716ec2601d@64.227.146.43:26656,9449385f25605774d89d7f596153fc1204681e5c@38.146.3.146:13456,56950bc418155ea6ff074f96215d16cf0c20d0d5@3.136.32.149:26656,b119efc22e5404ca896538f02e9481414552bc53@141.95.124.164:26656,b981fabd1d1f66a2a56b6c28013113b0fbbc0dc1@159.69.168.229:26656,1a5376a32b6b1487eabf7aa8edbad1859be09885@195.14.6.43:26656,23f59e376945ffd874224fe868226d9fbf58b4c3@148.251.43.226:26656,4fef8cc96bdf7a6ff6d63fba7ddf0b9079d7a52a@51.222.47.119:26656,d0807e5d8cb70bea5baf0c88e988a5d3ab95944a@15.235.86.146:26656,5eaaa1d6a7ff68c40c0b74ad466eae524043aff2@65.108.69.121:27856,d185fda612bd39a63e75cd288d8c983485576703@65.109.30.116:2000,e1b058e5cfa2b836ddaa496b10911da62dcf182e@138.201.8.248:26656,926ac640e2b7d0148937dff825ab220de2899aba@169.155.44.122:26656,1bd58858567fb887d23c52359f8b15db74ed8295@15.235.86.205:26656,0d62f64fd433ab92b4f6aebcf1feda983af1aa9b@95.214.55.63:26656,8a210f1bcfc9015a7bc18dcc5add29c0dce3f2dc@95.217.70.60:26656,cdfc7333caf793014cc4b1322c0b3e76cc6ac2b8@47.75.104.62:26656,69e6ff165ed2ab729c7c1b11ea0b9dc9b1dfb0a5@135.125.5.34:32656,6e450b00e9d8d13a89492300484246f92975cced@65.21.198.250:27856,e2c5b673fd4b2aab3e9240550826baa947a32bf0@18.203.81.208:26656,40c57d2576168d0de2174a7c6d0f8bba77f0547a@65.108.237.230:26656,03ffc6e7acd43d418258c3a66373e443c14ec1b2@162.19.136.124:26656,eba108332e888a15d770f52bacefc71cf4b87da1@34.88.224.168:26656,8b92e58ba462c38e8840cc9f5b51ac94f7c7ba59@65.108.45.115:26656,38d6b22a4188da94514cf8ee018cc922172301c7@135.181.56.25:27856,de2c5e946e21360d4ffa3885579fa038a7d9776e@46.101.148.190:26656,905f4f03d5e171217ac43dd723e38d65edf36bec@95.217.117.99:26656,a7d463a6bd62130d5603d3f19d79c267f8a1da49@194.163.156.209:26656,1fd9c1043afef7f5d209c5e336a78b673eac0c6b@35.245.184.103:26656,fc86e7e75c5d2e4699535e1b1bec98ae55b16826@35.212.170.133:26656,3d3f642f961c6ec867685fe1ecb04b0f1e616049@142.93.215.56:26656,5817ae31491d1d09399653a4a786ae5c5af5eaee@65.108.194.108:26656,10c1369cf5788d0f8d720fc6a2e70314178afab2@54.202.73.49:26656,0247eb1196556c00bd9f24a246c8df4ce44c00b0@213.227.164.85:26656,53d6ba5d60acf269b1de691af2b946bc1e10c7ce@142.132.195.212:26456,04536da0ac4b28f323c869822588b0ec7612b5ad@65.108.99.37:26706,6c629819fa12da96172e5501337a2b9b8ca47949@15.235.51.191:11956,f201e6bd9f86d248a4b83cbe672010eafffdac1c@66.172.36.133:21656,1a7bee67d6337d09380b824b952872bdc5dca86f@38.242.194.56:26656,b3568f43ad3fa77cd686927dbb5312e2c74c6b52@65.108.231.164:26656,ad9f08613da5dfff730b16caad33a11e1833faa0@57.128.144.225:26656"/g' $WORKINGDIRECTORY/.evmosd/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "4500000000aevmos"/g' $WORKINGDIRECTORY/.evmosd/config/app.toml 
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.evmosd/config/config.toml
        sudo rm $WORKINGDIRECTORY/.evmosd/config/genesis.json
            wget https://snapshots.polkachu.com/genesis/evmos/genesis.json -P $WORKINGDIRECTORY/.evmosd/config/
            cat << EOF > /etc/systemd/system/evmosd.service 
[Unit] 
Description=Evmos Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/evmosd start --home $WORKINGDIRECTORY/.evmosd/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable evmosd
        sudo systemctl start evmosd
	    tput setaf 1; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u evmosd -f --no-hostname -o cat`'; tput sgr0;;

#GRAVITY = DONE   
    5)  tput setaf 6; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 6; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 6; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 6; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 6; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 6; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_gravity=$(curl -s https://gravity.api.chandrastation.com/node_info)
            export GRAVITY_VERSION=$(echo $response_gravity | jq -r '.application_version.version')
            git clone https://github.com/Gravity-Bridge/Gravity-Bridge 
            cd Gravity-Bridge/ 
            git checkout $GRAVITY_VERSION
            make install
        cp ~/go/bin/gravity /usr/bin/gravity
        gravity init $NAME --home $WORKINGDIRECTORY/.gravity/
        SNAP_RPC_1="https://gravity-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://comdexsentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds ="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:14256"/g' $WORKINGDIRECTORY/.gravity/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "8357279ecb5f1b80eda324762a1406868c89bb5a@172.105.103.88:26656,f8e90b224c2f3a914f18313adb8718a9a366f6fe@65.108.140.109:26656,95f47663d4b49c9610325ecb4c9e1ffc511ccb26@50.214.44.52:26656,fa966980502c49f84df4cc4c0438302042d14947@51.83.66.215:27656,162d548d72d99f28478f85abb8926b52b8c9d362@65.109.88.107:36656,15636635d36e9a250824c5725f728c5f9148ad24@13.125.104.77:26656,811817c6ddc112ed37f7cd71c6bbae186f1e8239@135.125.188.17:34095,4d94ca2877c879e016620681fde7c22bc23bbc6d@185.119.118.113:3000,ba0c3ee25e8b407c6d90647c395f1880a358b341@174.45.46.27:26636,b2608e51a520866a91637ca3b354903bc5b46bfa@137.184.214.71:26656,c189b7217b037e50b3456440963f91d027a4df5a@65.108.199.222:26656,1c2661b9aa125a31f8618f224faf553e85f230a6@65.131.72.245:53509,ca9d9d0605f178fbba3bdf92e13719ab9dce0fc7@23.88.59.82:26656,005263c9b18f6cbe5dd7805240535b1bcae195cb@51.195.145.104:26656,8bc91ffabd860b6b54766ac3788d7c284e45b964@174.138.30.240:26656,84fb0a9180b2b67b4901330a13f1dee4226ce3ac@65.108.9.169:26656,3494f4ed6546bce27c6e5ecd8448dc86f59eb075@193.34.212.34:11114,5be48b960e6fc61c0879e86854b9f05d3ddc3522@46.4.91.49:27656,94a09a149acbaf7435d8d4082fd6100598e1fee0@157.90.5.119:26656,567e0c6765987b56717d76a32f2f06e65a4a0ca9@167.235.34.35:15656,d20fb90c25dcd447fc574d20c3511a05b19aa9a5@35.215.12.41:26656,7ec5a1fe29feebb8ff632ebe2a4e3f70586e2adc@65.108.232.134:33656,4bebde6a1b2907bd3cc167d2802b909770cbfda1@137.184.197.230:26656,6770e29a9224810bcde6655b742d52b8a49d51e8@65.19.136.133:26656,5ad3fe86b1214e1f5c897d23a2863fb46bdfc1f7@185.16.38.165:14256,35aa2649d5986e9ae3aac47b5b629004c8be1748@95.217.225.212:26656,82bf13b3c0af8cd0ea69c64ff43e61a5b7dbae7f@176.126.87.56:26656,4e1ea298ef66eec3ec320171f90336a1e4bb13ea@51.81.107.95:10256,da401c011881747aa47b7348349edfc855794ba2@74.208.108.68:26656,9e5b6f2223d41cb3a68997a369bd7848746a181e@31.7.196.20:26656,55fe573c1531d47d4e8c5f1a6560fbe25919692e@80.90.238.121:26668,16f40620f1b1942246015f35c40dd9fc84e51b01@66.94.124.27:26656,07e2da0edb0facd81dab948a128330cc1250b24c@193.70.47.90:14256,e940c7788dfbf02030d0838fb3dc9cdb21cf5832@66.94.112.81:26656,46374f308b7cbf6a8d8242bad8666760b433cb9d@62.171.164.145:26656,2ed29367fb30768c53c9b647e1116de3c640560f@51.79.72.176:26656,7e5b7671f0ec3729124102f23c50d8cdd0faa583@192.26.37.56:36656,328f1a98dd30612a51f265c931187b4c9ced6270@167.86.99.6:26656,1f11577400a5caadedc01261e0f4902983445fb1@212.23.222.126:26656"/g' $WORKINGDIRECTORY/.gravity/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' $WORKINGDIRECTORY/.gravity/config/app.toml 
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.gravity/config/config.toml
        sudo rm $WORKINGDIRECTORY/.gravity/config/genesis.json
            wget https://snapshots.polkachu.com/genesis/gravity/genesis.json -P $WORKINGDIRECTORY/.gravity/config/
            cat << EOF > /etc/systemd/system/gravity.service 
[Unit] 
Description=Gravity Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/gravity start --home $WORKINGDIRECTORY/.gravity/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable gravity
        sudo systemctl start gravity
	    tput setaf 6; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u gravity -f --no-hostname -o cat`'; tput sgr0;;

#KAVA = DONE
    6)  tput setaf 1; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 1; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 1; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 1; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 1; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 1; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_kava=$(curl -s https://kava.api.chandrastation.com/node_info)
            export KAVA_VERSION=$(echo $response_kava | jq -r '.application_version.version')
            git clone https://github.com/Kava-Labs/kava 
            cd kava/
            git checkout $KAVA_VERSION
            make install
        cp ~/go/bin/kava /usr/bin/kava
        kava init $NAME --home $WORKINGDIRECTORY/.kava/
        SNAP_RPC_1="https://kava-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://comdexsentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds ="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:13956"/g' $WORKINGDIRECTORY/.kava/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "f7c894901f450b92614fd051d10854d168ec30b5@65.21.94.20:10856,9552d87eeaffd8dd74eca6422388e188c65dc334@3.208.93.115:26656,09891e9e931f434775cb8143771e88024c0166e1@142.132.150.14:26656,9fce103bd84405050952c5b04d535c73c8209a87@91.209.128.131:26656,508d7ec33c7f3c9c479ca9b845cadbbefee670f7@162.55.133.237:21656,6b3a708006089d2e1ce31ab70134686698d7b3bf@142.132.251.243:26686,9c81a7d07286a13c0ebc5ad4080f8cc080ce9a52@54.39.16.240:26656,e2a1c5742256f8ea3d208b45bdfc5a84d2d7c543@54.87.59.252:26656,156665a30a6cd2cbc2b4008b6b38e47a52c71914@34.207.223.4:26656,b949266433451a18690fe744e11824f31cec750f@3.235.59.4:26656,cf4d61d97ff06611f2342d53a42eb28ad4116eda@193.70.33.64:13956,41f46c7318e895f90d69818ba095808dfc3ea16e@52.73.3.94:26656,db8bc38d8823642d3c614c108eafb77d0ee07816@54.234.204.137:26656,9c2dd1c4f4ceee551f3f593099aef53756efa32d@86.111.48.94:26656,d5db8898d40054c07442f3364b32f7fac2752f5e@188.34.178.92:26656,a2b335e9488045b9504f8a0a83219627a1fd0569@54.221.75.234:26656,ac5d7f50175837eab6b6fbd38cedf418186b78a7@54.163.63.205:26656,6628c7fc27ac3a17da1751ca6ea0fb0b11fb5657@86.111.48.93:26656,a6fd30d8ddc5ba84842e36c0365c8ab74ba5f5f9@52.221.180.172:26656,2a15d9c39eea97b4cf00480b45d4ea32a2e173d0@94.130.78.22:26656,3397567b616bd3fd9d8cd726df80f0488f91a891@65.108.129.165:26656,6885971cdb724fa93034fb9e6a11113a6f555d2a@15.235.53.92:11656,50e4cad7d5e28f7b6495168f92e12bf810e293fd@142.132.152.187:10856,16da063b578de147851e9b69407f75802358b360@142.132.131.184:26666,2d71832c0787f5ed8e3714b36d98f272899df2b8@89.149.218.109:26656,41d88639239c55fd37279d24df507238e1c417ea@85.237.193.94:26656,b9b5e4176fdc82eb9db2f41bfc878b37a5da974d@18.193.88.91:26656,bb7815a2c276c886729d11361d8457070891636a@93.115.25.106:27656,7cdf32d3380d0d174954b4ac82a0fb92d2970d7e@184.72.123.195:26656,4f4b567edcc417ff5ff21d26fb56237e60da81b3@132.145.126.161:26656,568c1243d8e9695926accb79832c2f83f55d5d1b@95.214.55.156:26656,88019453922e5bfd21853473c41994d344348363@3.249.168.11:26656,747769c7b3b5b895c46160a43b5e3684ecfad022@3.210.246.14:26656,a8ad45ebd2f536cae8a41bf1d50f96ca9726b406@192.145.45.163:36656,816acf44bb9535e04f8e112013e69452508bc99f@149.202.72.186:26634,234434eb9bc505371ef6972b5ee27551850d472f@52.207.252.52:26656,e726816f42831689eab9378d5d577f1d06d25716@176.9.188.21:26656,abf487c8cd669aa4000f7f706a773e5dabaff805@54.254.155.110:26656,4cfdd459466cfd492d66b7a5fe26cde96e35d735@182.48.203.7:26656,4258a7408a07994bcaeb3f5b390700a35590c755@184.168.64.52:13956,52c122eaf259c1acad5615756cee97cb7b6cb6e9@3.95.228.13:26656,691c6761b4255aa9fffe32bd08a1ad76c94c4da6@52.201.254.32:26656,aa3f21826c9f76b8e8428c431857de517ab788dc@54.162.68.81:26656,a1c12333fa38462f663749a6ff037b4d24365725@54.87.129.115:26656,c456bd8856c4537dc65dc9e9d5c9873b63f23b6d@65.21.136.170:34656,c18ca85ff8926970c5bd64f4fd8e3ee6d5ff87b6@50.16.212.18:26656,35e7aac2b496de5c3990bf481c45bb7242d78015@3.80.85.125:26656,2f0ae734874dabb6c69adf4a9aa2d1d590c028c8@3.133.125.157:26656"/g' $WORKINGDIRECTORY/.kava/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' $WORKINGDIRECTORY/.kava/config/app.toml 
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.kava/config/config.toml
        sudo rm $WORKINGDIRECTORY/.kava/config/genesis.json
            wget https://snapshots.polkachu.com/genesis/kava/genesis.json -P $WORKINGDIRECTORY/.kava/config/
            cat << EOF > /etc/systemd/system/kava.service 
[Unit] 
Description=Kava Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/kava start --home $WORKINGDIRECTORY/.kava/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable kava
        sudo systemctl start kava
	    tput setaf 1; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u kava -f --no-hostname -o cat`'; tput sgr0;;

#OSMOSIS
    7)  tput setaf 4; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 4; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 4; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 4; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 4; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 4; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_osmosis=$(curl -s https://osmosis.api.chandrastation.com/node_info)
            export OSMOSIS_VERSION=$(echo $response_osmosis | jq -r '.application_version.version')
            git clone https://github.com/osmosis-labs/osmosis 
            cd osmosis 
            git checkout $OSMOSIS_VERSION
            make install
        cp ~/go/bin/osmosisd /usr/bin/osmosisd
        osmosisd init $NAME --home $WORKINGDIRECTORY/.osmosisd/
        SNAP_RPC_1="https://osmosis-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://comdexsentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds ="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:12556"/g' $WORKINGDIRECTORY/.osmosisd/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "59acbd72c5c6bca93c279307cd25b98446eed550@65.109.21.75:26656,66d9a8091d39c066841ed99ee9a0cd3472b5ef0d@15.235.53.79:26656,407267ac44b20a0a4258d0bbca1c9f657bf88d08@74.118.143.19:26656,e1b058e5cfa2b836ddaa496b10911da62dcf182e@138.201.8.248:26656,008785cb68789895c65b6ab42e83773814dd008e@65.109.19.177:26656,32e9d4a7413dd5393c8be004bee68dea683be839@65.21.227.95:2004,bfb67b2ae345955d6bc0991450120669c683386e@149.56.25.66:26656,5de15f4453e014003d0364621112a284f8485f1a@65.109.21.76:26656,e81c3c20833cfb5d652a9c842c9f1c8b1835479d@108.61.190.21:26656,66c7f8253838f18c6dc0b5216b62a49a4103bdef@45.141.122.178:29656,7a07dafb349ca10e52e9336a63674748d7ed22c8@65.108.99.37:26656,797094953d830f8727f3b5175f2b205df16d5867@45.77.212.231:26656,be930386104083882c7e491d60584e15c101c1da@178.128.156.131:26656,42745690b41f6a7515c4a87d88efda2e82b55b76@78.46.94.183:26656,1f650c50f6c556d375ce47740ba1b58c608daab3@95.217.115.220:26656,a6283307952423c1751431c220d11ed36b61ed84@143.110.237.113:26656,f4b811759e55f665180545ad5e1b42573f660861@135.181.181.251:26656,30e9432879d5b0976b88e52120dc12338e40fc33@65.108.108.176:26656,724cef11bbe866269b3d67f7dd5ea539cc4096bf@198.244.164.186:26656,e0fbdbdce6ec8797412751edd00fbaf114c42fad@34.220.226.204:26656,7c5459ea4bbc41aa4d86ffe8126f0651155227c8@85.195.102.127:26656,19f75a1aea4cdf8ce987b3d4e1ef6617eb3604b3@95.214.53.217:26716,47e4075978458bfc382630b2a46aabbbbf7977b2@143.198.234.114:26656,34340a9151d4a97a850d2cd64d8778279faf3f96@194.163.181.100:26656,43785e5ffd8783393ea8094f77efcee5bdbcdce3@78.141.244.18:26656,913e9db0332df1152e5afe032ab81bdb65e3f91c@110.11.23.44:26656,d0c050f33b7aa1032a3763da0e7eb8df0ac72a2c@162.55.92.114:12000,e726816f42831689eab9378d5d577f1d06d25716@176.9.188.21:26656,20913e92e8b9ea2d80ad34edd9b52e97886cf616@54.37.30.181:26656,1876eb08c7e93c965a895177f82c8725f89c0f65@54.214.183.228:26656,d2a4b47f8d2f4130943ef7a38c1c1c80ea4d06fd@199.247.29.239:26656,ebc272824924ea1a27ea3183dd0b9ba713494f83@185.16.39.137:26716,fd0930fea06876e362e0a92046854ed651f27ac2@45.76.13.41:26656,4cccbb26639559c39f44758d246c5ed928f7717f@176.9.19.66:26656,1a26dfdddd57a499841e45936f45c1d59c643b98@137.184.37.245:26656,baa7572065e18f1796f50b336a01dcaa85eccd01@65.108.101.214:26656,0431022ccc3d354d92518df2d0ab30149a3d5fd7@202.182.116.179:26656,63e4dd6530bf4dc4c2202be256b262a27d661106@146.19.24.108:26656,71eab9bbf4edabb7b0f2d58e409edc7eb2a98a78@54.241.23.96:26656,9a3695d465ac5c4b08640b8d448e25540d74e427@24.199.110.108:31316,60a2c89e7253502e93517a026f44a2431cc81230@220.85.113.39:26656,6f1ea747a402fb9be183960472935c56333e1095@65.108.141.109:26656,071ae914b06e14148a6286a0fa087c797336f043@34.105.246.121:26656,e30f205bfe7042fce50b51909b22fb305e748e8f@148.251.13.186:12556,0813f61788331d5fdf66246b50cd417652194c27@23.106.120.19:26656,6178f129efa76d235436e2156959d0acb4772c6a@65.108.128.168:36656,fced2c95050c0d4781b76cd2b0a93efae03cb395@65.108.77.93:26656,2000928f1b09973431b53292ef80c1cd836fd967@168.119.213.117:26656,0419c998d6aac0afdb05808ad9a935670248e209@65.108.204.56:26656,69e0d192ebbf4599bcb0679901c020cde07e7806@176.9.28.41:26656,ab4ea418db1c65c2517975988e2f35891637ff4a@185.111.159.235:2000,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@135.181.5.219:12556"/g' $WORKINGDIRECTORY/.osmosisd/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' $WORKINGDIRECTORY/.osmosisd/config/app.toml 
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.osmosisd/config/config.toml
        sudo rm $WORKINGDIRECTORY/.osmosisd/config/genesis.json
            wget https://snapshots.polkachu.com/genesis/osmosis/genesis.json -P $WORKINGDIRECTORY/.osmosisd/config/
            cat << EOF > /etc/systemd/system/osmosisd.service 
[Unit] 
Description=Osmosis Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/osmosisd start --home $WORKINGDIRECTORY/.osmosisd/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable osmosisd
        sudo systemctl start osmosisd
	    tput setaf 4; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u osmosisd -f --no-hostname -o cat`'; tput sgr0;;

#PASSAGE           
    8) tput setaf 7; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 7; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 7; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 7; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 7; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 7; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_passage=$(curl -s https://passage.api.chandrastation.com/node_info)
            export PASSAGE_VERSION=$(echo $response_passage | jq -r '.application_version.version')
            git clone https://github.com/envadiv/Passage3D 
            cd Passage3D/
            git checkout $PASSAGE_VERSION
            make install
        cp ~/go/bin/passage /usr/bin/passage
        passage init $NAME --home $WORKINGDIRECTORY/.passage/
        SNAP_RPC_1="https://passage-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://comdexsentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds ="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:15656"/g' $WORKINGDIRECTORY/.passage/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "0111da7144fd2e8ce0dfe17906ef6fd760325aca@142.132.213.231:26656,2efb97acb21585a656c23ca42e6cb0f50c502b94@65.109.92.83:46656,8e4e1f1e087c76c71c64e477e95495833da82aa2@135.181.172.187:26656,8e0b0d4f80d0d2853f853fbd6a76390113f07d72@65.108.127.249:26656,56e129d2bc23bc58639173542f9c449818c24c45@65.109.31.114:2450,6244c9d76cb26a4ff93b997379af4f2ed91a42ce@185.248.24.19:26916,bebd3baa62b1c8734e5d699a523a925ec85919e2@65.108.75.107:17656,6aa09bd3aa20acbb46e9d000f52e305046201086@139.144.77.106:26656,b7816ca00b704e3331b40afe5939350ab1418b2a@162.55.1.2:36156,c560ad9503c327fea71e16d149eb320512dce833@65.108.141.109:17656,ebc272824924ea1a27ea3183dd0b9ba713494f83@185.16.39.172:26916,17f0d23cdef1264bed87ec3872077f825578120b@51.81.107.95:10656,c124ce0b508e8b9ed1c5b6957f362225659b5343@136.243.208.27:26656"/g' $WORKINGDIRECTORY/.passage/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' $WORKINGDIRECTORY/.passage/config/app.toml 
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.passage/config/config.toml
        sudo rm $WORKINGDIRECTORY/.passage/config/genesis.json
            wget https://snapshots.polkachu.com/genesis/passage/genesis.json -P $WORKINGDIRECTORY/.passage/config/
            cat << EOF > /etc/systemd/system/passage.service 
[Unit] 
Description=Passage Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/passage start --home $WORKINGDIRECTORY/.passage/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable passage
        sudo systemctl start passage
	    tput setaf 7; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u passage -f --no-hostname -o cat`'; tput sgr0;;

#STRIDE           
    9) tput setaf 5; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 5; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 5; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 5; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 5; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 5; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_stride=$(curl -s https://stride.api.chandrastation.com/node_info)
            export STRIDE_VERSION=$(echo $response_stride | jq -r '.application_version.version')
            git clone https://github.com/Stride-Labs/stride 
            cd stride/ 
            git checkout $STRIDE_VERSION
            make install
        cp ~/go/bin/strided /usr/bin/strided
        strided init $NAME --home $WORKINGDIRECTORY/.strided/
        SNAP_RPC_1="https://stride-rpc.polkachu.com:443"
        #SNAP_RPC_2="http://comdexsentry01.skynetvalidators.com:26657"
        LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
        BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
        TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
            sed -i 's/seeds = ""/seeds ="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:12256"/g' $WORKINGDIRECTORY/.strided/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "04d318079c00e1f83978df486e3dbfcf9fab7a52@93.190.141.81:26656,6135b95e3989fc1d1067a23a345e42d661397deb@86.32.74.154:26656,022fd83f945fe03f9155fced534c90b5ce8db979@65.109.23.238:36656,64be41ff925b32a81cfb13a81fd4847aef2524aa@34.66.206.221:26656,c917a2f2ca2d40c42bd97d15de8686648c12941b@148.71.46.4:46656,5383a21cf2d5e513aea2c3e430133f31aa2e5d00@138.201.32.103:26656,c948379b649bc6609557dd74f5a4e70716f100ea@51.210.240.201:10456,8ade90b45b991088c92e8583e8bc93589d6cd81e@84.244.95.247:26656,8a210f1bcfc9015a7bc18dcc5add29c0dce3f2dc@135.181.173.67:26656,233e06cfa51d53e186afe032e848f5c9f5cd4a01@83.171.248.3:26656,97e4468ac589eac505a800411c635b14511a61bb@144.76.239.27:26656,cb0b38aa612e8ac05f704d9b2feb7526607afb77@66.94.117.176:26656,abaf98731ce081fa2f32da7db0ff27b1db1c1c99@80.64.208.151:26656,ab333c8e716ca2f005e3ae74a6a44d90ae4cbc7c@34.68.196.138:26656,f5732d5a406bdbbf08acad017c0993c0aa8ebe70@34.145.16.183:26656,0dfe60f0c62711a5ab13387cf1cc87e78b272336@23.88.116.72:27005,93d7b9da65d31e052027abf20fab35ff31d3d826@195.20.240.90:26656,ed857708c330334e1e62751470d6ecddf0397459@65.109.69.59:12256,e1b058e5cfa2b836ddaa496b10911da62dcf182e@138.201.8.248:26656,6b615c7dde3e76de39474b7406bdde0ac0f31b79@23.88.69.22:28666,59a13b0e8ce91c6d507b06c09b0ed44a1574cad3@54.177.215.240:26656,bba10290da32f3cb41e15c3a192413666ce05cee@136.243.119.243:26656,7ec6917a0519decec00a9a29f599c4d90ebf3b86@65.21.136.170:51656,9063fce4a1fc50185b2cafd56bc8176a45072c09@57.128.133.23:26656,f452fbafd9c5dd0ce7c0ecd6bf2ba413aedb88aa@65.108.229.244:36656,a83cd29f4f9a4711346184966f9fb6c80bb658d2@65.108.103.184:21656,2254e6968e5c7ebc98ef5b79b388502fa44e10e1@5.161.134.44:26656,fb8505c994cb90927c766e3c3d2db38044a596bc@139.59.31.201:26656,c7a30393c5cab01f5b497c4c094424e4e6271bac@65.108.201.154:5010,18704d8ffb35d412adb3fb8eea62c894cf175e75@86.48.26.130:26656,1ec2a654e00e22279ee50f13f074f2bce7218681@15.235.114.194:10156,82588f011491c6100d922d133f52fc23460b9231@135.181.67.235:26656,6cceba286b498d4a1931f85e35ea0fa433373057@78.47.208.99:26656,8ad2b947c96a6cf95afc29a7ea13cda5827688d8@65.109.105.110:11656,7bbb4b5b161e38938414949ec3a82f4ac8ffb4ad@38.242.211.235:26656,9731222819ddacf2b0238e51527aa95156a04b06@57.128.133.22:26656,471518432477e31ea348af246c0b54095d41352c@78.47.210.211:26656,e726816f42831689eab9378d5d577f1d06d25716@176.9.188.21:26656,cb06eb107f7f7d15024716149ed522f39175a743@155.133.22.10:22556,5093547fdf0430143ac66b4ee55d80e6542a6c10@217.174.247.163:26656,222b5f1f8f8b4933c1913818ab2b7379c282b4e2@65.108.75.107:11656,bbe196ec7c537e9dac0d2575350a1aa64700cdef@129.213.159.218:26656,8e4e1f1e087c76c71c64e477e95495833da82aa2@135.181.173.139:26656,4744bca666bfb213438e92217bfbd84e3543573d@65.108.130.171:26656,4e1c2471efb89239fb04a4b75f9f87177fd91d00@95.217.151.243:26656,bf9168fbcc7250c7c5b9d8080cd4eeee6e399913@95.214.53.214:26886,0393c19b176d1cf8bc560c5a8fa990301deb1a7e@95.217.126.187:26656,85727298865109933deddedb7d65f25a815902db@51.158.62.39:23856,0d8efc8205826a74867dd063c30aa24342dd652b@83.136.251.210:26656,7ef5ff00fe94933b8ba4b7ae4a8632ece5db11df@35.203.189.148:26656,f93ce5616f45d6c20d061302519a5c2420e3475d@135.125.5.31:54356,c124ce0b508e8b9ed1c5b6957f362225659b5343@144.76.177.187:26656,718ce477a62a14efe61571bd836fd3db9e43e6c1@38.105.232.61:26656,d2247f7b919f0781c90ee61958d7044665a22d38@169.155.44.213:26656,a4b4e2befe485ab1bc4d05775162d1edbaad428a@137.184.9.18:31309,068dd2e01b16710469518eefa42417425a17ffbe@54.196.249.249:26656,d056dcd5ac8dddb23e2962a5ade6ee51f9bfd785@162.19.89.8:10456,a3f95b0b15c31a68a7535f6068c4e14b95e90dcf@65.109.92.240:21016,ea6a7b2f366bc343f0670f1673fd86001dd08eb0@65.108.122.246:26636,e3acd71e2a35efd98dc6038a156ee3de1f3b08bd@51.89.7.234:26639,d9bfa29e0cf9c4ce0cc9c26d98e5d97228f93b0b@65.109.88.38:16656,b7645e17efb21d31aa718cf7f1cf249650d81de4@85.10.203.235:26696,f1329fdfcc5ec83ee4f52c71a3b5b611006bee1d@149.202.72.186:26639,c484f998e1a9e464a68af04d8d15d6fb0aeceb1e@65.21.129.95:26656,8d7d0f32d53467c4d5e8871faf4ec58ea970fed2@157.90.179.182:26456,cc35475fe1f7c345af0ea8a692f3b4b41c8f12a2@116.202.36.240:10156,722884e3add85791c34a0563253dc47901320878@65.108.238.61:36656,10c06b03ccdea2e92f694e83cd4addfef6cf6961@95.214.52.188:26656,0003bf00c79e8ebd1f31c0f83ad3d181f97f98e9@62.109.17.96:26656,04b797b5a56fb939a97a3c7d9c3230d09b85e8d7@93.189.30.118:26656,698ecde23465c1d01d02cc364f36426d259ba1f0@192.99.247.170:26656,a7d96dc929824613315dcc1c90fee119f28cc51f@164.152.160.155:26656,5dbe792854b8f81df6c6fe5b7aa64d60b27f6100@137.184.235.212:26656,a77173bc4f4171fec0ac56b37c18e0ba6e5f80a4@65.108.226.44:31656,a206a5ff59132c3f771735dec337432e6cfb2f7c@15.235.53.45:2062,6831d67983cf5ebcb44da01737ccd6ccbd15c08e@193.70.47.90:12256,89757803f40da51678451735445ad40d5b15e059@169.155.168.67:26656,f602040562935873815a5ac23cb1ac7dd8821b76@176.9.22.117:26656,d5035bd01baef508402b8649a33afc7b0fd190f1@141.95.72.74:24095,d77e7918b9f9e21ee60a8e03075ca3e5f7353912@162.55.4.253:26656,f8e2f80a8c58e6f53cc4940f5f1eac55c9067480@35.247.153.164:26656,921b74b0d483b13e786becb7fc196671d90e3fab@66.172.36.137:28656,e821acdaf0c7a3c60ea3cd4eb4a98a62dad06f58@43.201.12.41:26656,68f8dd5372e444bef54f94a62f970c6982aeaae7@51.38.52.188:26639,6856de6f0c70a850db2b58deb43d568fced4a524@35.208.80.214:26656,2759b35254db04b575beeb300cbbb63052374703@65.109.27.156:26656,f7eac82316123b03152175e4dbd003edc9e175cb@148.251.19.197:26686,d95477fd745d8a5e4b3d9052149d28a5dc447a88@35.206.158.54:26656,bffe92095850b08f905f6fde1d4282b4a619a690@5.161.97.148:26656,777274fb08ed48a4e027664e2576a8460272e43c@15.235.115.153:26656,b212d5740b2e11e54f56b072dc13b6134650cfb5@164.152.160.97:26656,f5e00226bf8a3854ba06e9b2f2e9b9ac0ecc8414@146.59.52.39:24095,dfc62810eeaab86587b2975c79f3c12d4830652d@15.235.114.54:26656,cd680cc992983e5c8244b5529034a2e362e7a6d3@93.159.134.157:26656,05eec003db41d7ff47a317ef59f83e31bdca23c3@78.107.234.44:26656,d36ac7580cc8907a00b0add8c3b047caea6df4ed@107.155.67.202:26636,20f56a68a04eedc764b7e1b87b7032a50b9d4fe9@51.81.155.97:10456,ad6700400ff6a76b442e96e772e1f1d641bd3560@35.202.81.184:26656,c9027c0429bca7dc7a441d7764d404d50694c225@66.206.17.178:26665,9ee75491e354965d8bfd8434aa093f8613bc1dce@65.108.238.103:12256,44e797771bff124693e63a8ec331d42873cf2ae2@95.217.202.49:35656,950da031d9536b9fbd0e9f0c70d65740d11d0111@192.118.76.199:26626,0e202ae079fb8b1849993ef6e6e6bd012b10374f@46.4.81.204:45656,3963b7cd5230ae2ba6800375421982d535a133e3@35.79.215.251:26656,ebc272824924ea1a27ea3183dd0b9ba713494f83@185.16.39.158:26886,d1008e1bfa6b0d1b317c69c08a80ced4a5b096bc@65.108.202.143:26656,cb6ae22e1e89d029c55f2cb400b0caa19cbe5523@15.156.2.222:26603,7ab3bfcdbe618ed62317cbc40ef48aee783fb2b4@144.76.152.68:4656,8385b1a396afa02e777740277ed7b731e092bf49@185.167.96.231:26656,aa0d47509ecadb630189fe4ef071d438a6493e69@178.162.165.194:24095,ca92abdc4599dd91dd63e689c64c468df5425f2c@95.216.100.99:16656,da56a252a1ed282f33f9171b18e41390528dbcbd@95.217.170.202:27013,a757fc9ea95a7f643d392ec9fdaa31cbf06e76d9@195.3.221.21:12256,061dcf3318978ac0448e848507c0b51bfa706b6d@35.226.95.79:26656,15bc324fbf6ed5347d9a6450bb73f7251c3f2b95@167.235.107.42:27012,e3eec2c5caa8723b9ee873a2c2fb3124bd083c1d@65.108.200.49:26996,7b59248957e391dfb6c1ba71fe4cbf471ca14fc2@65.108.97.58:16656,ed70fb7322fda1ee4646df34b47919ec6728586b@96.234.160.22:26656,8fff37214fb0ef622f1c09dccb22d6321e004c3e@109.123.242.163:50056,a7b4cf6f65138ba61518c2c45402da32dc8e28b7@88.99.164.158:21016,9faa9644bb761f9e84fd121d3a7a4f3277e5683a@198.244.178.213:6969"/g' $WORKINGDIRECTORY/.strided/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' $WORKINGDIRECTORY/.strided/config/app.toml 
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC_2\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.strided/config/config.toml
        sudo rm $WORKINGDIRECTORY/.strided/config/genesis.json
            wget https://github.com/osmosis-labs/osmosis/raw/main/networks/osmosis-1/genesis.json -P $WORKINGDIRECTORY/.strided/config/
            cat << EOF > /etc/systemd/system/strided.service 
[Unit] 
Description=Stride Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/strided start --home $WORKINGDIRECTORY/.strided/
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload
        sudo systemctl enable strided
        sudo systemctl start strided
	    tput setaf 5; echo 'Congrats your node is now syncing with the network | Check the logs with `journalctl -u strided -f --no-hostname -o cat`'; tput sgr0;;
    
    10) echo "selected Cancel";;
esac
