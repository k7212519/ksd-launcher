#!/bin/bash

while true; do
    echo -e "\n============请选择代理类型============\n"
    echo "1. 已使用clash代理软件"
    echo "2. 已使用Qv2ray代理软件"
    echo "3. 手动设置(局域网)代理地址"
    echo "4. 关闭代理"
    echo "请输入数字选择功能："
    read choice
    case $choice in
      1)

        sed -i "s|^address *=.*$|address = http://127.0.0.1:7890|g" /usr/lib/ksd-launcher/data/config.ini
        sed -i 's/^proxy *= *false$/proxy = true/g' /usr/lib/ksd-launcher/data/config.ini
        echo -e "已使用clash代理webui，代理地址为http://127.0.0.1:7890"
        echo -e "\n重启软件生效"
        read
        ;;
      2)
        sed -i "s|^address *=.*$|address = http://127.0.0.1:10809|g" /usr/lib/ksd-launcher/data/config.ini
        sed -i 's/^proxy *= *false$/proxy = true/g' /usr/lib/ksd-launcher/data/config.ini
        echo -e "已使用Qv2ray代理webui，代理地址为http://127.0.0.1:10809"
        echo -e "\n重启软件生效"
        read
        ;;
      3)
        echo -e "请输入代理地址和端口号,直接回车默认使用上次地址,示例http://127.0.0.1:10809\n"
        read -p " " proxy_address
        if [ ! -z "$proxy_address" ]; then
        sed -i "s|^address *=.*$|address = $proxy_address|g" /usr/lib/ksd-launcher/data/config.ini
        fi
        sed -i 's/^proxy *= *false$/proxy = true/g' /usr/lib/ksd-launcher/data/config.ini
        echo -e "代理已设置"
        echo -e "\n重启软件生效"
        read
        ;;
        
      5)
        # 读取config.ini文件
        config_file="/usr/lib/ksd-launcher/data/config.ini"
        proxy=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'proxy'))")
        address=$(python3 -c "import configparser; config = configparser.ConfigParser(); config.read('$config_file'); print(config.get('SERVER', 'address'))")

        # 判断proxy的值
        if [[ "$proxy" == "true" ]]; then
          echo -e "代理已开启...\n"
          export https_proxy="$address"
        fi

        # 定义要ping的地址
        target="www.google.com"
        echo -e "正在尝试连接www.google.com ...\n"

        # 执行ping命令并检查返回值
        ping -c 1 $target > /dev/null 2>&1

        # 检查ping命令的返回值
        if [ $? -eq 0 ]; then
          echo "google连接测试通过"
        else
          echo "google连接测试未通过,代理未成功，请检查代理地址或更换节点"
        fi
        read
        ;;
      4)
        # 取消代理设置
        sudo sed -i 's/^proxy *= *true$/proxy = false/g' /usr/lib/ksd-launcher/data/config.ini
        echo "代理已移除"
        read
        ;;
      *)
        echo "无效的选择，请重新输入"
        ;;
    esac
  done
