# Etapa de construcción
FROM eclipse-temurin:17.0.11_9-jdk-jammy AS build
WORKDIR /app

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



