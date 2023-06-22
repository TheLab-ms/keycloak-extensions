FROM curlimages/curl:8.1.2 AS downloader
WORKDIR /tmp
RUN curl -LO https://github.com/TheLab-ms/thelab-keycloak-theme/releases/download/v0.0.1/makerspace-theme.jar
RUN curl -LO https://github.com/wadahiro/keycloak-discord/releases/download/v0.4.1/keycloak-discord-0.4.1.jar

FROM quay.io/keycloak/keycloak:21.1.1 AS kc

ENV KC_DB=postgres
ENV KC_FEATURES=declarative-user-profile
COPY --from=downloader /tmp /opt/keycloak/providers

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:21.1.1
COPY --from=kc /opt/keycloak/ /opt/keycloak/
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
