#!/bin/bash
while true; do
    read -p "y确认更新，N退出？[y/n] " yn
    case $yn in
        [Yy]* ) break;;  
        [Nn]* ) exit;;  
    * )  echo "请输入 y 或 n.";;
    esac 
done

# 读取config.ini文件
config_file="/usr/lib/ksd-launcher/data/config.ini"
proxy=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'proxy'))")
address=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'address'))")

# 判断proxy的值
if [[ "$proxy" == "true" ]]; then
    export https_proxy="$address"
fi

sudo cp -f /usr/lib/ksd-launcher/data/sd.sh /usr/lib/
sudo git -C /usr/lib/ksd-launcher fetch --all
sudo git -C /usr/lib/ksd-launcher reset --hard origin/master
sudo cp -f /usr/lib/sd.sh /usr/lib/ksd-launcher/data/
sudo rm /usr/lib/sd.sh

sudo cp -f /usr/lib/ksd-launcher/data/stable-diffusion.desktop /usr/share/applications/


echo "更新完成，请重启KSD Launcher..."
read