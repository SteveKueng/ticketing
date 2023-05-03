FROM ubuntu:18.04

# fix untrusted certificate
ENV NODE_TLS_REJECT_UNAUTHORIZED=0



RUN mkdir -p /app
RUN apt-get update --fix-missing
RUN apt-get install -y nodejs
RUN apt-get install -y dos2unix
RUN apt-get install -y npm
RUN apt-get install -y curl
RUN apt-get install -y --no-install-recommends bsdtar

WORKDIR /usr/bin
# Install entrypoint
COPY entrypoint.sh entrypoint.sh
RUN chmod 777 entrypoint.sh && \
    dos2unix entrypoint.sh 

COPY build.sh build.sh
RUN chmod 777 build.sh && \
    dos2unix build.sh

COPY meteor.sh meteor.sh
RUN chmod 777 meteor.sh && \
    dos2unix meteor.sh

RUN echo "Install meteor ..."
RUN sh meteor.sh

COPY . /app/src

RUN /bin/bash build.sh

EXPOSE 80

CMD ["/usr/bin/entrypoint.sh"]
