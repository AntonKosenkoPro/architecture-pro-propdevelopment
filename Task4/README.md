## Task 4

Стартуем кластер
```shell
minikube start
```

Проверяем RBAC
```shell
 kubectl api-versions | grep rbac      
```

Создаём пользователей
```shell
chmod +x ./create_user.sh
./create_user.sh alice developers
./create_user.sh bob devops
./create_user.sh walter security
```

Создаём роли и привязываем их
```shell
kubectl apply -f roles.yaml -f roles_bindings.yaml
```

Проверяем alice
```shell
kubectl config set-context alice-context --cluster=minikube --namespace=default --user=alice
kubectl config use-context alice-context

kubectl auth can-i list pods
kubectl auth can-i create pods
kubectl auth can-i get secrets
```

Проверяем bob
```shell
kubectl config set-context bob-context --cluster=minikube --namespace=default --user=bob
kubectl config use-context bob-context

kubectl auth can-i list pods
kubectl auth can-i create pods
kubectl auth can-i get secrets
```

Проверяем walter
```shell
kubectl config set-context walter-context --cluster=minikube --namespace=default --user=walter
kubectl config use-context walter-context

kubectl auth can-i list pods
kubectl auth can-i create pods
kubectl auth can-i get secrets
```

Прибираемся за собой
```shell
kubectl config use-context minikube

kubectl delete clusterrolebinding developers-view-binding
kubectl delete clusterrolebinding devops-edit-binding
kubectl delete clusterrolebinding security-admin-binding

kubectl delete clusterrole cluster-viewer
kubectl delete clusterrole cluster-editor
kubectl delete clusterrole security-admin

kubectl config delete-user alice
kubectl config delete-user bob
kubectl config delete-user walter

kubectl config delete-context alice-context
kubectl config delete-context bob-context
kubectl config delete-context walter-context

rm -rf certs/
```

Опционально удаляем кластер
```shell
minikube delete
```