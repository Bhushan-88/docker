FROM centos:7
RUN yum install java-1.8.0-openjdk -y 
ADD https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz /opt
WORKDIR /opt
RUN tar -xzf apache-tomcat-8.5.83.tar.gz -C /opt && \
    rm -f /opt/apache-tomcat-8.5.83.tar.gz
WORKDIR /opt/apache-tomcat-8.5.83
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar /opt/apache-tomcat-8.5.83/lib/
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war /opt/apache-tomcat-8.5.83/webapps/
COPY context.xml /opt/apache-tomcat-8.5.83/conf/
EXPOSE 8080
CMD [ "./bin/catalina.sh", "run" ]