@echo off
REM Script to pull the latest Docker images based on environment configuration

echo === Pulling Second-Me Docker Images ===

REM Check if .env file exists
if not exist .env (
  echo Error: .env file not found. Please run scripts\prompt_cuda.bat first to configure your environment.
  exit /b 1
)

REM Read DOCKER_BACKEND_IMAGE from .env file
set BACKEND_IMAGE=wyxhhhh/second-me-backend:latest
for /f "tokens=1,2 delims==" %%a in (.env) do (
  if "%%a"=="DOCKER_BACKEND_IMAGE" set BACKEND_IMAGE=%%b
)

echo Pulling backend image: %BACKEND_IMAGE%
docker pull %BACKEND_IMAGE%

echo Pulling frontend image: wyxhhhh/second-me-frontend:latest
docker pull wyxhhhh/second-me-frontend:latest

echo Docker images successfully updated
echo === Pull Complete ===