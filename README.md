# docker
Docker is a tool used to package applications into portable, isolated containers, while Kubernetes is an orchestration platform used to manage and scale those containers across a cluster of servers.

1.Container is a runable entity of the docker container image.
2.To run container, at least a single service/proccess should be running inside a container.
3.Containers are not editable 
4.Once the container is terminated, you can not retrive the container.
### Docker commands 
```bash 
docker run <image> # run container in atttached way 
docker run -d <image> # dettached way us -d
docker pa -a # list all container 
docker inspect <container id>
docker run -d -p 8080:80 <image name>
docker run -d -P <image name> # random port
dockker stop <con id>
docker rm <con id>
docker rm -f <con id>
docker kill <con id>
docker kill `docker ps -q` # kill all containers
docker exec -it bf7963d57ec2dc bash # to exicute any command inside the container 
docker run -d -p 8080:80 --name my-container nginx # run  with  name 
docker logs b5e7e57e7ae2 # logs of container
docker cp index.html 91138aabaaf1c:/usr/share/nginx/html/index.html # copy file inside the container 
docker cp 91138aabaaf1c:/usr/share/nginx/html/index.html ./ # copy from container
docker top <con id > #con proccess

# 
docker images
docker pull <image name> #it pull image from docker hub
docker commit bb544c11c2f1 # create image from container 




