FROM registry.access.redhat.com/ubi8/openjdk-21:1.20

ARG QUARKUS_PROFILE=pgsql,oidc
ENV LANGUAGE='en_US:en'
ENV QUARKUS_PROFILE=${QUARKUS_PROFILE}

COPY --chown=185 quarkus-app/lib/ /deployments/lib/
COPY --chown=185 quarkus-app/*.jar /deployments/
COPY --chown=185 quarkus-app/app/ /deployments/app/
COPY --chown=185 quarkus-app/quarkus/ /deployments/quarkus/

USER root
RUN mkdir -p /deployments/keys && chown -R 185:185 /deployments/keys
COPY --chown=185 private-key.pem /deployments/keys/private-key.pem
COPY --chown=185 public-key.pem /deployments/keys/public-key.pem

EXPOSE 8080
USER 185
ENV JAVA_OPTS_APPEND="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"

ENTRYPOINT [ "/opt/jboss/container/java/run/run-java.sh" ]
