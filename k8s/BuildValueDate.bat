::please use your local project folder path
SET projPath=%cd%
SET publishDirPath=%projPath%\ValueDateService\Published

IF EXIST %publishDirPath% RMDIR %publishDirPath% /q /s

CHDIR %projPath%

docker container kill value_date-image
REM docker container kill postgres-image
docker container rm value_date-image
REM docker container rm postgres-image
docker image rm value_date-image

dotnet restore %projPath%\ValueDateService\ValueDateService.csproj -s https://artifactory.wuintranet.net/artifactory/api/nuget/v3/wubs-nuget-local
dotnet msbuild %projPath%\ValueDateService\ValueDateService.csproj -p:Configuration=Release
dotnet publish %projPath%\ValueDateService\ValueDateService.csproj --configuration Release --output %projPath%\ValueDateService\published
docker build -f %projPath%\ValueDateService\Dockerfile -t value_date-image . 
REM docker run -d -p 49176:443 -e ASPNETCORE_ENVIRONMENT=local latest 
docker-compose up -d
PAUSE