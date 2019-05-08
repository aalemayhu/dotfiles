FROM ubuntu

ENV MAIL_NAME "postfix postfix/mailname string container.alemayhu.com"
ENV MAIL_TYPE "postfix postfix/main_mailer_type string 'Internet Site'"
ENV DEBIAN_FRONTEND noninteractive

LABEL maintainer Alexander Alemayhu

ADD . /tmp/config-files
WORKDIR /tmp/config-files

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
      apt-get update && \
      apt-get install -y sudo git vim make ruby curl locales && \
      echo $MAIL_NAME | debconf-set-selections && \
      echo $MAIL_TYPE | debconf-set-selections && \
      make all && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /var/tmp/*