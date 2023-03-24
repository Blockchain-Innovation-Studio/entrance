FROM golang:bullseye

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN apt-get update && apt-get install -y openssh-server vim && \
   apt install -y libpam0g-dev && \
  mkdir /var/run/sshd

RUN \
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN echo "\nSyslogFacility AUTH\nLogLevel DEBUG\nChallengeResponseAuthentication no\nPasswordAuthentication no" >> /etc/ssh/sshd_config

EXPOSE 22

RUN echo "AuthorizedKeysCommand /usr/bin/entrance -deployment=openstory -user=%u\nAuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config

ADD . /app
RUN cd /app && \
  go build -o /usr/bin/entrance .


#CMD ["/usr/sbin/sshd", "-D", "-e"]
CMD ["sleep", "infinity"]
