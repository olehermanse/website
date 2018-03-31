FROM  webdevops/nginx:ubuntu-16.04
ENV WEB_DOCUMENT_INDEX index.html
ADD ./ /website
WORKDIR /website
RUN apt-get update -y
RUN apt-get install -y git curl
RUN curl --silent -L https://github.com/gohugoio/hugo/releases/download/v0.37.1/hugo_0.37.1_Linux-64bit.deb -o hugo.deb
RUN dpkg -i hugo.deb
RUN git submodule update --init --recursive
RUN mkdir -p content
RUN hugo -v
RUN cp -r ./public /app
