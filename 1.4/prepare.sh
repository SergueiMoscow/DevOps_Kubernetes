#!/bin/bash

# Имя пользователя, под которым выполняется скрипт
USER="admin"
EXTERNAL_IP=$(curl -s ifconfig.me)


# Функция для вывода сообщений
function echo_info {
    echo -e "\e[32m$1\e[0m"
}


echo_info "Ожидание готовности MicroK8s..."
sudo microk8s status --wait-ready

# Включение необходимых модулей
echo_info "Включение Dashboard..."
sudo microk8s enable dashboard

# Генерация конфигурационного файла для kubectl с внешним IP
echo_info "Генерация kubeconfig с внешним IP..."
sudo microk8s config > /tmp/kubeconfig
# Замена localhost на внешний IP
sed -i "s/127.0.0.1/$EXTERNAL_IP/g" /tmp/kubeconfig
sed -i "s/localhost/$EXTERNAL_IP/g" /tmp/kubeconfig

# Сохранение kubeconfig в домашнюю директорию
mkdir -p ~/.kube
cp /tmp/kubeconfig ~/.kube/config
sudo chown -R $USER:$USER ~/.kube

# Добавление внешнего IP в csr.conf.template для сертификатов
echo_info "Добавление внешнего IP в конфигурацию сертификатов..."
sudo sed -i "/#MOREIPS/a IP.3 = $EXTERNAL_IP" /var/snap/microk8s/current/certs/csr.conf.template

# Создание папки для сертификатов
mkdir -p ~/certs
cd ~/certs

# Генерация нового сертификата с внешним IP
echo_info "Генерация сертификатов для Dashboard..."
sudo openssl req -new -newkey rsa:2048 -nodes -keyout dashboard.key -out dashboard.csr -config /var/snap/microk8s/current/certs/csr.conf.template
sudo openssl x509 -req -in dashboard.csr -CA /var/snap/microk8s/current/certs/ca.crt -CAkey /var/snap/microk8s/current/certs/ca.key -CAcreateserial -out dashboard.crt -days 365 -extensions v3_ext -extfile /var/snap/microk8s/current/certs/csr.conf.template

# Копирование сертификатов в папку MicroK8s
# echo_info "Копирование сертификатов в MicroK8s..."
# sudo cp dashboard.crt /var/snap/microk8s/current/certs/
# sudo cp dashboard.key /var/snap/microk8s/current/certs/

# Перезапуск MicroK8s для применения изменений
echo_info "Stopping MicroK8s..."
microk8s stop
echo_info "Starting MicroK8s..."
microk8s start
echo_info "Waiting MicroK8s..."
microk8s status --wait-ready
echo_info "Copying config..."
microk8s config > ~/microk8s.config
sed -i "s|https://[^:]*:16443|https://$EXTERNAL_IP:16443|" ~/microk8s.config

echo_info "Настройка завершена. Файл microk8s.config обновлен с внешним IP: $EXTERNAL_IP"

