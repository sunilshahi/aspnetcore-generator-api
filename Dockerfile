# Build Stage
FROM microsoft/aspnetcore-build:2 AS build-env

WORKDIR /generator

# Restore
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

# Copy Src
COPY . .

# Test
RUN dotnet test tests/tests.csproj

# Publish
RUN dotnet publish api/api.csproj -o /publish

# Runtime Stage
FROM microsoft/aspnetcore:2
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT ["dotnet", "api.dll"]