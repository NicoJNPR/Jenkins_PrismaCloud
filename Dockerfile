FROM centos:7
MAINTAINER Nicolas M
CMD ["/bin/bash"]
RUN echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
RUN yum install wget -y

#FROM ubuntu:10.04
# FROM ubuntu:latest
#CMD ["/bin/bash"]
# my latest ubuntu test1
