#!/bin/bash
set -e

# 클린업
rm -rf temp_buthor

# GitLab에서 프로젝트 클론
git clone http://localhost:8081/root/buthor.git temp_buthor
cd temp_buthor

# 필요한 경우 파일 수정 등 작업...

cd ..
rm -rf temp_buthor

# 보너스용 ArgoCD 배포
kubectl apply -f ../confs/
