while true; do
    read -p "Please select the network you would like to upgrade" yn
    case $yn in
        [Aa]* ) export COSMOS_NETWORK=.akash; break;;
        [Ss]* ) export COSMOS_NETWORK=.sentinel break;;
        [Oo]* ) export COSMOS_NETWORK=.osmosis break;;
        * ) echo "Please select your network.";;
    esac
done

while true; do
    read -p "Do you wish to install the updated genesis?" yn
    case $yn in
        [Yy]* ) rm ~/$COSMOS_NETWORK/config/genesis.json
		wget $GENESIS -P ~/$COSMOS_NETWORK/config/; break;;
        [Nn]* ) exit;;
	[Ss]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done


while true; do
    read -p "Do you wish to reset the node database?" yn
    case $yn in
        [Yy]* ) akash unsafe-reset-all; break;;
        [Nn]* ) exit;;
	[Ss]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
