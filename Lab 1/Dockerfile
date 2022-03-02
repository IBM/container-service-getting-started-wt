FROM node:9.4.0-alpine
COPY package.json .
RUN npm install &&\
    apk update &&\
    apk upgrade
COPY app.js .
EXPOSE  8080
CMD node app.js
