#!/bin/bash

valid_choice=false
while [ "$valid_choice" == false ]
    do
      echo "请选择需要启动的虚拟内存大小，需要占用磁盘空间，请确保空间充足(推荐16G或32G)："
      echo "1. 16G"
      echo "2. 32G"
      echo "3. 64G"
      read -p "请输入选项编号： " choice
      case $choice in
      1)
        echo "正在创建16G虚拟内存"
        valid_choice=true
        swap_choice=1
        ;;
      2)
        echo "正在创建32G虚拟内存"
        valid_choice=true
        swap_choice=2
        ;;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
      3)
        echo "正在创建64G虚拟内存"
        valid_choice=true
        swap_choice=3
        ;;
      *)
        echo "无效的选项编号，请重新输入。"
        ;;
      esac
done

sleep 3s
swapon -s
sleep 2s

if [ $swap_choice -eq 1 ]; then  
    sudo fallocate -l 16G /swapfile
elif [ $swap_choice -eq 2 ]; then  
    sudo fallocate -l 32G /swapfile
elif [ $swap_choice -eq 3 ]; then  
    sudo fallocate -l 64G /swapfile
fi


# sudo dd if=/dev/zero of=/swapfile bs=1024 count=2097152
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab
sudo swapon --show
sudo free -h
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/sysctl.conf
echo -e "虚拟swap内存已启用,请在 系统监视器 中查看交换空间容量"
read 