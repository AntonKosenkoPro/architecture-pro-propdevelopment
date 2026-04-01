#!/bin/bash

kubectl apply -f ../insecure-manifests/01-privileged-pod.yaml
kubectl apply -f ../insecure-manifests/02-hostpath-pod.yaml
kubectl apply -f ../insecure-manifests/03-root-user-pod.yaml
