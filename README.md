
VHDL design under test with VUnit verification framework. Tests run via GHDL 4.1.0 LLVM simulator.


## Repository URL
https://github.com/pavibur/fpga-parametric-timer.git


## Local Test Setup
**Tested: Windows 11 + WSL Ubuntu 22.04 LTS**


### 1. Prerequisites
sudo apt update
sudo apt install -y llvm-14-runtime libllvm14 llvm-14 gnat-10 libgnat-10 libc6-dev gcc make build-essential gtkwave python3.10-venv zlib1g-dev
cd /tmp/
wget https://github.com/ghdl/ghdl/releases/download/v4.1.0/ghdl-gha-ubuntu-22.04-llvm.tgz
sudo tar -xzf ghdl-gha-ubuntu-22.04-llvm.tgz -C /opt/
hash -r
export PATH="/opt/bin:$PATH"      


### 2.Clone & Environment Setup
mkdir ~/vunit_project && cd ~/vunit_project
git clone https://github.com/pavibur/fpga-parametric-timer.git
cd fpga-parametric-timer
python3 -m venv venv
source venv/bin/activate   
pip install vunit_hdl    
python -m pip install --upgrade pip setuptools wheel          

### 3. Verify Installation
ghdl --version                                        

### 4. Run Tests
python run.py --gtkwave-fmt ghw
