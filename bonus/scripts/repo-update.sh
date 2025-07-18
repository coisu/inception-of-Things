#!/bin/bash
set -e

# GitLab 비밀번호 가져오기
GITLAB_PASS=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)

# GitLab 인증파일 설정
cat <<EOF > ~/.netrc
machine gitlab.k3d.gitlab.com
login root
password $GITLAB_PASS
EOF

chmod 600 ~/.netrc

# GitHub에서 클론
git clone https://github.com/SavchenkoDV/buthor.git temp_buthor
cd temp_buthor

# GitLab repo 등록 및 푸시
git remote set-url origin http://gitlab.k3d.gitlab.com/root/buthor.git
git push --mirror

cd ..
rm -rf temp_buthor

# ArgoCD 배포 적용
kubectl apply -f deploy.yaml
