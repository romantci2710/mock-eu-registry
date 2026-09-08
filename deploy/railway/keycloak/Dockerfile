FROM quay.io/keycloak/keycloak:25.0
COPY keycloak-realm.json /opt/keycloak/data/import/registry-realm.json
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev", "--import-realm", "--http-port=8180"]
