FROM mcr.microsoft.com/dotnet/sdk:9.0-bookworm-slim AS build
WORKDIR /src

COPY Api/Api.csproj Api/
COPY Infrastructure/Infrastructure.csproj Infrastructure/
COPY Application/Application.csproj Application/
COPY Domain/Domain.csproj Domain/
RUN dotnet restore "./Api/Api.csproj"

COPY . .
ARG BUILD_CONFIGURATION=Release
RUN dotnet build "./Api/Api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Api/Api.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0-bookworm-slim AS start

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN addgroup --gid 1000 backend \
    && adduser --uid 1000 --gid 1000 --disabled-password --gecos "" backend

USER backend

WORKDIR /app
EXPOSE 5000

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Api.dll"]