# Still hits the issue of D-Bus . See EA.CDSandbox for Dockerfiles that have a way around this

FROM local/c7-systemd

MAINTAINER Nishant Patel <nishant.patel@nbcuni.com>

# Install the prereqs to Jenkins
RUN    yum update -y \
	&& yum install -y wget

RUN yum install -y java
RUN    echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | tee -a /etc/profile \
	&& echo 'export JRE_HOME=/usr/lib/jvm/jre' | tee -a /etc/profile \
	&& source /etc/profile

RUN cd ~ \
    && yum whatprovides service \
    && wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo \
    && rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key \ 
    && yum install -y jenkins

RUN yum clean all; systemctl enable jenkins.service

EXPOSE 8080 50000

VOLUME ["/var/lib/jenkins"]

CMD ["/usr/sbin/init"]
# CMD systemctl start jenkins.service