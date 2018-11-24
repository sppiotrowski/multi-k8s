# build & push docker images to docker.hub
# GIT_SHA=$(git rev-parse HEAD)

dockerhub_repo() {
  local id="$1"
  echo "sppiotrowski/$1"
}

tags() {
  local repo="$1"
  echo "-t $(dockerhub_repo $repo):latest -t $(dockerhub_repo $repo):$GIT_SHA"
}

# docker build -t sppiotrowski/multi-client -t "sppiotrowski/multi-client:$GIT_SHA" -f ./client/Dockerfile ./client
docker_build() {
  local dockerhub_repo="$1"; shift
  local path="$1"
  echo "docker build $(tags $dockerhub_repo) -f ${path}/Dockerfile ${path}"
}


eval "$(docker_build multi-client './client')"
eval "$(docker_build multi-server './server')"
eval "$(docker_build multi-worker './worker')"

# docker push sppiotrowski/multi-client
eval "docker push $(dockerhub_repo multi-client):latest"
eval "docker push $(dockerhub_repo multi-server):latest"
eval "docker push $(dockerhub_repo multi-worker):latest"

eval "docker push $(dockerhub_repo multi-client):$GIT_SHA"
eval "docker push $(dockerhub_repo multi-server):$GIT_SHA"
eval "docker push $(dockerhub_repo multi-worker):$GIT_SHA"

# configure k8s
kubectl apply -f k8s

eval "kubectl set image deployments/client-deployment client=$(dockerhub_repo multi-client)"
eval "kubectl set image deployments/server-deployment server=$(dockerhub_repo multi-server)"
eval "kubectl set image deployments/worker-deployment worker=$(dockerhub_repo multi-worker)"
