FROM mcr.microsoft.com/dotnet/runtime:3.1 AS base
COPY --from=forlabs/libfaketime  /faketime.so /faketime.so
ENV LD_PRELOAD=/faketime.so \
    DONT_FAKE_MONOTONIC=1 \
    FAKETIME_TIMESTAMP_FILE=/etc/faketimerc \
    FAKETIME_NO_CACHE=1 \
    FAKETIME_XRESET=1
RUN echo "/faketime.so" > /etc/ld.so.preload
RUN touch /etc/faketimerc
RUN chmod 777 /etc/faketimerc
WORKDIR /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["libfaketime.csproj", "./"]
RUN dotnet restore "libfaketime.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "libfaketime.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "libfaketime.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "libfaketime.dll"]
