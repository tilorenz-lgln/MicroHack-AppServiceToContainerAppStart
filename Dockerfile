### Prepare base image for deployment first so it's always cached
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

### Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["MicroHackApp.csproj", "."]
RUN dotnet restore "./MicroHackApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./MicroHackApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MicroHackApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

### Deploy
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MicroHackApp.dll"]
