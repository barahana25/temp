## 설치
(
set -e
sudo apt update && sudo apt install -y cmake build-essential git git-lfs
eval "$(conda shell.bash hook)"
conda create -y -n isaaclab3 python=3.12
conda activate isaaclab3
pip install --upgrade pip
pip install "isaacsim[all,extscache]==6.1.0" --extra-index-url https://pypi.nvidia.com
pip install -U torch==2.10.0 torchvision==0.25.0 --index-url https://download.pytorch.org/whl/cu128
cd ~
git clone --recursive -b release/3.0.0 https://github.com/isaac-sim/IsaacLab IsaacLab3
cd IsaacLab3
export OMNI_KIT_ACCEPT_EULA=YES
./isaaclab.sh --install
echo "===== 설치 완료 ====="
)

## 설치확인
conda activate isaaclab3
cd ~/IsaacLab3
export OMNI_KIT_ACCEPT_EULA=YES
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py --viz kit
