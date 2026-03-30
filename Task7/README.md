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

Ставим gatekeeper
```shell
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.15/deploy/gatekeeper.yaml
kubectl get pods -n gatekeeper-system
```

Создаём namespace
```shell
kubectl apply -f 01-create-namespace.yaml
```

Проверяем, что добавлениие небезопасных подов отклоняется
```shell
cd verify && ./verify-admission.sh
```

Проверяем, что безопасные поды добавляются
```shell
cd verify && ./validate-security.sh
```

Тут вопрос к ревьюеру и\или составителю задания - а зачем нам дальше конфигурировать gatekeeper, если и без него всё прекрасно?
Ну ладно, пойдём настраивать...

Применяем templates
```shell
kubectl apply -f gatekeeper/constraint-templates/
```

Добавляем constraints
```shell
kubectl apply -f gatekeeper/constraints/
```

Прибираемся за собой
```shell
minikube delete
```
