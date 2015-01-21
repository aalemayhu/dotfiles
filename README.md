Some configuration files I use for my machines, which mostly run [Debian](https://debian.org).

Oneliner for myself(requires sudo):

    wget -qO- https://raw.githubusercontent.com/scanf/config-files/master/config-files.bash | bash


/etc/apt/sources.list:

    deb http://ftp.no.debian.org/debian/ experimental main contrib non-free
    deb http://ftp.no.debian.org/debian/ unstable main contrib non-free
    deb-src http://ftp.no.debian.org/debian/ unstable main contrib non-free
    deb http://repository.spotify.com stable non-free
