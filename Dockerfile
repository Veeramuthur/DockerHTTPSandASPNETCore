FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 85

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["WeatherAPI/WeatherAPI.csproj", "WeatherAPI/"]
RUN dotnet restore "WeatherAPI\WeatherAPI.csproj"
COPY . .
WORKDIR "/src/WeatherAPI"
RUN dotnet build "WeatherAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WeatherAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WeatherAPI.dll"]
