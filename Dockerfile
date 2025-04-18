FROM alpine AS build
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
ADD ./ /website
WORKDIR /website
ADD https://github.com/gohugoio/hugo/releases/download/v0.146.5/hugo_0.146.5_linux-amd64.tar.gz hugo.tar.gz
RUN echo "d45e0993ae34d28f505cba3ed40db68a3bf0e05301bdec0fa278f56320ef7115  hugo.tar.gz" | sha256sum -c
RUN tar -zxvf hugo.tar.gz
RUN git submodule update --init --recursive
RUN ./hugo build

FROM nginx:stable-alpine
RUN sed -i "s%default_type  application/octet-stream%default_type  text/plain%g" /etc/nginx/nginx.conf
COPY --from=build /website/public /usr/share/nginx/html
