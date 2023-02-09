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

case `select_opt "Akash" "Canto" "Chihuahua" "Comdex" "Dig" "e-Money" "Evmos" "Gravity" "Kava" "OmniFlix" "Osmosis" "Passage" "Sentinel" "Stride" "Cancel"` in
    
#AKASH    
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

#CANTO    
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
            sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:15556"/g' $WORKINGDIRECTORY/.cantod/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "744294d2ecf5ddf14065be6d325e68dcbdf0c646@66.172.36.136:51656,f9fc759eb2fa4eb2159825cae149ba1065efa236@66.172.36.134:51656,81f89cfa6dd6ec4cb2ee297e67dd4613657c4194@88.198.32.17:30656,bea21c6cc721726a486dbd7f14c5e81ee12f6eaa@35.83.23.119:26656,f9f8f88dfde1bacca2f152089bb20c600dbb9d04@43.204.152.200:26656,510e68d0b0ccb903663637547bf641961c4c9987@185.229.119.216:26656,2d7826e04685c4afb7baf6a045a3098c1306e1cc@5.9.108.156:35095,8cb9419ede1d830e78b4dd1318bdbd4e6be000d7@144.76.27.79:36656,f3a0c2e660defc476dfe555ab128790422db1cf9@195.201.171.173:27656,76789b7d030697abbb9b0f1bed103abb4a66c029@138.201.85.176:26676,a441b9fec8006f28fb2add0517fa823b886834d6@5.79.79.80:35095,1d3ab5cc05452e29d8dafb4f96fcf3841c485287@51.210.223.185:35095,9723b0dac535d9e5c28e62413ddda54386ff8955@138.201.249.155:26656,bc091cdde82ad9a27a6b2b279b280aab1041d9bf@13.53.40.117:26656,8b2ac4899b5a0b6e289850bde707f45421d1e9a4@213.239.207.175:30656,43393ba9763a9b1b95785330c5059811e5ed7f91@95.217.122.80:17656,685c48cbc2ba54e20f49645d48b0878d6944d8e4@65.109.94.221:32656,978a3730fc791492c009ff380d8e8bb25997da1b@65.109.65.210:29656,b8cc93a20982f6e7dd0201757c642d2ddc76eee9@148.251.53.202:26656,484e252942ffcc0c6e31278ac0f47a3ca1317aef@142.132.238.165:26656,2ba20f6ff6be62590447ec964bb51bd67460f492@5.9.107.174:36656,16a92f17853f21032161829ef567c66bd483e387@137.184.225.205:26656,61c8c3dce43e7221a5dab1a3c86366f34d2edddd@213.239.215.77:26656,876a17aa48201ec9b8937d81e28b44bfcb4d318c@15.235.115.149:10004,34828d479df21e65068b6aa7b885cfaa6acb4118@5.75.140.177:26656,f724d16c43147bad59a036f243aa79c6f4455d2d@23.88.69.167:26858,cdad27c5be53788cbf42dd1336adeabc253b6e52@38.242.251.238:26656,82956d94714ded8fd785acb498a0aeb7aafad7ff@85.17.6.142:26656,5401995b201605a03d9e1fd0460cbef49218bbf5@65.108.126.46:32656,6ed040a6d393738c1bbeebd200c2e2f660614907@135.181.222.179:28656,bedcf918f53967cd37a0d03e67997d1b40c6c152@5.161.113.61:26656,fa20e4f196268858f56213c77bfa5481aeab4547@66.206.15.130:26656,f74639c33b7647b0462e634974147c20505747a6@213.239.216.252:23656,6085683689776e7103ea5ea87c0f74d9a69e21a2@167.235.200.184:26656,e6d62aa5215719eb1b7434e19bca4e7f62923ef4@65.108.106.172:58656,0da4f6242164ea9ce74bf6e8602c32d408140693@95.217.77.23:27656,c9e39b78c37b1bd360676d1e68f40a1f6c36d528@109.236.86.96:36656,69c21a89c74d08cb4a3c463dc813fe279fe4f080@51.79.160.214:26656,4fb5a871a1f263752da75e323e2ed73ed315a17f@95.214.52.138:26666,4a6ff3311b13fea6db8e6f28bb4a1527df3371bf@65.109.162.26:26656,54316791649b65af344432bf4bd31f46df0cb79c@51.195.234.49:27756,7be1b2faf6a308b6d445edb40f9598195f2455d9@148.251.41.20:26656,ab88f189db7825f376050a034d8bf0028442cfc3@34.89.161.101:26656,5ce67581ef51b30c70212a870f2e5ede27c31929@65.109.20.109:26656,ebd18bdf64ac9b8d0e38ab8706fcf9ee1d54e70a@95.217.35.186:60656,6e7e9341fba194988d448393b2d77464107385c5@65.108.199.222:22496,d36a57b72f12cc648aeb0b417002a2dc390c76c2@89.58.19.40:26656,a0a165866cf5408ed26459ff91e3968807fb13dd@152.228.215.7:26656,439d6746ec2ddeb03a4328e9ab1d0806e5d46ccd@34.252.21.196:26656,8e4d886e7c333e73cdf1f0271b05511a1866d515@65.109.49.163:56656,ec623695c6dfaa265d9d7f5e3b058c51bca63f4f@65.108.124.219:27656,9188d4b9b9e1a7e86ac6a0e6bee343e4c5f6fa25@114.32.170.200:26656,325eaed0931fc7d743c6ee9b124bca334ff8dc2c@65.109.92.241:21216,a93a2839d71a1a705c912163fcf3280e674c5647@204.93.241.110:27650,95296d725bf8d869147e33d236c3cb6102601529@95.217.192.230:46656,855dc3bfa1303bc8de211181918de78f1d9be7c8@67.205.146.202:26656,c7e5de7911802a8c7f80c046ad93152476898d56@202.61.194.254:36656,1797a6e3a45ea538dc669e296e5f76a3b510d101@65.109.29.150:26656,f77128aa0e32853a5938642521990a69b4ae95e7@144.76.195.147:26656,3b25a50bf0fd8f5e776d2e17f4a0d75883bca7fb@65.108.227.42:26656,f15b2375cbfb2b9200096e311b8a1f703e7c2a68@149.102.153.162:26656,81fc7f83e9961790a279a1fbe3e2835cea032d0c@37.252.184.229:26656,43882ebdac4fef48671b35c236122cfcefef413c@63.141.239.202:26656,80e65f207db973bc98d5b02daf5db0607b0a382e@66.172.36.133:51656,26c20d0d4875abfbb9269e5cd57e8f9245ff4c71@65.108.126.35:27656,36707368a40d6bffc78607932a6ab1041058c337@54.228.70.29:26656,74346567ad07541f8163be580c2b6667a1f97fe5@95.214.53.105:36656,0ea8451a880b469be9f94a379dc2b63ea829d16a@208.91.106.29:26656,42e5c9923c06e2100a19814c2fffbbdea641032d@15.235.114.194:10456,7c148e004ec16f7849e148ba56e6a985202105a3@34.207.111.238:26656,6b90bb94063007ff88c14585debd84ababd7d637@65.108.79.198:26766,21fbfac4b643d06ed0edf92e22b2836a1a6e06a2@195.201.123.208:26656,64172382922c636354387436d7e3b494b1abf577@46.10.221.196:26656,cf5dc9c8eb848ce339e4ce7af7db50a46799edef@146.190.136.204:26656,174f015f606fd1f139447158b81a1824f6352854@65.108.75.107:16656,acabacac1035aa397986dc4857df3e02c75af3b0@209.195.12.133:26678,59402a36fad885b6ebf39a218a49c1a833f074ad@206.189.20.122:26656,e8c319413af0063eedca8a8116c969eb34606571@65.1.127.238:26656,626de9047438626ba9a90840ad053dd5d6628844@3.7.14.149:26656"/g' $WORKINGDIRECTORY/.cantod/config/config.toml
            sed -i 's#laddr = "tcp://127.0.0.1:26657"#laddr = "tcp://127.0.0.1:51657"#g' $WORKINGDIRECTORY/.cantod/config/config.toml
            sed -i 's#laddr = "tcp://0.0.0.0:26656"#laddr = "tcp://0.0.0.0:51656"#g' $WORKINGDIRECTORY/.cantod/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:5190"/g' $WORKINGDIRECTORY/.cantod/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:5191"/g' $WORKINGDIRECTORY/.cantod/config/app.toml
            sed -i 's/address = "0.0.0.0:8545"/address = "0.0.0.0:5145"/g' $WORKINGDIRECTORY/.cantod/config/app.toml
            sed -i 's/ws-address = "0.0.0.0:8546"/ws-address = "0.0.0.0:5146"/g' $WORKINGDIRECTORY/.cantod/config/app.toml
            sed -i 's/minimum-gas-prices = "0acanto"/minimum-gas-prices = "4000000000000acanto"/g' $WORKINGDIRECTORY/.cantod/config/app.toml 
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
        rm -rf $WORKINGDIRECTORY/.cantod/data/
            wget https://snapshots.polkachu.com/snapshots/canto/canto_2864227.tar.lz4 -P $WORKINGDIRECTORY/.cantod
            lz4 $WORKINGDIRECTORY/.cantod/canto_2864227.tar.lz4
            tar -xvf $WORKINGDIRECTORY/.cantod/canto_2864227.tar -C $WORKINGDIRECTORY/.cantod/
            rm $WORKINGDIRECTORY/.cantod/canto_2864227.tar.lz4
            rm $WORKINGDIRECTORY/.cantod/canto_2864227.tar
        systemctl daemon-reload 
        systemctl enable cantod
        systemctl start cantod
	    tput setaf 2; echo 'Congrats your node is now syncing with the network'; tput sgr0;;

