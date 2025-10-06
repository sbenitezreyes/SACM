# Stage 1: Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY . .

RUN flutter config --enable-web && \
    flutter pub get && \
    flutter build web --release

# Stage 2: Nginx para servir Flutter Web
FROM nginx:alpine

# Copia la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Limpia la carpeta por defecto de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia los archivos web generados desde el build
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
