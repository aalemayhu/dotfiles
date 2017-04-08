FROM ubuntu

WORKDIR /tmp/config-files
ADD . /tmp/config-files

RUN apt-get update && \
      apt-get install -y sudo git vim make ruby && \
      echo "postfix postfix/mailname string container.alemayhu.com" | debconf-set-selections && \
      echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
      /bin/bash bin/run.bash && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
