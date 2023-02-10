# Repo for automating the setup of a validator server

## Dependencies
* **Basically** Any Linux Distro 
* 6 core + CPU (AMD Preferred)
* 16GB RAM
* 1TB NVME SSD

## Node Standup
Use this bash script to automate the installation and initilization of various Cosmos Nodes. 
git clone https://github.com/ChandraStation/Validator-Automation
cd Validator-Automation/
bash node.sh
Simply follow the script prompts and select/input your answers

### Quickstart Guide
- $WORKING_DIRECTORY = Where you would like your node config and data files to be located.
- $USER = Your machines current user.
- $NODE_NAME = Your nodes moniker.
- Nodes are synced using statesync (Currently we are using [Polkachu](https://polkachu.com) but we will begin to rollout our own statesync infra on certain networks.)
- Ports are left stock, if you would like to sync multiple nodes on the same machine, simply change the ports after installation and restart your node
- Commands to note :
    * systemctl start <network> (This starts your node)
    * systemctl restart <network> (This restarts your node)
    * journalctl -u <network> -f (This shows your nodes logs)

## Supported Networks
* Akash
* Canto 
* Chihuahua
* Comdex
* Evmos
* Gravity
* Kava
* Osmosis
* Passage
* Stride


## To Do List
- [x] Add OS Select
- [x] Iterate remainder of networks
- [x] ASCII
- [x] Remove Yes/No
- [ ] Start snapshotting/statesynbcing all supported networks
- [x] Add Multi Network Select
- [x] Add node name selection
- [x] Add go back
- [ ] Add Progress Bar

## Adding A Network
Make a request by submitting an issue :) or if you get it make a PR to the main branch.