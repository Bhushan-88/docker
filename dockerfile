# ============================================================================
# STAGE 1: Builder (Heavy lifting)
# ============================================================================
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and Extract Tomcat
RUN cd /opt && \
    wget -q https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.117/bin/apache-tomcat-9.0.117.tar.gz && \
    tar xzf apache-tomcat-9.0.117.tar.gz && \
    mv apache-tomcat-9.0.117 tomcat && \
    rm apache-tomcat-9.0.117.tar.gz

# Download  student.war and place it in the webapps directory
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war /opt/tomcat/webapps/student.war

# Download MySQL Connector and place it in the lib directory
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar /opt/tomcat/lib/mysql-connector.jar

# Copy configuration files (if any)
COPY context.xml /opt/tomcat/conf/context.xml


# ============================================================================
# STAGE 2: Runtime (Production Grade - Slim)
# ============================================================================
FROM ubuntu:22.04

LABEL maintainer="bhushandugawli1@gmail.com"

# Install OpenJDK and clean up apt cache to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jre-headless \
    curl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Environment Variables
ENV CATALINA_HOME=/opt/tomcat \
    PATH=$PATH:/opt/tomcat/bin

# Copy Tomcat and the application from the builder stage 1
COPY --from=builder /opt/tomcat /opt/tomcat

# Security: Create and use non-root user
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat && \
    chown -R tomcat:tomcat /opt/tomcat

EXPOSE 8080
WORKDIR /opt/tomcat
USER tomcat

CMD ["catalina.sh", "run"]