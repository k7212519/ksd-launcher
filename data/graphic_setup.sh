#!/bin/bash
setup_vga_driver() {

  # 读取config.ini文件
  config_file="/usr/lib/ksd-launcher/data/config.ini"
  proxy=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'proxy'))")
  address=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'address'))")

  # 判断proxy的值
  if [[ "$proxy" == "true" ]]; then
    export https_proxy="$address"
    echo -e "已设置代理地址"
    sleep 2s
  fi

  echo "准备安装显卡驱动......"
  UBUNTU_20_URL="https://repo.radeon.com/amdgpu-install/5.5/ubuntu/focal/amdgpu-install_5.5.50500-1_all.deb"
  UBUNTU_22_URL="https://repo.radeon.com/amdgpu-install/5.5/ubuntu/jammy/amdgpu-install_5.5.50500-1_all.deb"
  sudo apt-get update
  echo -e "\n请选择你的系统版本："
  echo "1. Ubuntu 20 focal"
  echo "2. Ubuntu 22 jammy"
  # 获取用户输入
  read choice
  if [[ $choice == "1" ]]; then
    echo -e "正在获取Ubuntu 20 驱动链接...\n" 
    sleep 2s
    wget -N -P $HOME $UBUNTU_20_URL
  elif [[ $choice == "2" ]]; then
    echo -e "正在获取Ubuntu 22 驱动链接...\n" 
    sleep 2s
    wget -N -P $HOME $UBUNTU_22_URL
  else
    echo "无效的选择"
  fi
  echo -e "正在下载并安装显卡驱动(晚上下载慢，白天好一些)...\n" 
  sleep 2s
  sudo apt install $HOME/amdgpu-install_5.5.50500-1_all.deb
  sudo apt-get update
  sudo amdgpu-install --usecase=graphics,rocm,hip --opencl=rocr
  sudo usermod -a -G render $LOGNAME
  sudo usermod -a -G video $LOGNAME
  echo -e "\n=================================================================\n"
  echo "显卡驱动安装完成，请重启电脑后重新运行本软件，再继续选择一键安装！"
} 

setup_vga_driver
echo "回车完成显卡驱动安装"
read
