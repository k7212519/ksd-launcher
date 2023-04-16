#!/bin/bash
# echo start command to /dockerx/sh/sd.sh 
write_start_command() {
  sudo sed -i 's/docker exec.*//' /usr/lib/ksd-launcher/data/sd.sh
  COMMAND_ARG='docker exec -it stable-diffusion bash -c '

  active_env="cd /dockerx/stable-diffusion-webui && source venv/bin/activate && "
  start='python launch.py '
  args=' '

  if [ $1 -eq 1 ]; then  
    pre_args=' $proxy_command '
  elif [ $1 -eq 2 ]; then  
    pre_args=' $proxy_command HSA_OVERRIDE_GFX_VERSION=10.3.0 '
  elif [ $1 -eq 3 ]; then  
    active_env="cd /dockerx/stable-diffusion-webui && source /root/miniconda3/etc/profile.d/conda.sh && conda activate webui-py38-rocm && "
    pre_args=' $proxy_command HSA_OVERRIDE_GFX_VERSION=10.3.0 '
    args='--precision full --no-half'
  elif [ $1 -eq 4 ]; then  
    pre_args='$proxy_command PYTORCH_ROCM_ARCH=gfx906 HCC_AMDGPU_TARGET=gfx906 '
    # args='--precision full --no-half'
  elif [ $1 -eq 5 ]; then  
    echo 'rx500暂未支持，请关注bilibili/k7212519更新或github仓库更新'
  elif [ $1 -eq 6 ]; then  
    start='python3 launch.py --disable-safe-unpickle'
    pre_args=' $proxy_command '
  fi

  if [ $2 -eq 1 ]; then  
    echo -e "\n默认显存模式运行"
  elif [ $2 -eq 2 ]; then  
    echo -e "\n显存优化模式运行"
    args="$args --opt-sub-quad-attention --medvram "
  elif [ $2 -eq 3 ]; then  
    echo -e "\n低显存模式运行"
    args="$args --opt-sub-quad-attention --lowvram "
  fi

  COMMAND_ARG=$COMMAND_ARG'"'$active_env$pre_args$start$args'"'
  sudo echo $COMMAND_ARG >> /usr/lib/ksd-launcher/data/sd.sh
  
}


reset_sd() {
  docker stop stable-diffusion 2>/dev/null
  docker remove stable-diffusion 2>/dev/null

  DOCKERX_DIR="$HOME/dockerx"
  if [ -d "$DOCKERX_DIR" ]; then
    echo -e "\n检测到存在旧的dockerx目录，请手动备份自己的模型及插件！！！\n"
    read -p "确认已备份原有dockerx目录中的模型？ (Y/N) y确认: " choice
    if [[ "$choice" == [yY] ]]; then
      echo "删除原有dockerx目录中..."
      sudo rm -rf "$DOCKERX_DIR"
    else
      echo "保留dockerx目录"
      exit
    fi
  fi

  # Check if GNOME
  if [ "$(pidof gnome-shell)" ]; then
    gnome-terminal -- docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --name=stable-diffusion -v $HOME/dockerx:/dockerx $1
  # Check if KDE
  elif [ "$(pidof kwin)" ]; then
    konsole --noclose -e  docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --name=stable-diffusion -v $HOME/dockerx:/dockerx $1
  else
    echo -e "\n未检测到GNOME或KDE环境，将使用tmux新建窗口"
    sleep 3s
    sudo apt install tmux
    tmux new-session -d -s my-session "docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --name=stable-diffusion -v $HOME/dockerx:/dockerx $1"
  fi

  sleep 5s
  
  # 等待容器启动
  until [ "$(docker inspect -f '{{.State.Status}}' stable-diffusion)" = "running" ]; do
    echo -e "\n请等待docker容器启动......"
    sleep 3
  done
  echo -e "\ndcoker容器启动中，请勿关闭另一个窗口...！"
  sleep 3s

  echo -e "\n正在释放文件，请稍等..."
 
  # 启动子进程执行命令
  docker exec -it stable-diffusion bash -c "cp -a /sd_backup/. /dockerx/ && exit"
  
  # 最后输出命令执行完成
  sudo chmod -R 777 $HOME/dockerx
  # 写入启动参数
  write_start_command $gpu_choice $vram_choice
  
}

