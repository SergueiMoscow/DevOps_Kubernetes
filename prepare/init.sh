#!/bin/bash

# Имя пользователя, под которым выполняется скрипт
USER="admin"
EXTERNAL_IP=$(curl -s ifconfig.me)

# Функция для вывода сообщений
function echo_info {
    echo -e "\e[32m$1\e[0m"
}

# Обновление системы
echo_info "Обновление системы..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Установка MicroK8s
echo_info "Установка MicroK8s..."
sudo snap install microk8s --classic --channel=1.32
sudo usermod -a -G microk8s $USER

# Применение группы
newgrp microk8s