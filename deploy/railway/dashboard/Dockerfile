FROM nginx:alpine

RUN mkdir -p /etc/nginx/templates /usr/share/nginx/html

COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY dpp-test-dashboard.html /usr/share/nginx/html/dpp-test-dashboard.html
COPY dpp-test-dashboard.html /usr/share/nginx/html/index.html
COPY samples /usr/share/nginx/html/samples

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

CMD ["/docker-entrypoint.sh"]
