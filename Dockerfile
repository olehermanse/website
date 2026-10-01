FROM docker.io/alpine AS build
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
ADD https://github.com/gohugoio/hugo/releases/download/v0.167.0/hugo_0.167.0_linux-amd64.tar.gz /hugo/hugo.tar.gz
RUN echo "4d84519b9f619e6d4c3fb45a50157abeabeb724f859c60605f44c23def6e1169  /hugo/hugo.tar.gz" | sha256sum -c
WORKDIR /hugo
RUN tar -zxvf hugo.tar.gz
WORKDIR /website
ADD ./ /website
RUN cp /hugo/hugo /website/hugo
RUN git submodule update --init --recursive
RUN ./hugo build

FROM docker.io/nginx:1.28.3-alpine3.23@sha256:a8b39bd9cf0f83869a2162827a0caf6137ddf759d50a171451b335cecc87d236
COPY nginx.conf /etc/nginx/
COPY --from=build /website/public /usr/share/nginx/html
