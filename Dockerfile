# Etapa de construcción
FROM eclipse-temurin:17.0.11_9-jdk-jammy AS build
WORKDIR /app

# Instalar Gradle
ENV GRADLE_VERSION=7.6.1
RUN apt-get update && apt-get install -y wget unzip \
    && wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
    && unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
    && ln -s /opt/gradle/gradle-${GRADLE_VERSION} /opt/gradle/latest \
    && rm /tmp/gradle-${GRADLE_VERSION}-bin.zip
ENV PATH="/opt/gradle/latest/bin:${PATH}"

# Copiar todo el contenido del proyecto
COPY . .

# Verificar la existencia de gradlew y darle permisos de ejecución si existe
RUN if [ -f gradlew ]; then chmod +x gradlew; fi

# Intentar construir con gradlew si existe, de lo contrario usar gradle
RUN if [ -f gradlew ]; then \
        ./gradlew build -Dquarkus.package.type=uber-jar; \
    else \
        gradle build -Dquarkus.package.type=uber-jar; \
    fi

# Etapa de ejecución
FROM eclipse-temurin:17.0.11_9-jre-jammy
WORKDIR /app

# Copiar el jar generado desde la etapa de construcción
COPY --from=build /app/build/quarkus-app/quarkus-run.jar ./app.jar

# Exponer el puerto de la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]



