#!/bin/bash
setup_docker() {

  # 读取config.ini文件
  config_file="/usr/lib/ksd-launcher/data/config.ini"
  proxy=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'proxy'))")
  address=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'address'))")

  # 判断proxy的值
  if [[ "$proxy" == "true" ]]; then
    export https_proxy="$address"
  fi

  echo "准备安装Docker..."
  sudo apt-get update
  sudo apt-get install \
    ca-certificates \
    curl \
    gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  docker version
  #add user/docker to group
  sudo groupadd docker
  echo "user add groupadd"
  sudo gpasswd -a $USER docker
  echo -e "\ndocker 安裝完成，请重启后重新运行本软件，继续选择一键安装！"
  newgrp docker
  
}
setup_docker
echo "回车完成Docker安装"
read