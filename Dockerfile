FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /workspace

COPY pom.xml ./
COPY src src

RUN mvn -B -DskipTests package

FROM eclipse-temurin:21-jre

WORKDIR /app

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && addgroup --system spring \
    && adduser --system spring --ingroup spring \
    && mkdir -p /app/data \
    && chown -R spring:spring /app

COPY --from=build /workspace/target/inventory-api.jar /app/inventory-api.jar

RUN chown spring:spring /app/inventory-api.jar

USER spring:spring

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=dev

ENTRYPOINT ["java", "-jar", "/app/inventory-api.jar"]
