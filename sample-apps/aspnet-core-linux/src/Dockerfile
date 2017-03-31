FROM microsoft/aspnetcore:1.1
ARG source=./bin/Debug/netcoreapp1.1/publish
WORKDIR /app
COPY $source /app
EXPOSE 80
ENTRYPOINT dotnet /app/aspnet-core-linux.dll
