FROM ubuntu:18.04

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install wget apt-transport-https ca-certificates gnupg 

RUN wget -O - https://repo.jotta.us/public.gpg | apt-key add -
RUN echo "deb https://repo.jotta.us/debian debian main" | tee /etc/apt/sources.list.d/jotta-cli.list
RUN apt-get update && apt-get install -y jotta-cli expect

VOLUME ["/config"]
VOLUME ["/backup"]
EXPOSE 14443

#ADD ./jottad/ /usr/local/jottad
#RUN chmod +x /usr/local/jottad/* /etc/init.d/jottad

#set environment 
ENV JOTTA_TOKEN=**None** \
    JOTTA_DEVICE=**None** \
    JOTTA_SCANINTERVAL=1h\
    LOCALTIME=/usr/share/zoneinfo/Europe/Amsterdam

    #PUID=101 \
    #PGID=101 \

RUN mkdir /jottahome
ADD entrypoint.sh /jottahome

# setup container and start service
ENTRYPOINT ["/jottahome/entrypoint.sh"]
