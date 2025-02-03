# На локале
scp admin@130.193.59.123:/home/admin/config ~/.kube/config
kubectl create namespace kubernetes-dashboard

# До сюда сработало. Далее исправь оставшийся код, чтобы он уже работал с локальной машины.

# Создание сервисного аккаунта и роли для доступа к Dashboard
echo_info "Создание сервисного аккаунта и привязка ролей..."
sudo microk8s kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $USER
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $USER
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: $USER
  namespace: kube-system
EOF

# Получение токена для доступа к Dashboard
echo_info "Получение токена для доступа к Dashboard..."
TOKEN=$(sudo microk8s kubectl -n kube-system create token $USER)
echo "$TOKEN" > ~/dashboard-token.txt

echo_info "Настройка завершена."

# Информация для пользователя
echo_info "MicroK8s установлен и настроен."
echo_info "Для подключения к Kubernetes Dashboard выполните следующие шаги:"
echo "1. Скопируйте файл kubeconfig с сервера на локальную машину:"
echo "   scp $USER@$EXTERNAL_IP:~/.kube/config ~/.kube/config"
echo "2. Убедитесь, что на локальной машине установлен kubectl."
echo "3. Используйте токен для доступа к Dashboard:"
echo "   cat ~/dashboard-token.txt"
echo "4. Подключитесь к Dashboard по адресу https://$EXTERNAL_IP:16443."
