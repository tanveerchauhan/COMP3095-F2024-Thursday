#------------
# Build Stage
#------------
FROM gradle:8-jdk23-alpine AS builder

COPY --chown=gradle:gradle . /home/gradle/src

WORKDIR /home/gradle/src

RUN gradle build -x test

#---------------
# Package Stage
#---------------
FROM openjdk:23

RUN mkdir /app

COPY --from=builder /home/gradle/src/build/libs/*.jar /app/api-gateway.jar

#ENV POSTGRES_USER=admin \
#    POSTGRES_PWD=password

ENV SPRING_PROFILES_ACTIVE=docker \
    SPRING_APPLICATION_JSON='{"logging":{"level":{"root":"INFO","ca.gbc.apigateway":"DEBUG"}}}'


EXPOSE 9001

ENTRYPOINT ["java", "-jar", "/app/api-gateway.jar"]