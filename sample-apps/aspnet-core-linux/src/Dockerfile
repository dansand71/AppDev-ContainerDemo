FROM microsoft/aspnetcore:1.1
ARG source
WORKDIR /app
EXPOSE 5000
COPY ${source:-obj/Docker/publish} .
ENTRYPOINT ["dotnet", "aspnet-core-linux.dll"]
