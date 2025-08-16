FROM alpine AS build
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
ADD https://github.com/gohugoio/hugo/releases/download/v0.148.2/hugo_0.148.2_linux-amd64.tar.gz /hugo/hugo.tar.gz
RUN echo "b2fbef73c965ff439ccca0bdf15d7ca64f59363d62916326e24d5552e6968aa3  /hugo/hugo.tar.gz" | sha256sum -c
WORKDIR /hugo
RUN tar -zxvf hugo.tar.gz
WORKDIR /website
ADD ./ /website
RUN cp /hugo/hugo /website/hugo
RUN git submodule update --init --recursive
RUN ./hugo build

FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/
COPY --from=build /website/public /usr/share/nginx/html
