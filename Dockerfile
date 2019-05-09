FROM alpine AS build
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
ADD ./ /website
WORKDIR /website
ADD https://github.com/gohugoio/hugo/releases/download/v0.55.5/hugo_0.55.5_Linux-64bit.tar.gz hugo.tar.gz
RUN tar -zxvf hugo.tar.gz
RUN git submodule update --init --recursive
RUN ./hugo -v

FROM nginx:stable-alpine
COPY --from=build /website/public /usr/share/nginx/html
