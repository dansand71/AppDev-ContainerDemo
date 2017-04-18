FROM node:boron
# Create app directory
RUN mkdir -p /src/app
WORKDIR /src/app

# Install app dependencies
COPY package.json /src/app/
RUN npm install
RUN npm install applicationinsights

# Bundle app source
COPY . /src/app

EXPOSE 8080
CMD [ "npm", "start" ]