FROM node:6
COPY app.js .
COPY package.json .
RUN npm install
RUN apt-get update && apt-get install -y \
  git \
  subversion
EXPOSE  8081
CMD node app.js
