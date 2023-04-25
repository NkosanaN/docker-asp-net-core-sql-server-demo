FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

  #COPY ["nscacert.pem", "/usr/local/share/ca-certificates/netskope.crt"]
  RUN update-ca-certificates

WORKDIR /src
COPY ["app.csproj", "./"]
RUN dotnet restore "./app.csproj"
COPY . .
RUN dotnet build "app.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "app.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "app.dll"]