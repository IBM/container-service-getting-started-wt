FROM node:6
COPY app.js .
COPY package.json .
RUN npm install
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade &&\
  apt-get clean &&\
  rm -Rf /var/cache/*
EXPOSE  8080
CMD node app.js
