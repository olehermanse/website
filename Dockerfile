FROM docker.io/alpine AS build
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
ADD https://github.com/gohugoio/hugo/releases/download/v0.159.2/hugo_0.159.2_linux-amd64.tar.gz /hugo/hugo.tar.gz
RUN echo "0495595d6939425add8fd992f2c20bfa6bfe1181895d821b09f9a06995b60ca8  /hugo/hugo.tar.gz" | sha256sum -c
WORKDIR /hugo
RUN tar -zxvf hugo.tar.gz
WORKDIR /website
ADD ./ /website
RUN cp /hugo/hugo /website/hugo
RUN git submodule update --init --recursive
RUN ./hugo build

FROM docker.io/nginx:stable-alpine
COPY nginx.conf /etc/nginx/
COPY --from=build /website/public /usr/share/nginx/html
