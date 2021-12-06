#!/bin/bash

# Assumes you have k8s/helm

# Will uninstall JupyterHub in the jupyterhub namespace
helm uninstall jupyterhub \
  --namespace jupyterhub 

# Removes -everything-
kubectl delete namespace jupyterhub
