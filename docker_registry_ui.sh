#docker run \
#    -p 8080:8080 \
#    -e REG1=http://172.17.0.5:5000/v2/ \
#    atcol/docker-registry-ui


docker run \
  -d \
  -e ENV_DOCKER_REGISTRY_HOST=172.17.0.5 \
  -e ENV_DOCKER_REGISTRY_PORT=5000 \
  -p 8080:80 \
  konradkleine/docker-registry-frontend:v2
