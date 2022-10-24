FROM node:16.14.2-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh python3 make

WORKDIR /usr/src/app
COPY package.json ./
RUN npm install --force
COPY . .
EXPOSE 8080
CMD ["npm","run","start"]
