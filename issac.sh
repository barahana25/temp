## 설치
(
set -e

# 1. 기존 IsaacLab3 디렉토리가 있다면 깔끔히 삭제
if [ -d "$HOME/IsaacLab3" ]; then
    echo "===== 기존 IsaacLab3 디렉토리 삭제 중 ====="
    rm -rf ~/IsaacLab3
fi

# 2. Miniconda 설치 및 기존 Conda 경로 감지
CONDA_DIR=""
if [ -d "$HOME/miniconda3" ]; then
    CONDA_DIR="$HOME/miniconda3"
elif [ -d "$HOME/anaconda3" ]; then
    CONDA_DIR="$HOME/anaconda3"
fi

if [ -z "$CONDA_DIR" ] && ! command -v conda &> /dev/null; then
    echo "===== Miniconda 설치 시작 ====="
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    CONDA_DIR="$HOME/miniconda3"
    echo "===== Miniconda 설치 완료 ====="
fi

# PATH 및 Conda 훅 로드
if [ -n "$CONDA_DIR" ]; then
    export PATH="$CONDA_DIR/bin:$PATH"
    eval "$("$CONDA_DIR/bin/conda" shell.bash hook)"
else
    eval "$(conda shell.bash hook)"
fi

# Conda 약관/채널 설정
conda config --set auto_accept_tos yes 2>/dev/null || true
conda config --add channels conda-forge 2>/dev/null || true
conda config --set channel_priority strict 2>/dev/null || true

# 3. 시스템 패키지 업데이트 및 기본 도구 설치
sudo apt update && sudo apt install -y cmake build-essential git git-lfs

# 4. Conda 환경 구축 및 Isaac Lab 설치
conda create -y -n isaaclab3 python=3.12
conda activate isaaclab3

pip install --upgrade pip
pip install lazy_loader

pip install "isaacsim[all,extscache]==6.1.0" --extra-index-url https://pypi.nvidia.com
pip install -U torch==2.10.0 torchvision==0.25.0 --index-url https://download.pytorch.org/whl/cu128

cd ~
git clone --recursive -b release/3.0.0 https://github.com/isaac-sim/IsaacLab IsaacLab3
cd IsaacLab3
export OMNI_KIT_ACCEPT_EULA=YES

# Isaac Lab 기본 설치 및 하위 확장 모듈(isaaclab_newton 포함) 전수 editable 설치
./isaaclab.sh --install
pip install -e source/extensions/omni.isaac.lab
pip install -e source/extensions/omni.isaac.lab_tasks
pip install -e source/extensions/omni.isaac.lab_assets
pip install -e source/extensions/omni.isaac.lab_newton 2>/dev/null || true
pip install -e source/extensions/isaaclab_newton 2>/dev/null || true

echo "===== 설치 완료 ====="
)

## 설치확인
if [ -d "$HOME/miniconda3" ]; then
    eval "$("$HOME/miniconda3/bin/conda" shell.bash hook)"
elif [ -d "$HOME/anaconda3" ]; then
    eval "$("$HOME/anaconda3/bin/conda" shell.bash hook)"
else
    eval "$(conda shell.bash hook)"
fi

conda activate isaaclab3
cd ~/IsaacLab3
export OMNI_KIT_ACCEPT_EULA=YES
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py --viz kit