setup_sd() {
##########显卡型号选择##########
  gpu_choice=0
  vram_choice=0
  valid_choice=false
  valid_choice2=false
  while [ "$valid_choice" == false ]
    do
      echo "请选择您的显卡型号："
      echo "1. 6900 6800 系列"
      echo "2. 6700 6600 系列"
      echo "3. 5000 系列"
      echo "4. Vega 系列"
      echo "5. 500 系列"
      echo "6. 7900 系列"
      read -p "请输入选项编号： " choice
      case $choice in
      1)
        echo "您选择了 rx6900 6800 系列"
        valid_choice=true
        gpu_choice=1
        ;;
      2)
        echo "您选择了 rx6700 6600 系列"
        valid_choice=true
        gpu_choice=2
        ;;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
      3)
        echo "您选择了 rx5000 系列"
        valid_choice=true
        gpu_choice=3
        ;;
      4)
        echo "您选择了 rxVega 系列"
        valid_choice=true
        gpu_choice=4
        ;;
      5)
        echo "您选择了 rx500 系列"
        valid_choice=true
        gpu_choice=5
        ;;
      6)
        echo "您选择了 rx7900 系列"
        valid_choice=true
        gpu_choice=6
        ;;
      *)
        echo "无效的选项编号，请重新输入。"
        ;;
      esac
    done

  while [ "$valid_choice2" == false ]
    do
      echo "请选择您的显存大小："
      echo "1. > 8G "
      echo "2. = 8G "
      echo "3. < 8G "
      read -p "请输入选项编号： " choice2
      case $choice2 in
      1)
        valid_choice2=true
        vram_choice=1
        ;;
      2)
        valid_choice2=true
        vram_choice=2
        ;;
      3)
        valid_choice2=true
        vram_choice=3
        ;;
      *)
        echo "无效的选项编号，请重新输入。"
        ;;
      esac
    done

  if [ $gpu_choice -eq 1 ]; then  
    WEBUI_DOCKER_NAME=k7212519/stable-diffusion-webui:latest  #rx6800
  elif [ $gpu_choice -eq 2 ]; then  
    WEBUI_DOCKER_NAME=k7212519/stable-diffusion-webui:latest  #rx6700
  elif [ $gpu_choice -eq 3 ]; then  
    WEBUI_DOCKER_NAME=k7212519/stable-diffusion-webui:rx5000  #rx5000
  elif [ $gpu_choice -eq 4 ]; then  
    WEBUI_DOCKER_NAME=k7212519/stable-diffusion-webui:latest  #rxVega
  elif [ $gpu_choice -eq 5 ]; then  
    WEBUI_DOCKER_NAME=k7212519/stable-diffusion-webui:rx500   #rx500
  elif [ $gpu_choice -eq 6 ]; then  
    WEBUI_DOCKER_NAME=k7212519/stable-diffusion-webui:rx7000   #rx7000
  fi

    # Check if the Docker image exists
  if ! docker image inspect $WEBUI_DOCKER_NAME >/dev/null 2>&1; then
    # If the Docker image doesn't exist, prompt the user to choose an action
    echo -e "\n未检测到 $WEBUI_DOCKER_NAME 镜像"
    echo "请选择以下操作："
    echo "1. 从Docker Hub在线拉取"
    echo "2. 从本地tar文件加载"
    read -p "请输入选项数字 [1/2]: " option

    case $option in
      1)  # Pull the Docker image from Docker Hub
        echo "正在从 Docker Hub 拉取 $WEBUI_DOCKER_NAME 镜像，请尽量白天下载，时间较久，请耐心等待..."
        docker pull $WEBUI_DOCKER_NAME
        ;;
      2)
        # Check if the Docker image exists
        if ! docker image inspect $WEBUI_DOCKER_NAME >/dev/null 2>&1; then
          # If the Docker image doesn't exist, prompt the user to choose a tar file from their home directory
          echo -e "\n=================================================================================================)"
          echo "请从您目录中选择要加载的 $WEBUI_DOCKER_NAME 镜像的tar文件(可直接从 文件/其他位置 中的Windows磁盘加载)"
          read -p "拖动文件到这里: " tar_path

          # Get the absolute path of the tar file
          abs_path=$(echo $tar_path | sed "s/^'\(.*\)'$/\1/")
          abs_path=$(eval echo $abs_path)

          # Check if the tar file exists
          if [ ! -f "$abs_path" ]; then
            echo "文件不存在！"
            exit 1
          fi
          # Load the Docker image from the tar file
          echo "正在从 $abs_path 加载 $WEBUI_DOCKER_NAME 镜像，时间较久请耐心等待..."
          docker load -i "$abs_path"
        fi
        ;;
    esac

    if ! docker image inspect $WEBUI_DOCKER_NAME > /dev/null 2>&1; then
      echo -e "\n镜像拉取失败！"
      exit
    else
      echo -e "\nstable-diffusion-webui 镜像拉取成功!"
    fi
    sleep 3s

  else
    echo -e "\n检测到系统已存在 $WEBUI_DOCKER_NAME 镜像，跳过拉取步骤！"
    sleep 3s
  fi

  reset_sd $WEBUI_DOCKER_NAME

  echo -e "\n==============================================================\n"

  echo -e "\n恭喜你，安装完成！请关闭所有窗口后在菜单中启动软件，如有问题可添加QQ群：240336881咨询大家"
  read
  exit
}

onekey_setup() {
  echo -e "\n=====================一键安装============================\n"
  while true; do
    read -p "请确认开始一键安装，y确认，N退出？[y/n] " yn
    case $yn in
      [Yy]* ) break;;  
      [Nn]* ) exit;;  
      * )  echo "请输入 y 或 n.";;
    esac 
  done

  echo -e "\n=================================================================\n" 
  echo -e "\n准备安装显卡驱动...\n" 
  sleep 2s
  
  # 检测 rocm-smi 命令输出
  if rocm-smi | grep -q "Mhz"; then 
    echo -e "\n检测到显卡驱动已经安装，跳过此步骤！" 
    sleep 2s
  else
    /usr/lib/ksd-launcher/data/graphic_setup.sh
  fi 

  # 判断docker是否安装成功
  if [[ $(which docker) && $(docker --version) ]]; then
    echo -e "\n检测到docker已安装，跳过此步骤！"
    sleep 3s
  else
    echo -e "\n未检测到docker，准备安装..."
    /usr/lib/ksd-launcher/data/docker_setup.sh
  fi


  echo -e "\n准备安装stable-diffusion-webui... ..."
  sleep 3s
  setup_sd
} 

# 读取config.ini文件
config_file="/usr/lib/ksd-launcher/data/config.ini"
proxy=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'proxy'))")
address=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'address'))")

# 判断proxy的值
if [[ "$proxy" == "true" ]]; then
  export https_proxy="$address"
fi

onekey_setup
