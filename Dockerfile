FROM scanf/dotfiles-base-image

LABEL maintainer Alexander Alemayhu

RUN mkdir -pv /tmp/
ADD . /tmp/config-files
WORKDIR /tmp/config-files

RUN make all