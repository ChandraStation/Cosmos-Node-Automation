# Repo for automating the setup of a validator server

## Dependencies
* Any Linux Distro 
* 6 core + CPU (AMD)
* 16GB RAM
* 1TB NVME SSD

## Node Standup
Use this bash script to automate the installation and initilization of various Cosmos Nodes. 
```git clone https://github.com/ChandraStation/Validator-Automation
cd Validator-Automation/
chmod +x node.sh
bash node.sh```
Simply follow the script prompts and select your answers


## Supported Networks
* Akash
* Canto - Missing
* Chihuahua
* Comdex
* Dig
* e-Money
* Evmos - Missing
* Gravity - Missing
* Kava - Missing
* OmniFlix
* Osmosis
* Passage - Missing
* Sentinel
* Stride - Missing


(Feel free to upkeep the repo with up to date links to genesis & software versions while we automate those processes)

## To do List

- [x] Add OS Select
- [x] Iterate remainder of networks
- [x] ASCII
- [x] Remove Yes/No
- [x] Start snapshotting all supported networks
- [x] Add Multi Network Select
- [x] Add node name selection
- [x] Add go back
- [ ] Add All networks mentioned above (Missing: Evmos, Gravity, Kava, Passage, Stride)
- [ ] Add Progress Bar
- [ ] Create loop - Maybe
- [ ] API's needed (Dig, e-Money, Evmos, Gravity, Kava, Omniflix, Osmosis, Passage, Sentinel, Stride)

