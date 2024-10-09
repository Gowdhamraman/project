#Node Install
FROM node:alpine

WORKDIR /build
RUN npm install

COPY . .

RUN npm run build


# Nginx  install
FROM nginx:latest


COPY build/ /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
