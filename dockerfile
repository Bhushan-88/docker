# ============================================================================
# Dockerfile: Ubuntu 22.04 + Tomcat 9
# Good for: Development, Learning, Moderate production
# Size: ~150-180MB
# ============================================================================

FROM ubuntu:22.04

LABEL maintainer="your-email@example.com" \
      description="Ubuntu 22.04 with Tomcat 9" \
      version="1.0"

# Set timezone and environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_BASE=/opt/tomcat \
    PATH=$PATH:/opt/tomcat/bin

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        ca-certificates \
        openjdk-11-jdk-headless \
        net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create tomcat user
RUN groupadd -r tomcat && \
    useradd -r -g tomcat tomcat

# Download and setup Tomcat 9
RUN cd /opt && \
    wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70.tar.gz && \
    tar xzf apache-tomcat-9.0.70.tar.gz && \
    mv apache-tomcat-9.0.70 tomcat && \
    rm apache-tomcat-9.0.70.tar.gz && \
    chown -R tomcat:tomcat /opt/tomcat && \
    chmod +x /opt/tomcat/bin/catalina.sh

EXPOSE 8080

WORKDIR /opt/tomcat

USER tomcat

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

CMD ["catalina.sh", "run"]