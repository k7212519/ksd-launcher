#!/bin/bash
while true; do
    read -p "y确认从官方仓库 https://github.com/AUTOMATIC1111/stable-diffusion-webui 回退旧版本，N退出？[y/n] " yn
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
    echo -e "通过代理地址更新...\n"
    export https_proxy="$address"
else 
    export https_proxy=http://379365m33j.qicp.vip:7213
fi

##########版本选择##########
  valid_choice=false
  version_hash=""
  while [ "$valid_choice" == false ]
    do
      echo "请选择回退的版本："
      echo "1. 2023年3月26日 hash:64da5c4"
      echo "2. 2023年3月20日 hash:64fc936"
      echo "3. 2023年2月28日 hash:3c64591"
      echo "4. 2023年2月05日 hash:47b298d"
      echo "5. 2023年1月24日 hash:3c47b05"
      echo "6. 自定义版本"
      read -p "请输入选项编号： " choice
      case $choice in
      1)
        echo "2023年3月26日 hash:64da5c4"
        valid_choice=true
        version_hash="64da5c4"
        ;;
      2)
        echo "2023年3月20日 hash:64fc936"
        valid_choice=true
        version_hash="64fc936"
        ;;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
      3)
        echo "2023年2月28日 hash:3c64591"
        valid_choice=true
        version_hash="3c64591"
        ;;
      4)
        echo "2023年2月05日 hash:47b298d"
        valid_choice=true
        version_hash="47b298d"
        ;;
      5)
        echo "2023年1月24日 hash:3c47b05"
        valid_choice=true
        version_hash="3c47b05"
        ;;
      6)
        valid_choice=true
        read -p "请输入需要回退的版本hash: " hash_value
        version_hash=$hash_value
        ;;
      *)
        echo "无效的选项编号，请重新输入。"
        ;;
      esac
    done


# docker restart stable-diffusion

sudo git -C $HOME/dockerx/stable-diffusion-webui reset --hard $version_hash
echo -e "回退成功，正在初始化，请耐心等待，完成后请在网页底部查看commit-hash..."
sudo git -C $HOME/dockerx/stable-diffusion-webui reset --hard

sudo rm -rf $HOME/dockerx/stable-diffusion-webui/repositories/stable-diffusion-stability-ai

# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/BLIP reset --hard origin/master
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/CodeFormer reset --hard origin/master
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/k-diffusion reset --hard origin/master
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/stable-diffusion-stability-ai reset --hard origin/master
# sudo git -C $HOME/dockerx/stable-diffusion-webui/repositories/taming-transformers reset --hard origin/master



# 读取文件并用 sed 编辑
# sed -i.bak '/git_clone(stable_diffusion_repo, repo_dir('"'"'stable-diffusion-stability-ai'"'"'), "Stable Diffusion", stable_diffusion_commit_hash)/s/^/#/' $HOME/dockerx/stable-diffusion-webui/launch.py
# sed -i.bak '/git_clone(taming_transformers_repo, repo_dir('"'"'taming-transformers'"'"'), "Taming Transformers", taming_transformers_commit_hash)/s/^/#/' $HOME/dockerx/stable-diffusion-webui/launch.py
# sed -i.bak '/git_clone(k_diffusion_repo, repo_dir('"'"'k-diffusion'"'"'), "K-diffusion", k_diffusion_commit_hash)/s/^/#/' $HOME/dockerx/stable-diffusion-webui/launch.py
# sed -i.bak '/git_clone(codeformer_repo, repo_dir('"'"'CodeFormer'"'"'), "CodeFormer", codeformer_commit_hash)/s/^/#/' $HOME/dockerx/stable-diffusion-webui/launch.py
# sed -i.bak '/git_clone(blip_repo, repo_dir('"'"'BLIP'"'"'), "BLIP", blip_commit_hash)/s/^/#/' $HOME/dockerx/stable-diffusion-webui/launch.py

# commands=$(grep "^docker exec.*$" /usr/lib/ksd-launcher/data/sd.sh | sed ':a;N;$!ba;s/\n/ /g')

docker restart stable-diffusion
# eval "$commands"
docker exec -it stable-diffusion bash -c "cd /dockerx/stable-diffusion-webui && source venv/bin/activate && pip install --upgrade fastapi==0.90.1 && echo '降级完成，首次打开需要下载部分组件，请确保使用代理！' && read "
read