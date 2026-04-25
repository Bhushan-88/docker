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
docker top <con id > #for con proccess

# Docker Images
docker images
docker pull <image name> #it pull image from docker hub
docker commit bb544c11c2f1 # create image from container 
docker tag <image id> demo:1.0.0 # set image name using tag 
ex:docker tag a3d6962014f5 username/repo:tag 
docker tag a3d6962014f5 bhushandurgawli/demo:1.0.0 #
docker push bhushandurgawli/ubuntu:22.04-tomcat-studentapp # Docker Hub
docker login # to login container resistry 
docker push bhushandurgawli/demo:1.0.0 # push image to resistry
docker save -o nginx.tar <img id > # save image at local system //OR archive 
docker image rm `docker images -Q` # remove all unused images
docker load -i nginx.tar # extract image from archive file
docker create nginx # create not running containter , after create start 

## Docker Network 
Networking: By default, containers are isolated. If you have a Web App container and a Database container, you have to put them on the same Docker Network so the app can save data to the DB.

docker network ls
docker run -d --network host nginx # run containe on host 
docker inspect 40b4ac712fc07c5 | grep Network
docker network create my-net --driver=bridge --subnet="192.168.0.0/16" #create netwrk with subnet 
docker inspect b06795f720c7 # network id 
docker run -d --network my-net nginx 
docker inspect 744ac80e25b5 |grep IP # img id

192.168.0.2 nginx 
172.17.0.2 http

## Docker Volume 
Volumes: Containers are ephemeral (temporary). If you save a file inside a container and then delete that container, the file is gone forever. Volumes "plug in" to the container so that even if the container dies, your database files or logs stay safe on the host machine.
docker volume ls ORR// docker volume list
docker volume create my-vol
docker volume run -d -v my-vol:/usr/share/nginx/html nginx
```

## What is a Dockerfile?
A text file with a series of commands that Docker reads sequentially to
build an image — a lightweight, standalone, executable package containing
your application, runtime, libraries, and dependencies.

#Each instruction in a Dockerfile creates a layer — a thin filesystem snapshot.
FROM ubuntu:22.04          # Layer 1
RUN apt-get install curl   # Layer 2 (built on Layer 1)
COPY app.py .              # Layer 3 (built on Layer 2)
RUN python app.py          # Layer 4 (built on Layer 3)

## with dockerfile 
```bash
docker build -t ubuntu:22.04-tomcat-studentapp .
docker run -d -p 80:8080 2e977cf7653<img id>

## Create database and DB User with user.
Create DB with name studentapp and ceate Table
create database studentapp;
use studentapp;
CREATE TABLE if not exists students(student_id INT NOT NULL AUTO_INCREMENT,
	student_name VARCHAR(100) NOT NULL,
    student_addr VARCHAR(100) NOT NULL,
	student_age VARCHAR(3) NOT NULL,
	student_qual VARCHAR(20) NOT NULL,
	student_percent VARCHAR(10) NOT NULL,
	student_year_passed VARCHAR(10) NOT NULL,
	PRIMARY KEY (student_id)
);

## User

MariaDB [(none)]> create user admin identified by  '12345';
Query OK, 0 rows affected (0.137 sec)

MariaDB [(none)]> grant all privileges on *.* to admin ;
Query OK, 0 rows affected (0.044 sec)

MariaDB [(none)]> flush privileges; 
Query OK, 0 rows affected (0.063 sec)
```
--------------------------------------------------------------------------------------------
EX:-
## Specific base image version
FROM python:3.9-slim

# Minimize layers — combine RUN commands
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first (for layer caching)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy code last (changes frequently)
COPY . .

EXPOSE 8000
CMD ["python", "app.py"]

------------------------------------------------------------------------------------------------

```bash
docker rm -f $(docker ps -aq) #docker ps -aq → all container IDs , -f → force stop + remove
docker rmi -f $(docker images -aq) #docker images -aq → all image IDs , -f → force delete
docker system prune -a -f #Removes:stopped containers, unused images, unused networks
build cache