#CHIHUAHUA    
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
        chihuahuad init $NAME --chain-id chihuahua-1 --home $WORKINGDIRECTORY/.chihuahua/
            sed -i 's/seeds = ""/seeds = "4936e377b4d4f17048f8961838a5035a4d21240c@chihuahua-seed-01.mercury-nodes.net:29540"/g' $WORKINGDIRECTORY/.chihuahua/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "b140eb36b20f3d201936c4757d5a1dcbf03a42f1@216.238.79.138:26656,19900e1d2b10be9c6672dae7abd1827c8e1aad1e@161.97.96.253:26656,c382a9a0d4c0606d785d2c7c2673a0825f7c53b2@88.99.94.120:26656,a5dfb048e4ed5c3b7d246aea317ab302426b37a1@137.184.250.180:26656,3bad0326026ca4e29c64c8d206c90a968f38edbe@128.199.165.78:26656,89b576c3eb72a4f0c66dc0899bec7c21552ea2a5@23.88.7.73:29538,38547b7b6868f93af1664d9ab0e718949b8853ec@54.184.20.240:30758,a9640eb569620d1f7be018a9e1919b0357a18b8c@38.146.3.160:26656,7e2239a0d4a0176fe4daf7a3fecd15ac663a8eb6@144.91.126.23:26656"/g' $WORKINGDIRECTORY/.chihuahua/config/config.toml
            sed -i 's#laddr = "tcp://127.0.0.1:26657"#laddr = "tcp://127.0.0.1:56657"#g' $WORKINGDIRECTORY/.chihuahua/config/config.toml
            sed -i 's#laddr = "tcp://0.0.0.0:26656"#laddr = "tcp://0.0.0.0:56656"#g' $WORKINGDIRECTORY/.chihuahua/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:5090"/g' $WORKINGDIRECTORY/.chihuahua/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:5091"/g' $WORKINGDIRECTORY/.chihuahua/config/app.toml
            sed -i 's/minimum-gas-prices = "0stake"/minimum-gas-prices = "0.025uhuahua"/g' $WORKINGDIRECTORY/.chihuahua/config/app.toml 
        sudo rm $WORKINGDIRECTORY/.chihuahuad/config/genesis.json             
            wget -O /.chihuahua/config/genesis.json https://raw.githubusercontent.com/ChihuahuaChain/mainnet/main/genesis.json -P $WORKINGDIRECTORY/.chihuahua/config/ 
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
        rm -rf $WORKINGDIRECTORY/.chihuahua/data/
            wget https://snapshots.stake2.me/chihuahua/chihuahua_$(date +"%Y-%m-%d").tar -P $WORKINGDIRECTORY/.chihuahua/data
            tar -xvf $WORKINGDIRECTORY/.chihuahua/data/chihuahua_$(date +"%Y-%m-%d").tar
        systemctl daemon-reload 
        systemctl enable chihuahuad
        systemctl start chihuahuad
	    tput setaf 3; echo 'Congrats your node is now syncing with the network'; tput sgr0;;

