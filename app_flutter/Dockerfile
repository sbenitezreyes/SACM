# Dockerfile para Flutter Web
# 1. Usa una imagen oficial de Dart/Flutter para construir
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY . .

# 2. Habilita web y obtiene dependencias
RUN flutter config --enable-web && \
    flutter pub get && \
    flutter build web --release

# 3. Usa Nginx para servir la app web
FROM nginx:alpine

# Elimina la configuración default de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia los archivos generados por Flutter Web
COPY --from=build /app/build/web /usr/share/nginx/html

# Expone el puerto 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
