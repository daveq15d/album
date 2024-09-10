FROM eclipse-temurin:17.0.11_9-jdk-jammy AS build
WORKDIR /app

# Copiar todo el contenido del proyecto
COPY . .

# Mostrar el contenido del directorio actual
RUN echo "Contenido del directorio actual:" && ls -la

# Buscar archivos de configuración de Gradle en todo el proyecto
RUN echo "Buscando archivos de configuración de Gradle:" && \
    find . -name "build.gradle" -o -name "build.gradle.kts"

# Mostrar el contenido del archivo de configuración de Gradle si existe
RUN if [ -f build.gradle ]; then \
        echo "Contenido de build.gradle:"; \
        cat build.gradle; \
    elif [ -f build.gradle.kts ]; then \
        echo "Contenido de build.gradle.kts:"; \
        cat build.gradle.kts; \
    else \
        echo "No se encontró ningún archivo de configuración de Gradle."; \
    fi

# Buscar el archivo gradlew
RUN echo "Buscando gradlew:" && find . -name "gradlew"

# Mostrar la estructura completa del proyecto
RUN echo "Estructura completa del proyecto:" && find .

# Aquí normalmente iría la construcción del proyecto, pero la omitimos por ahora

# Etapa de ejecución (la mantenemos por completitud)
FROM eclipse-temurin:17.0.11_9-jre-jammy
WORKDIR /app

# Nota: No copiamos el jar porque probablemente no se ha generado
# COPY --from=build /app/build/quarkus-app/quarkus-run.jar ./app.jar

# Exponer el puerto de la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación (lo comentamos porque no tenemos el jar)
# CMD ["java", "-jar", "app.jar"]

CMD ["echo", "El proyecto no se pudo construir debido a la falta de archivos de configuración de Gradle."]



