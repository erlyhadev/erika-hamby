﻿#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ErikaHamby/ErikaHamby.csproj", "ErikaHamby/"]
RUN dotnet restore "ErikaHamby/ErikaHamby.csproj"
COPY ./ErikaHamby ./ErikaHamby
WORKDIR "/src/ErikaHamby"
RUN dotnet build "ErikaHamby.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ErikaHamby.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ErikaHamby.dll"]
