#!/bin/bash
config_file="/usr/lib/ksd-launcher/data/config.ini"
proxy=$(python3 -c "import configparser; config=configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'proxy'))")
address=$(python3 -c "import configparser; config=configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'address'))")

if [[ $proxy != "true" ]]; then
    proxy_command=""
else
    proxy_command="export https_proxy=$address && echo '通过代理打开stable-diffusion-webui' && "
fi



docker ps
docker restart stable-diffusion

# 运行参数加在下方命令最后的 " 前，记得 --参数 前加个空格



docker exec -it stable-diffusion bash -c "cd /dockerx/stable-diffusion-webui && source venv/bin/activate && $proxy_command python3 launch.py --disable-safe-unpickle "
