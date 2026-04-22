FROM python:3.8-slim
RUN yum -y install java-openjdk
ADD https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz /opt
WORKDIR /opt
RUN tar -xvf apache-tomcat-8.5.83.tar.gz && \
    rm -rvf apache-tomcat-8.5.83.tar.gz
WORKDIR /opt/apache-tomcat-8.5.83
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar /opt/apache-tomcat-8.5.83/lib/
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war /opt/apache-tomcat-8.5.83/webapps/
COPY context.xml /opt/apache-tomcat-8.5.83/conf/
EXPOSE 8080