#COMDEX
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
            sed -i 's/seeds = ""/seeds ="aef35f45db2d9f5590baa088c27883ac3d5e0b33@3.108.102.92:26656"/g' $WORKINGDIRECTORY/.comdex/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656"/g' $WORKINGDIRECTORY/.comdex/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' $WORKINGDIRECTORY/.comdex/config/app.toml
            sed -i 's#laddr = "tcp://127.0.0.1:26657"#laddr = "tcp://127.0.0.1:22657"#g' $WORKINGDIRECTORY/.comdex/config/config.toml 
            sed -i 's#laddr = "tcp://0.0.0.0:26656"#laddr = "tcp://0.0.0.0:22656"#g' $WORKINGDIRECTORY/.comdex/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:2290"/g' $WORKINGDIRECTORY/.comdex/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:2291"/g' $WORKINGDIRECTORY/.comdex/config/app.toml 
        sudo rm $WORKINGDIRECTORY/.comdex/config/genesis.json
            wget https://github.com/comdex-official/networks/raw/main/mainnet/comdex-1/genesis.json -P $WORKINGDIRECTORY/.comdex/config/ 
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
        rm -rf $WORKINGDIRECTORY/.comdex/data/
            wget https://snapshots.polkachu.com/snapshots/comdex/comdex_1337920.tar.lz4 -P $WORKINGDIRECTORY/.comdex/data
            tar -xvf $WORKINGDIRECTORY/.comdex/data/comdex
        sudo systemctl daemon-reload
        sudo systemctl enable comdex
        sudo systemctl start comdex
        tput setaf 1; echo 'Congrats your node is now syncing with the network'; tput sgr0;;

