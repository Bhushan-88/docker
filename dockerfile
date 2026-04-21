FROM centos:7
RUN yum -y install java-openjdk && \
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.117/bin/apache-tomcat-9.0.117.tar.gz /opt/
WORKDIR /opt
RUN tar -xvf apache-tomcat-9.0.117.tar.gz && \
    rm -rvf apache-tomcat-9.0.117.tar.gz
WORKDIR /opt/apache-tomcat-9.0.117
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar /opt/apache-tomcat-9.0.117/lib/
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war /opt/apache-tomcat-9.0.117/webapps/
COPY context.xml /opt/apache-tomcat-9.0.117/conf/
EXPOSE 8080