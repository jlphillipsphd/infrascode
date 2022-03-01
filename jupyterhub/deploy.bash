#!/bin/bash

# Assumes you have k8s/helm

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

# Will deploy JupyterHub in the jupyterhub namespace
helm upgrade --cleanup-on-fail \
  --install jupyterhub jupyterhub/jupyterhub \
  --namespace jupyterhub \
  --create-namespace \
  --version=1.2.0 \
  --timeout=60m \
  --values config.yaml

# Once you are finished, check the services...
#
# $ kubectl -n jupyterhub get svc
#
# NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
# proxy-public   ClusterIP   10.43.208.141   <none>        80/TCP     43s
# hub            ClusterIP   10.43.44.205    <none>        8081/TCP   43s
# proxy-api      ClusterIP   10.43.33.200    <none>        8001/TCP   43s
#
# $ kubectl -n jupyterhub port-forward svc/proxy-public 9000:80
#
# Use port 443 instead of 80 once you have SSL certs installed...
# Of course, a load balancer or reverse-proxy would be needed to
# complete the loop here and make the deployment visible on the net...
