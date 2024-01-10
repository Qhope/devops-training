export TAG=$(git rev-parse -short=10 HEAD | tail -n +2)
sed -i "s/{tag}/$TAG/g"  infra/api/nodejs-app/deployment.yaml

kubectl apply -f infra/api/nodejs-app/deployment.yaml
