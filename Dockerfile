FROM eclipse-temurin:17.0.11_9-jre-jammy

RUN mkdir /app
WORKDIR /app

# Copiar el código fuente al contenedor
COPY . .

# Instalar herramientas necesarias para compilar (si es necesario)
RUN apt-get update && apt-get install -y maven

# Compilar el proyecto
RUN ./mvnw package -DskipTests

# Mover los archivos generados al lugar correcto
RUN cp target/quarkus-app/* /app/

CMD ["java", "-jar", "app.jar"]



