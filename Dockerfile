FROM nginx:1.12
#FROM nginx:latest
MAINTAINER Nicolas
RUN useradd -u 8877 nicolas
RUN echo "nicolas:nicolas" | chpasswd




#CMD ["/bin/bash"] 
#RUN echo "root:root" | chpasswd
#RUN useradd -u 8877 nicolas
#USER nicolas

#FROM centos:6
#FROM ubuntu:10.04 
# FROM ubuntu:latest
#RUN echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
#CMD ["/bin/bash"]

