## Task5

Стартуем minikube с плагинами (чтобы работали сетевые политики)
```shell
minikube start --network-plugin=cni --cni=calico
```

Создаём поды
```shell
kubectl run front-end-app --image=nginx --labels role=front-end --expose --port 80
kubectl run back-end-api-app --image=nginx --labels role=back-end-api --expose --port 80
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end --expose --port 80
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --expose --port 80
```

Смотрим поды
```shell
kubectl get pods,svc --show-labels
```

Применяем политику
```shell
kubectl apply -f non-admin-api-allow.yaml
```

Проверяем левый траффик
```shell
kubectl run test-$RANDOM --rm -i -t --image=alpine -- sh
wget -qO- --timeout=2 http://back-end-api-app
exit 
```

Проверяем доступ frontend -> backend
```shell
kubectl exec -it front-end-app -- curl -s --connect-timeout 2 http://back-end-api-app
```

Проверяем доступ backend -> frontend
```shell
kubectl exec -it back-end-api-app -- curl -s --connect-timeout 2 http://front-end-app
```

Проверяем доступ admin-frontend -> admin-backend
```shell
kubectl exec -it admin-front-end-app -- curl -s --connect-timeout 2 http://admin-back-end-api-app
```

Проверяем доступ admin-backend -> admin-frontend
```shell
kubectl exec -it admin-back-end-api-app -- curl -s --connect-timeout 2 http://admin-front-end-app
```

Проверяем перекрёстный доступ frontend -> admin-backend (не должен работать)
```shell
kubectl exec -it front-end-app -- curl -s --connect-timeout 2 http://admin-back-end-api-app
```

Удаляем кластер
```shell
minikube delete
```