FROM alpine AS build
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
ADD ./ /website
WORKDIR /website
ADD https://github.com/gohugoio/hugo/releases/download/v0.133.0/hugo_0.133.0_Linux-64bit.tar.gz hugo.tar.gz
RUN echo "051add83c505941e129b4c33654dc6a0700fe71f74e7d8c2532c8bb394bb9583  hugo.tar.gz" | sha256sum -c
RUN tar -zxvf hugo.tar.gz
RUN git submodule update --init --recursive
RUN ./hugo -v

FROM nginx:stable-alpine
RUN sed -i "s%default_type  application/octet-stream%default_type  text/plain%g" /etc/nginx/nginx.conf
COPY --from=build /website/public /usr/share/nginx/html
