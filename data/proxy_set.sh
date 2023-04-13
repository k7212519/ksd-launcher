#!/bin/bash

while true; do
    echo -e "\n============代理设置============\n"
    echo "1. 设置代理地址"
    echo "2. 清除代理"
    echo "请输入数字选择功能："
    read choice
    case $choice in
      1)
        echo -e "请输入代理地址和端口号,直接回车默认使用上次地址,示例http://127.0.0.1:10809\n"
        read -p ":" proxy_address
        if [ ! -z "$proxy_address" ]; then
        sed -i "s|^address *=.*$|address = $proxy_address|g" /usr/lib/ksd-launcher/data/config.ini
        fi
        sed -i 's/^proxy *= *false$/proxy = true/g' /usr/lib/ksd-launcher/data/config.ini
        echo -e "代理已设置，重启软件生效！"
        read
        ;;
      2)
        # 取消代理设置
        sudo sed -i 's/^proxy *= *true$/proxy = false/g' /usr/lib/ksd-launcher/data/config.ini
        echo "代理已移除，重启软件生效！"
        read
        ;;
      *)
        echo "无效的选择，请重新输入"
        ;;
    esac
  done