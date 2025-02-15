Подставить в export назначенный IP созданному серверу.
```
# Копируем скрипты на сервер
export IP=<IP>
scp ../prepare/init.sh admin@$IP:~/
scp ../prepare/prepare.sh admin@$IP:~/
# После запуска скриптов на сервере копируем конфиг
scp admin@$IP:~/microk8s.config ~/.kube/config
```
