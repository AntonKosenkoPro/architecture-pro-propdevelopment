#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Ошибка: Недостаточно данных."
    echo "Использование: $0 <имя_пользователя> <группа>"
    echo "Пример: $0 alice developers"
    exit 1
fi

USER_NAME="$1"
GROUP_NAME="$2"

mkdir -p certs
cd certs

echo "=== Creating user $USER_NAME (group: $GROUP_NAME) ==="

openssl genrsa -out "${USER_NAME}.key" 2048
openssl req -new -key "${USER_NAME}.key" -out "${USER_NAME}.csr" -subj "/CN=${USER_NAME}/O=${GROUP_NAME}"

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${USER_NAME}-csr
spec:
  request: $(cat "${USER_NAME}.csr" | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 31536000
  usages:
  - client auth
EOF

kubectl certificate approve "${USER_NAME}-csr"
kubectl get csr "${USER_NAME}-csr" -o jsonpath='{.status.certificate}' | base64 --decode > "${USER_NAME}.crt"

kubectl config set-credentials "${USER_NAME}" \
  --client-certificate="${USER_NAME}.crt" \
  --client-key="${USER_NAME}.key" \
  --embed-certs=true

cd ..