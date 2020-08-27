FROM alpine AS build
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
ADD ./ /website
WORKDIR /website
ADD https://github.com/gohugoio/hugo/releases/download/v0.74.3/hugo_0.74.3_Linux-64bit.tar.gz hugo.tar.gz
RUN tar -zxvf hugo.tar.gz
RUN git submodule update --init --recursive
RUN ./hugo -v

FROM nginx:stable-alpine
RUN sed -i "s%default_type  application/octet-stream%default_type  text/plain%g" /etc/nginx/nginx.conf
COPY --from=build /website/public /usr/share/nginx/html
