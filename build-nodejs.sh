export TAG=$(git rev-parse -short=10 HEAD | tail -n +2)

docker build nodejs/. -t devops-training-nodejs-dev:latest --build-arg BUILD_ENV=dev -f nodejs/Dockerfile
docker tag devops-training-nodejs-dev:latest quanghop/devops-training:$TAG
docker push quanghop/devops-training:$TAG
docker rmi -f quanghop/devops-training:$TAG
