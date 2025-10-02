#!/bin/bash

pkill -f 'kubectl port-forward'
helm uninstall gitlab -n gitlab || true
sleep 30
kubectl delete namespace gitlab || true
rm -rf temp_buthor