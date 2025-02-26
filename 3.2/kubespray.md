apt install python3.12-venv
git clone --depth=1 https://github.com/kubernetes-sigs/kubespray
cd kubespray
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

- Создаём рабочую директорию из примера:  
`cp -rfp inventory/sample inventory/mycluster`
чтобы sample оставался нетронутым, а в mycluster мы конфигурили наши VMs.

в `group_vars` - настройки для разных компонентов.

k8s-cert-new.sh - для обновления сертификатов.
auto-new-certificate - , есть где-то в конфигах, ставит на выполнение этот скрипт.

Под капотом использует kubeadm


Есть также RKE2.
