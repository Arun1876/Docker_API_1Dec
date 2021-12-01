#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["DOCKERWEBAPI_PUBLISH.csproj", ""]
RUN dotnet restore "DOCKERWEBAPI_PUBLISH.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DOCKERWEBAPI_PUBLISH.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DOCKERWEBAPI_PUBLISH.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DOCKERWEBAPI_PUBLISH.dll"]