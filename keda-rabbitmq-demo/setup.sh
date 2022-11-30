#!/bin/bash

# kind
kind create cluster

# keda
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
kubectl create namespace keda
helm install keda kedacore/keda --namespace keda

# rabbitmq
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install rabbitmq --set auth.username=user \
                      --set auth.password=PASSWORD \
                      --set volumePermissions.enabled=true \
                      bitnami/rabbitmq --wait

# wait for rabbitmq to deploy
kubectl get po

# deploy rabbit mq consumer
kubectl apply -f deploy/consumer.yaml

# validate consumer is running
kubectl get deploy

# Publish message to the queue
kubectl apply -f deploy/publisher-job.yaml

# validate scaling
kubectl get deploy -w

kubectl get hpa

##
kubectl delete job rabbitmq-publish
kubectl delete ScaledObject rabbitmq-consumer
kubectl delete deploy rabbitmq-consumer
helm delete rabbitmq