#!/bin/bash

kubectl get deploy,svc -n kube-system | egrep metrics-server

kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"|jq