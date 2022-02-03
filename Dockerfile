FROM nginx:latest

WORKDIR ./tmp

RUN rm -rf /usr/share/nginx/html/*
COPY ./index.html /usr/share/nginx/html/index.html

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
