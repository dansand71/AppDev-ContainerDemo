FROM microsoft/aspnetcore:1.1
ARG source=./bin/Debug/netcoreapp1.1/publish
WORKDIR /app
COPY $source /app

#Support for setting root group access for openshift random user support
RUN chgrp -R 0 /app 
RUN chmod -R g+rwX /app
RUN find /app -type d -exec chmod g+x {} +

EXPOSE 80
ENTRYPOINT dotnet /app/aspnet-core-linux.dll