#DIG            
    4)  tput setaf 3; echo 'What would you like your node name to be?'; tput sgr0/okanisis/Canto/tree/ethermint-v2-backport
	        read NAME
	    tput setaf 3; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 3; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 3; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 3; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 3; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_dig=$(curl -s https://dig.api.chandrastation.com/node_info)
            export DIG_VERSION=$(echo $response_dig | jq -r '.application_version.version')
            git clone https://github.com/notional-labs/dig 
            cd dig
            git checkout $DIG_VERSION
            cd cmd/digd 
            go install ./...
            cd 
        cp ~/go/bin/digd /usr/bin/digd 
        digd init $NAME --home $WORKINGDIRECTORY/.dig/
            sed -i 's/seeds = ""/seeds ="37b2839da4463b22a51b1fe20d97992164270eba@62.171.157.192:26656,e2c96b96d4c3a461fb246edac3b3cdbf47768838@65.21.202.37:6969"/g' $WORKINGDIRECTORY/.dig/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "33f4788e1c6a378b929c66f31e8d253b9fd47c47@194.163.154.251:26656,64eccffdc60a206227032d3a021fbf9dfc686a17@194.163.156.84:26656,be7598b2d56fb42a27821259ad14aff24c40f3d2@172.16.152.118:26656,f446e37e47297ce9f8951957d17a2ae9a16db0b8@137.184.67.162:26656,ab2fa2789f481e2856a5d83a2c3028c5b215421d@144.91.117.49:26656,e9e89250b40b4512237c77bd04dc76c06a3f8560@185.214.135.205:26656,1539976f4ee196f172369e6f348d60a6e3ec9e93@159.69.147.189:26656,85316823bee88f7b05d0cfc671bee861c0237154@95.217.198.243:26656,eb55b70c9fd8fc0d5530d0662336377668aab3f9@185.194.219.128:26656"/g' $WORKINGDIRECTORY/.dig/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.025udig"/g' $WORKINGDIRECTORY/.dig/config/app.toml 
            sed -i 's#laddr = "tcp://127.0.0.1:26657"#laddr = "tcp://127.0.0.1:32657"#g' $WORKINGDIRECTORY/.dig/config/config.toml 
            sed -i 's#laddr = "tcp://0.0.0.0:26656"#laddr = "tcp://0.0.0.0:32656"#g' $WORKINGDIRECTORY/.dig/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:3290"/g' $WORKINGDIRECTORY/.dig/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:3291"/g' $WORKINGDIRECTORY/.dig/config/app.toml 
        sudo rm $WORKINGDIRECTORY/.dig/config/genesis.json
            wget https://raw.githubusercontent.com/notional-labs/dig/master/networks/mainnets/dig-1/genesis.json -P $WORKINGDIRECTORY/.dig/config/ 
            cat << EOF > /etc/systemd/system/dig.service 
[Unit] 
Description=Dig Node
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKINGDIRECTORY
ExecStart=/usr/bin/digd start
Restart=on-failure
StartLimitInterval=0
RestartSec=3
LimitNOFILE=65535
LimitMEMLOCK=209715200

[Install]
WantedBy=multi-user.target
EOF

        sudo systemctl daemon-reload 
        sudo systemctl enable dig 
        sudo systemctl start dig 
	    tput setaf 3; echo 'Congrats your node is now syncing with the network'; tput sgr0;;


#E-MONEY            
    5)  tput setaf 2; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 2; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 2; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 2; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 2; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 2; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_emd=$(curl -s https://emd.api.chandrastation.com/node_info)
            export EMD_VERSION=$(echo $response_emd | jq -r '.application_version.version')
            git clone https://github.com/e-money/em-ledger 
            cd em-ledger 
            git checkout $EMD_VERSION
            make install 
        cp ~/go/bin/emd /usr/bin/emd 
        emd init $NAME --home $WORKINGDIRECTORY/.emd/
            sed -i 's/seeds = ""/seeds ="708e559271d4d75d7ea2c3842e87d2e71a465684@seed-1.emoney.validator.network:28656,336cdb655ea16413a8337e730683ddc0a24af9de@seed-2.emoney.validator.network:28656"/g' $WORKINGDIRECTORY/.emd/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "ecec8933d80da5fccda6bdd72befe7e064279fc1@207.180.213.123:26676,0ad7bc7687112e212bac404670aa24cd6116d097@50.18.83.75:26656,1723e34f45f54584f44d193ce9fd9c65271ca0b3@13.124.62.83:26656,34eca4a9142bf9c087a987b572c114dad67a8cc5@172.105.148.191:26656,c2766f7f6dfe95f2eb33e99a538acf3d6ec608b1@162.55.132.230:2140,eed66085c975189e3d498fe61af2fcfb3da34924@217.79.184.40:26656"/g' $WORKINGDIRECTORY/.emd/config/config.toml 
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.025ungm"/g' $WORKINGDIRECTORY/.emd/config/app.toml 
            sed -i 's#laddr = "tcp://127.0.0.1:26657"#laddr = "tcp://127.0.0.1:46657"#g' $WORKINGDIRECTORY/.emd/config/config.toml 
            sed -i 's#laddr = "tcp://0.0.0.0:26656"#laddr = "tcp://0.0.0.0:46656"#g' $WORKINGDIRECTORY/.emd/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:4090"/g' $WORKINGDIRECTORY/.emd/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:4091"/g' $WORKINGDIRECTORY/.emd/config/app.toml 
        sudo rm $WORKINGDIRECTORY/.emd/config/genesis.json 
            wget https://raw.githubusercontent.com/notional-labs/dig/master/networks/mainnets/dig-1/genesis.json -P $WORKINGDIRECTORY/.emd/config/ 
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
        rm -rf $WORKINGDIRECTORY/.emd/data/
            wget u250245-sub1@rsync.stakesystems.io:emoney/.emd/data/ -P $WORKINGDIRECTORY/.emd/data
            tar -xvf $WORKINGDIRECTORY/.emd/data/
        sudo systemctl daemon-reload 
        sudo systemctl enable emoney 
        sudo systemctl start emoney 
	    tput setaf 2; echo 'Congrats your node is now syncing with the network'; tput sgr0;;

#EVMOS           
    6)  tput setaf 1; echo 'Still under development'; tput sgr0 ;;

