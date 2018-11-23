# flow: 
# - setup REPO: github.com, CI: travis-ci.org, CLOUD: cloud.google.com
# - create REPO
# - link REPO to CI
# - create CLOUD k8s CLUSTER
# - link CI to CLOUD

# create REPO
# see: https://github.com
git init
git add .
git c -m Initial commit
git remote -v  # check origin repo
git remote remove origin  # rm origin repo
git remote add origin git@github.com:sppiotrowski/multi-k8s.git
git remote get-url origin # get repo url
git push origin master
git push --set-upstream origin master # allow to use git push

# link CI
# https://travis-ci.org
# sync account & opt-in REPO
# - see: https://travis-ci.org/account/repositories

# setup CLOUD
# see: http://console.cloud.google.com
# - link billing to you project (not needed in trial)
# - craete CLUSTER


# link CI to CLOUD
# create 'service-account' on CLOUD
# - ui:IAM/Service accounts/Create service account
# - with role: Kubernetes Engine Admin
# - with key: type JSON
# - download: <multi-k8s-223207-703e17d78af5>.json as service-account.json file
# encrypt file using travis sdk (travis cmd)
travis encrypt-file service-account.json -r sppiotrowski/multi-k8s
# - remove origin file: service-account.json
# - add encrypted file: service-account.json.enc to REPO
# create .travis.yml
# - add to .travis.yml line with: openssl cmd
# - setup CLOUD sdk (to have gcloud toolbox)
# - see: https://sdk.cloud.google.com
# authorize gcloud with your credentials using: service-account.json
# - setup travis cli
# - encrypt & upload service-account.json to CI

# setup CLOUD console
# - ui: activate cloud shell
# - setup kubectl
kubectl config set project multi-k8s-223207
kubectl config set compute/zone europe-west3-a
kubectl container clusters get-credentias multi-cluster
# add secret for postgres docker image
kubectl create secret generic pgpassword --from-literal PGPASSWORD=
mypgpassword123

# install helm on CLOUD
# - see: https://docs.helm.sh/using_helm/#from-script
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
# setup RBAC
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-role --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# init helm
helm init --service-account tiller --upgrade
