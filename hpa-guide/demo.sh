#!/bin/bash

# Setup kind and metrics-server first...

kubectl apply -f https://k8s.io/examples/application/php-apache.yaml

kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10

kubectl get hpa

# Increase the load
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"


kubectl get hpa php-apache --watch

➜  ~ kubectl get hpa php-apache --watch
NAME         REFERENCE               TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   <unknown>/50%   1         10        0          15s
php-apache   Deployment/php-apache   <unknown>/50%   1         10        1          16s
php-apache   Deployment/php-apache   156%/50%        1         10        1          76s
php-apache   Deployment/php-apache   256%/50%        1         10        4          91s
php-apache   Deployment/php-apache   100%/50%        1         10        6          106s
php-apache   Deployment/php-apache   66%/50%         1         10        6          2m1s

➜  ~ kubectl logs metrics-server-d5589cfb-8z67m -n=kube-system
I1130 13:31:26.896075       1 serving.go:341] Generated self-signed cert (/tmp/apiserver.crt, /tmp/apiserver.key)
I1130 13:31:27.189353       1 requestheader_controller.go:169] Starting RequestHeaderAuthRequestController
I1130 13:31:27.189398       1 shared_informer.go:240] Waiting for caches to sync for RequestHeaderAuthRequestController
I1130 13:31:27.189399       1 configmap_cafile_content.go:202] Starting client-ca::kube-system::extension-apiserver-authentication::client-ca-file
I1130 13:31:27.189431       1 shared_informer.go:240] Waiting for caches to sync for client-ca::kube-system::extension-apiserver-authentication::client-ca-file
I1130 13:31:27.189524       1 configmap_cafile_content.go:202] Starting client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file
I1130 13:31:27.189542       1 shared_informer.go:240] Waiting for caches to sync for client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file
I1130 13:31:27.191161       1 dynamic_serving_content.go:130] Starting serving-cert::/tmp/apiserver.crt::/tmp/apiserver.key
I1130 13:31:27.191574       1 secure_serving.go:197] Serving securely on [::]:443
I1130 13:31:27.191658       1 tlsconfig.go:240] Starting DynamicServingCertificateController
I1130 13:31:27.290360       1 shared_informer.go:247] Caches are synced for client-ca::kube-system::extension-apiserver-authentication::client-ca-file
I1130 13:31:27.290591       1 shared_informer.go:247] Caches are synced for client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file
I1130 13:31:27.290775       1 shared_informer.go:247] Caches are synced for RequestHeaderAuthRequestController
➜  ~


➜  ~ kubectl get deployment php-apache
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
php-apache   0/1     1            0           40s
➜  ~ kubectl get deployment php-apache -w
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
php-apache   0/1     1            0           42s
php-apache   1/1     1            1           45s
php-apache   1/4     1            1           78s
php-apache   1/4     1            1           78s
php-apache   1/4     1            1           78s
php-apache   1/4     4            1           78s
php-apache   2/4     4            2           80s
php-apache   3/4     4            3           80s
php-apache   4/4     4            4           80s
php-apache   4/6     4            4           93s
php-apache   4/6     4            4           93s
php-apache   4/6     4            4           93s
php-apache   4/6     6            4           93s
php-apache   5/6     6            5           95s
php-apache   6/6     6            6           95s
php-apache   6/8     6            6           2m18s
php-apache   6/8     6            6           2m18s
php-apache   6/8     6            6           2m18s
php-apache   6/8     8            6           2m18s





