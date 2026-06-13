# Etapa 1 — Frontend Astro
FROM node:24-alpine AS build-frontend
WORKDIR /usr/app
COPY frontend/ .
RUN npm ci
RUN npm run build

# Etapa 2 — Backend .NET
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS build-backend
WORKDIR /app
COPY backend/ .
RUN dotnet publish -c Release -o out

# Etapa 3 — Imagen final
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build-backend /app/out .
COPY --from=build-frontend /usr/app/dist ./wwwroot
EXPOSE 3000
CMD ["dotnet", "MangaApi.dll"]