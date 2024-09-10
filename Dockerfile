# Fase de construcción
FROM gradle:7.6.0-jdk17 AS build

# Establece el directorio de trabajo
WORKDIR /usr/src/app

# Clona el código fuente desde el repositorio (si es necesario)
# Aquí asumo que el código ya está presente y no es necesario clonarlo, ya que estás usando un despliegue basado en GitHub

# Ejecuta la compilación con Gradle
# No necesitas copiar build.gradle ni settings.gradle si se generan dentro del contenedor
RUN gradle build --no-daemon

# Fase de ejecución
FROM eclipse-temurin:17-jre-alpine

# Establece el directorio de trabajo para la aplicación
WORKDIR /app

# Copia los archivos generados en la fase de construcción
COPY --from=build /usr/src/app/build/quarkus-app/lib/ /app/lib/
COPY --from=build /usr/src/app/build/quarkus-app/app/ /app/app/
COPY --from=build /usr/src/app/build/quarkus-app/quarkus/ /app/quarkus/
COPY --from=build /usr/src/app/build/quarkus-app/quarkus-run.jar /app/app.jar

# Ejecuta la aplicación al iniciar el contenedor
CMD ["java", "-jar", "app.jar"]


