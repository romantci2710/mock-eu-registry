FROM ghcr.io/cirpass-2/dpp-validator-pgsql-oidc:latest
USER root
RUN mkdir -p /deployments/config && chown -R 185:185 /deployments/config
COPY --chown=185 validator-application.properties /deployments/config/application.properties
USER 185
