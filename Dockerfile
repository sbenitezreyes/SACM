# Usar una imagen base de Java
FROM eclipse-temurin:21-jdk

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo JAR generado al contenedor
COPY build/libs/sacm-0.0.1-SNAPSHOT.jar app.jar

# Exponer el puerto en el que corre tu aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]