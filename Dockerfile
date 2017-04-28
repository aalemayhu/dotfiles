FROM ubuntu

ENV MAIL_NAME "postfix postfix/mailname string container.alemayhu.com"
ENV MAIL_TYPE "postfix postfix/main_mailer_type string 'Internet Site'"

LABEL maintainer Alexander Alemayhu

ADD . /tmp/config-files
WORKDIR /tmp/config-files
ADD . /tmp/config-files

RUN apt-get update && \
      apt-get install -y sudo git vim make ruby && \
      echo $MAIL_NAME | debconf-set-selections && \
      echo $MAIL_TYPE | debconf-set-selections && \
      /bin/bash bin/run.bash && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
