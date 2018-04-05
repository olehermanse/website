FROM  webdevops/nginx
ENV WEB_DOCUMENT_INDEX index.html
ADD ./public /app
