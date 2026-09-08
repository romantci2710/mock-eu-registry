#!/bin/sh
PORT=${PORT:-80}
RESOLVER=$(awk '$1=="nameserver" {print $2; exit}' /etc/resolv.conf)
if [ -z "$RESOLVER" ]; then
    RESOLVER="127.0.0.11"
fi
case "$RESOLVER" in
    *:*) RESOLVER="[$RESOLVER]" ;;
esac
echo "Using DNS resolver: $RESOLVER"
echo "Configuring Nginx on port $PORT..."
sed -e "s/\${PORT}/$PORT/g" -e "s/\${RESOLVER}/$RESOLVER/g" /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
echo "Starting Nginx..."
exec nginx -g "daemon off;"
