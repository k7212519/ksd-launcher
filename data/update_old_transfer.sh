#!/bin/bash
echo -e "\n请确认从旧版迁移？过程需要联网更新部分镜像层，并覆盖dockerx文件夹"
echo -e "\n请自行备份dockerx下的sd插件及模型文件！！！"
while true; do
    read -p "y确认更新，N退出？[y/n] " yn
    case $yn in
        [Yy]* ) break;;  
        [Nn]* ) exit;;  
    * )  echo "请输入 y 或 n.";;
    esac 
done

# 检查容器是否存在
if [ "$(docker ps -aqf "name=stable-diffusion")" ]; then
  echo "停止运行 stable-diffusion 中..."
  sleep 3s
  # 停止容器
  docker stop stable-diffusion
  # 检查容器是否已经停止
  if [ "$(docker ps -aqf "name=stable-diffusion" -f "status=exited")" ]; then
    echo "stable-diffusion 容器已经停止"
  else
    # 使用 docker kill 强制停止容器
    docker kill stable-diffusion
    echo "stable-diffusion 容器已被强制停止"
  fi

  echo "容器移除中..."
  # 移除容器
  docker rm stable-diffusion
  sleep 2s
  echo "移除成功"
else
  echo "旧版容器已不存在，跳过移除步骤"
fi

echo -e "\n准备移除旧文件..."
sudo rm -rf $HOME/dockerx
sudo rm -rf /usr/share/stable-diffusion
sudo rm -f $HOME/.local/share/applications/stable-diffusion.desktop
sudo rm /usr/share/icons/sd.png
echo -e "\n已移除"
sleep 2s


#########显卡型号选择##########
gpu_choice=0
valid_choice=false
while [ "$valid_choice" == false ]
do
    echo "请选择您的显卡型号："
    echo "1. 6900 6800 系列"
    echo "2. 6700 6600 6500系列"
    echo "3. 5000 系列"
    echo "4. Vega 系列"
    echo "5. 500 系列"
    read -p "请输入选项编号： " choice
    case $choice in
      1)
        echo "您选择了 rx6900 6800 系列，仅需更新部分镜像层"
        valid_choice=true
        gpu_choice=1
        ;;
      2)
        echo "您选择了 rx6700 6600 系列，仅需更新部分镜像层"
        valid_choice=true
        gpu_choice=2
        ;;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
      3)
        echo "提示：rx5000 系列需要重新下载镜像"
        valid_choice=true
        gpu_choice=3
        docker remove stable-diffusion
        ;;
      4)
        echo "您选择了 rxVega 系列，仅需更新部分镜像层"
        valid_choice=true
        gpu_choice=4
        ;;
      5)
        echo "提示： rx500 系列需要重新下载镜像"
        valid_choice=true
        gpu_choice=5
        docker remove stable-diffusion
        ;;
      *)
        echo "无效的选项编号，请重新输入。"
        ;;
    esac
done

sleep 2s
echo -e "\n准备下载更新..."
sleep 2s

if [ "$gpu_choice" = "3" ]; then
  docker pull k7212519/stable-diffusion-webui:rx5000
elif [ "$gpu_choice" = "5" ]; then
  docker pull k7212519/stable-diffusion-webui:rx500
elif [ "$gpu_choice" = "1" ] || [ "$gpu_choice" = "2" ] || [ "$gpu_choice" = "4" ]; then
  docker pull k7212519/stable-diffusion-webui:latest
else
  echo "无效的选择"
  exit 1
fi

# 检查 docker pull 是否成功
if [ $? -eq 0 ]; then
  echo "镜像更新成功！"
  /usr/lib/ksd-launcher/data/onekey_setup.sh
else
  echo "镜像更新失败！"
  read
fi



  






