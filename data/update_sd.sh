#!/bin/bash

echo -e "\n不保证更新后还能正常使用！！！如更新后无法使用，请使用一键还原功能"
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

sudo git -C $HOME/dockerx/stable-diffusion-webui fetch --all
sudo git -C $HOME/dockerx/stable-diffusion-webui reset --hard origin/master
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/BLIP fetch --all
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/BLIP reset --hard
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/CodeFormer fetch --all
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/CodeFormer reset --hard
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/k-diffusion fetch --all
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/k-diffusion reset --hard
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/midas fetch --all
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/midas reset --hard
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/stable-diffusion-stability-ai fetch --all
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/stable-diffusion-stability-ai reset --hard
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/taming-transformers fetch --all
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/taming-transformers reset --hard
sudo chmod -R 777 $HOME/dockerx
echo "更新完成"
read
