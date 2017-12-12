FROM registry.ng.bluemix.net/ibmnode
COPY app.js .
COPY package.json .
RUN npm install
EXPOSE  8080
CMD node app.js
