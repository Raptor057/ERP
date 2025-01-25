# Etapa base para el contenedor SQL Server
FROM mcr.microsoft.com/mssql/server:latest AS base
WORKDIR /app
EXPOSE 1433

# Variables de entorno necesarias para SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Cbmwjmkq23

# Etapa de construcción del proyecto SQL
FROM base AS build
WORKDIR /src

# Instalar Git para clonar el repositorio
RUN apt-get update && apt-get install -y git && apt-get clean

# Clonar el repositorio directamente desde GitHub
RUN git clone https://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@github.com/Raptor057/Medical.Office.SqlLocalDB.git

# Cambiar al directorio del proyecto clonado
WORKDIR /src/Medical.Office.SqlLocalDB

# Publicar las tablas y datos en la base de datos SQL Server

# Esto asume que tienes scripts SQL que se ejecutan usando sqlcmd
# RUN /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Cbmwjmkq23 -d master -i Medical.Office.SqlLocalDB/ConfigurationTables/MedicalOffice/ConsultingTime.sql && \
#     /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Cbmwjmkq23 -d master -i Medical.Office.SqlLocalDB/ConfigurationTables/MedicalOffice/Doctors.sql && \
#     /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Cbmwjmkq23 -d master -i Medical.Office.SqlLocalDB/ConfigurationTables/MedicalOffice/PatientData.sql

# Imagen final
FROM base AS final
WORKDIR /app

# Copiar los scripts SQL necesarios (opcional)
COPY --from=build /src/Medical.Office.SqlLocalDB /app/Medical.Office.SqlLocalDB

# Comando de inicio para SQL Server
CMD [ "/opt/mssql/bin/sqlservr" ]
