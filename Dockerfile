FROM eclipse-temurin:17.0.11_9-jre-jammy

# Crear directorio para la aplicación
RUN mkdir /app
WORKDIR /app

# Copiar el código fuente al contenedor
COPY . .

# Copiar el wrapper de Gradle y dar permisos de ejecución
COPY ./gradlew ./gradlew
COPY ./gradle ./gradle
RUN chmod +x ./gradlew

# Instalar dependencias necesarias (opcional dependiendo de la base de la imagen, pero Gradle lo maneja internamente)
RUN apt-get update && apt-get install -y curl unzip

# Compilar el proyecto con Gradle (omitimos los tests si es necesario)
RUN ./gradlew build -x test

# Mover el artefacto generado (ajusta la ruta si es necesario)
RUN cp build/libs/*.jar app.jar

# Definir el comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]




