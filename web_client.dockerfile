# Versión 3.0
# Etapa 1: Construcción de la aplicación
FROM node:lts-alpine AS build
WORKDIR /usr/src/app

# Instalar Git en la imagen base de Node.js
RUN apk add --no-cache git

# Clonar el repositorio directamente desde GitHub
RUN git clone https://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@github.com/Raptor057/Medical.Office.ReactWebClient.git

# Cambiar al directorio del proyecto clonado
WORKDIR /usr/src/app/Medical.Office.ReactWebClient

# Instalar dependencias
RUN npm install --silent

# Pasar la variable de entorno para React
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

# Construir la aplicación estática
RUN npm run build

# Copiar artefactos generados a un directorio temporal
WORKDIR /usr/src/app
RUN mkdir /usr/src/app/artifacts && \
    cp -r /usr/src/app/Medical.Office.ReactWebClient/out /usr/src/app/artifacts && \
    cp /usr/src/app/Medical.Office.ReactWebClient/nginx.conf /usr/src/app/artifacts

# Borrar la carpeta del repositorio clonado
RUN rm -rf /usr/src/app/Medical.Office.ReactWebClient

# Etapa 2: Servir los archivos estáticos con Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copiar los artefactos generados al directorio de Nginx
COPY --from=build /usr/src/app/artifacts/out .

# Remover configuración por defecto de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Agregar configuración personalizada de Nginx
COPY --from=build /usr/src/app/artifacts/nginx.conf /etc/nginx/conf.d

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
