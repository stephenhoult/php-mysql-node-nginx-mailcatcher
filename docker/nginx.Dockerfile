FROM nginx:1.22-alpine as dev

WORKDIR /app/public

COPY ./docker/nginx.conf /etc/nginx/nginx.conf
COPY ./public/* /app/public/