#GRAVITY           
    7)  tput setaf 6; echo 'Still under development'; tput sgr0 ;;

#KAVA           
    8)  tput setaf 1; echo 'Still under development'; tput sgr0 ;;

#OMNIFLIX            
    9)  tput setaf 5; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 5; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 5; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 5; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 5; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 5; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_omniflix=$(curl -s https://omniflix.api.chandrastation.com/node_info)
            export OMNIFLIX_VERSION=$(echo $response_omniflix | jq -r '.application_version.version')
            git clone https://github.com/OmniFlix/omniflixhub 
            cd omniflixhub 
            git checkout $OMNIFLIX_VERSION
            make install 
        cp ~/go/bin/omniflixhubd /usr/bin/omniflixhubd 
        omniflixhubd init $NAME --home $WORKINGDIRECTORY/.omniflixhub/
            sed -i 's/persistent_peers = ""/persistent_peers = "0a60b588671a5f1d1a524a66e86dbe40c81bd448@185.216.203.136:26656,55c6e002e769a752e1c80266e06afb5efbfc823c@38.242.206.186:26656,b10e09b559eb14d4dc07d43474ca0a1560391414@185.252.232.189:26656,a2077dce2d62cdcb8dc454f8eaef0e86846496ea@65.108.135.182:26656,c7f8c700f673cb586cebdcf85da3479724fa6988@65.108.128.241:26716"/g' $WORKINGDIRECTORY/.omniflixhub/config/config.toml 
            sed -i 's/laddr = "tcp://127.0.0.1:26657"/laddr = "tcp://127.0.0.1:31657"/g' $WORKINGDIRECTORY/.omniflixhub/config/config.toml 
            sed -i 's/laddr = "tcp://0.0.0.0:26656"/laddr = "tcp://0.0.0.0:31656"/g' $WORKINGDIRECTORY/.omniflixhub/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:3190"/g' $WORKINGDIRECTORY/.omniflixhub/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:3191"/g' $WORKINGDIRECTORY/.omniflixhub/config/app.toml 
        sudo rm $WORKINGDIRECTORY/.omniflixhub/config/genesis.json 
            wget https://raw.githubusercontent.com/OmniFlix/mainnet/main/omniflixhub-1/genesis.json -P $WORKINGDIRECTORY/.omniflixhub/config/ 
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

        sudo systemctl daemon-reload 
        sudo systemctl enable omniflix 
        sudo systemctl start omniflix 
	    tput setaf 5; echo 'Congrats your node is now syncing with the network'; tput sgr0;;

#OSMOSIS            
    10) tput setaf 4; echo 'What would you like your node name to be?'; tput sgr0
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
        osmosisd init $NAME --home $WORKINGDIRECTORY/.osmosis/
            sed -i 's/seeds = ""/seeds ="aef35f45db2d9f5590baa088c27883ac3d5e0b33@3.108.102.92:26656"/g' $WORKINGDIRECTORY/.osmosis/config/config.toml
            sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656"/g' $WORKINGDIRECTORY/.osmosis/config/config.toml
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucmdx"/g' $WORKINGDIRECTORY/.osmosis/config/app.toml 
            sed -i 's#laddr = "tcp://127.0.0.1:26657"#laddr = "tcp://127.0.0.1:36657"#g' $WORKINGDIRECTORY/.osmosis/config/config.toml 
            sed -i 's#laddr = "tcp://0.0.0.0:26656"#laddr = "tcp://0.0.0.0:36656"#g' $WORKINGDIRECTORY/.osmosis/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:3090"/g' $WORKINGDIRECTORY/.osmosis/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:3091"/g' $WORKINGDIRECTORY/.osmosis/config/app.toml 
        sudo rm $WORKINGDIRECTORY/.osmosis/config/genesis.json
            wget https://github.com/osmosis-labs/osmosis/raw/main/networks/osmosis-1/genesis.json -P $WORKINGDIRECTORY/.osmosis/config/
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
        rm -rf $WORKINGDIRECTORY/.osmosis/data/
            wget https://snapshots.stake2.me/osmosis/osmosis_2022-02-20.tar -P $WORKINGDIRECTORY/.osmosis/data
            tar -xvf $WORKINGDIRECTORY/.osmosis/data/osmosis_2022-02-20.tar
        sudo systemctl daemon-reload
        sudo systemctl enable osmosis
        sudo systemctl start osmosis
	    tput setaf 4; echo 'Congrats your node is now syncing with the network'; tput sgr0;;

