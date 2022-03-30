FROM centos:6
MAINTAINER Nicolas M
CMD ["/bin/bash"]
RUN echo "root:root" | chpasswd
RUN echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
RUN useradd -u 8877 john
USER john
#RUN yum -y upgrade
#RUN yum install epel-release -y
#RUN yum install wget -y

#FROM ubuntu:10.04
# FROM ubuntu:latest
#CMD ["/bin/bash"]
# my latest ubuntu test1
