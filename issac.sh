## 설치
(
set -e

# 1. Miniconda 설치 (conda 명령어가 없을 경우에만 진행)
if ! command -v conda &> /dev/null; then
    echo "===== Miniconda 설치 시작 ====="
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    eval "$(~/miniconda3/bin/conda shell.bash hook)"
    conda init bash
    echo "===== Miniconda 설치 완료 ====="
fi

# 2. 시스템 패키지 업데이트 및 기본 도구 설치
sudo apt update && sudo apt install -y cmake build-essential git git-lfs

# 3. Conda 환경 구축 및 Isaac Lab 설치
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
