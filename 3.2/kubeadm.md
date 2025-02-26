## Если воникает ошибка при создании кластера, то удаляем недосозданный кластер 

1. Останавливаем все запущенные компоненты Kubernetes:
```bash
sudo systemctl stop kubelet
sudo systemctl stop containerd
```

2. Удаляем все контейнеры, связанные с Kubernetes:
```bash
sudo crictl rm -a -f
```

3. Очищаем директории Kubernetes:
```bash
sudo kubeadm reset --force
sudo rm -rf /etc/kubernetes/
sudo rm -rf /var/lib/etcd/
sudo rm -rf /var/lib/kubelet/
sudo rm -rf $HOME/.kube
```

4. Проверяем, что порты 6443, 10259, 10257, 10250, 2379, 2380 больше не используются:
```bash
sudo at install net-tools # если не установлен
sudo netstat -tuln | grep -E '6443|10259|10257|10250|2379|2380'
```

5. Перезапускаем kubelet и containerd:
```bash
sudo systemctl restart containerd
sudo systemctl restart kubelet
```

6. Убеждаемся, что на узле отключен swap:

```bash
sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a
```
7. Повторяем инициализацию кластера с параметром --v=5 для лучшей диагностики в случае неудачи:
```bash
sudo kubeadm init \
    --apiserver-advertise-address=10.130.0.19 \
    --pod-network-cidr 10.244.0.0/16 \
    --apiserver-cert-extra-sans=158.160.144.244 \
    --v=5
```