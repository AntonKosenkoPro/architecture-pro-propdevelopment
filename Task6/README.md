Копируем конфиг
```shell
mkdir -p ~/.minikube/files/etc/ssl/certs
cp audit-policy.yaml ~/.minikube/files/etc/ssl/certs
```

Стартуем minikube
```shell
minikube start \
  --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml \
  --extra-config=apiserver.audit-log-path=-
```

Симулируем инцидент
```shell
chmod +x ./simulate-incident.sh
./simulate-incident.sh 
```

Копируем лог из кластера
```shell
kubectl logs kube-apiserver-minikube -n kube-system | grep audit.k8s.io/v1 > audit.log
```

Фильтруем лог
```shell
chmod +x filter-log.sh
./filter-log.sh
```

Прибираемся за собой
```shell
minikube delete
```