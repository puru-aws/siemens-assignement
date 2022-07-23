FROM centos:centos7.5.1804 
RUN yum -y update && \
    yum -y install httpd-tools && \
    yum clean all
#Installing GO lang on centOS
RUN yum -y install wget;\
    wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz;\
    tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz;\
    export PATH=$PATH:/usr/local/go/bin;\
    go version
#Installing g++ on CentOS
RUN yum -y update ;\
    yum -y group install "Development Tools" ;\
    gcc --version
#Copying entrypoint script
ADD ./docker-entrypoint.sh /root/docker-entrypoint.sh
RUN chmod +x /root/docker-entrypoint.sh
ENTRYPOINT ["/root/docker-entrypoint.sh"]
CMD [ "CPP" ]