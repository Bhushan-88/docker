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
    wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70.tar.gz && \
    tar xzf apache-tomcat-9.0.70.tar.gz && \
    mv apache-tomcat-9.0.70 tomcat && \
    rm apache-tomcat-9.0.70.tar.gz

# ============================================================================
# STAGE 2: Runtime (Production Grade - Slim)
# ============================================================================
FROM ubuntu:22.04

LABEL maintainer="your-email@example.com"

# Hum sirf JRE use karenge (Smaller size)
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jre-headless \
    curl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Environment Variables
ENV CATALINA_HOME=/opt/tomcat \
    PATH=$PATH:/opt/tomcat/bin

# Stage 1 se sirf Tomcat folder copy karo
COPY --from=builder /opt/tomcat /opt/tomcat

# Security: Create and use non-root user
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat && \
    chown -R tomcat:tomcat /opt/tomcat

EXPOSE 8080
WORKDIR /opt/tomcat
USER tomcat

CMD ["catalina.sh", "run"]