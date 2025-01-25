## See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Etapa base para el contenedor
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Agregar la variable de entorno para el entorno de ejecución
ENV ASPNETCORE_ENVIRONMENT=Production

# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
ARG GIT_TOKEN
WORKDIR /src

# Instalar Git en el contenedor
RUN apt-get update && apt-get install -y git && apt-get clean

# Clonar los repositorios usando el token
RUN git clone https://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@github.com/Raptor057/Medical.Office.Net8WebApi.git


# Restaurar dependencias del proyecto principal
WORKDIR /src/Medical.Office.Net8WebApi/Medical.Office.Net8WebApi

RUN dotnet restore "Medical.Office.Net8WebApi.csproj"

# Build del proyecto principal con configuración de build
RUN dotnet build "Medical.Office.Net8WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Etapa de publish
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "Medical.Office.Net8WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Imagen final
FROM base AS final
WORKDIR /app

# Copiar los archivos publicados desde la etapa de publish
COPY --from=publish /app/publish .

# Establecer la variable de entorno para la etapa final (producción)
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "Medical.Office.Net8WebApi.dll"]
