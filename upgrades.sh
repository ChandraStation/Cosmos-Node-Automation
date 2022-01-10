while true; do
    read -p "Do you wish to install the updated genesis?" yn
    case $yn in
        [Yy]* ) wget $GENESIS; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


while true; do
    read -p "Do you wish to reset the node database?" yn
    case $yn in
        [Yy]* ) akash unsafe-reset-all; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