#PASSAGE           
    11) tput setaf 7; echo 'Still under development'; tput sgr0 ;;

#SENTINEL            
    12) tput setaf 6; echo 'What would you like your node name to be?'; tput sgr0
	        read NAME
	    tput setaf 6; echo 'Your node $NAME is now set'; tput sgr0
        tput setaf 6; echo 'Input Your System Username'; tput sgr0
            read USERNAME
        tput setaf 6; echo 'Your username $USERNAME is now set'; tput sgr0
        tput setaf 6; echo 'Input Your Home Directory Path'; tput sgr0
	        read WORKINGDIRECTORY
	    tput setaf 6; echo 'Your Home Directory $WORKINGDIRECTORY is now set'; tput sgr0
        response_sentinel=$(curl -s https://sentinel.api.chandrastation.com/node_info)
            export SENTINEL_VERSION=$(echo $response_sentinel | jq -r '.application_version.version')
            git clone https://github.com/sentinel-official/hub
            cd hub 
            git checkout $SENTINEL_VERSION
            make install  
        cp ~/go/bin/sentinelhub /usr/bin/sentinelhub 
        sentinelhubs init $NAME --home $WORKINGDIRECTORY/.sentinelhub/
            sed -i 's/seeds = ""/seeds ="c7859082468bcb21c914e9cedac4b9a7850347de@167.71.28.11:26656"/g' $WORKINGDIRECTORY/.sentinelhub/config/config.toml 
            sed -i 's/persistent_peers = ""/persistent_peers = "f74518ad134630da8d2405570f6a3639954c985f@65.0.173.217:26656,d478882a80674fa10a32da63cc20cae13e3a2a57@43.204.0.243:26656,61d743ea796ad1e1ff838c9e84adb38dfffd1d9d@15.235.9.222:26656,b8468f64788a17dbf34a891d9cd29d54b2b6485d@194.163.178.25:26656,d8b74791ee56f1b345d822f62bd9bc969668d8df@194.163.128.55:36656,81444353d70bab79742b8da447a9564583ed3d6a@164.68.105.248:26656,5b1ceb8110da4e90c38c794d574eb9418a7574d6@43.254.41.56:26656,98b4522a541a69007d87141184f146a8f04be5b9@40.112.90.170:26656,9a59b6dc59903d036dd476de26e8d2b9f1acf466@195.201.195.111:26656"/g' $WORKINGDIRECTORY/.sentinelhub/config/config.toml 
            sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01udvpn"/g' $WORKINGDIRECTORY/.sentinelhub/config/app.toml 
            sed -i 's#laddr = "tcp://127.0.0.1:26657"#laddr = "tcp://127.0.0.1:26657"#g' $WORKINGDIRECTORY/.sentinelhub/config/config.toml 
            sed -i 's#laddr = "tcp://0.0.0.0:26656"#laddr = "tcp://0.0.0.0:26656"#g' $WORKINGDIRECTORY/.sentinelhub/config/config.toml 
            sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:2090"/g' $WORKINGDIRECTORY/.sentinelhub/config/app.toml 
            sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:2091"/g' $WORKINGDIRECTORY/.sentinelhub/config/app.toml 
        sudo rm $WORKINGDIRECTORY/.sentinelhub/config/genesis.json 
            wget https://github.com/sentinel-official/networks/raw/main/sentinelhub-1/genesis.zip -P $WORKINGDIRECTORY/.sentinelhub/config/ 
            unzip $WORKINGDIRECTORY/.sentinelhub/config/genesis.zip 
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
        rm -rf $WORKINGDIRECTORY/.sentinelhub/data/
            wget http://135.181.60.250:8083/sentinel/sentinelhub-2_$(date +"%Y-%m-%d").tar -P $WORKINGDIRECTORY/.sentinelhub/data
            tar -xvf $WORKINGDIRECTORY/.sentinelhub/data/sentinelhub-2_$(date +"%Y-%m-%d").tar
        sudo systemctl daemon-reload 
        sudo systemctl enable sentinel 
        sudo systemctl start sentinel
	    tput setaf 6; echo 'Congrats your node is now syncing with the network'; tput sgr0;;

#STRIDE           
    13) tput setaf 5; echo 'Still under development'; tput sgr0 ;;
    14) echo "selected Cancel";;
esac
