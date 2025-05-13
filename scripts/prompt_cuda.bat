@echo off
REM Script to prompt user for CUDA support preference

echo === CUDA Support Selection ===
echo.
echo Do you want to use NVIDIA GPU (CUDA) support?
echo This requires an NVIDIA GPU and proper NVIDIA Docker runtime configuration.
echo.
set /p choice="Use CUDA support? (y/n): "

if /i "%choice%"=="y" goto cuda
if /i "%choice%"=="yes" goto cuda
goto nocuda

:cuda
echo Selected: WITH CUDA support

REM Create or update .env file with the Docker image selection
if exist .env (
    REM Check if variable already exists in file
    findstr /c:"DOCKER_BACKEND_IMAGE" .env >nul
    if %ERRORLEVEL% EQU 0 (
        REM Update existing variable
        powershell -Command "(Get-Content .env) -replace '^DOCKER_BACKEND_IMAGE=.*', 'DOCKER_BACKEND_IMAGE=wyxhhhh/second-me-backend-cuda:latest' | Set-Content .env"
    ) else (
        REM Append to file with newline before
        echo.>> .env
        echo DOCKER_BACKEND_IMAGE=wyxhhhh/second-me-backend-cuda:latest>> .env
    )
    
    REM Set USE_CUDA flag
    findstr /c:"USE_CUDA" .env >nul
    if %ERRORLEVEL% EQU 0 (
        powershell -Command "(Get-Content .env) -replace '^USE_CUDA=.*', 'USE_CUDA=1' | Set-Content .env"
    ) else (
        echo USE_CUDA=1>> .env
    )
) else (
    REM Create new file
    echo DOCKER_BACKEND_IMAGE=wyxhhhh/second-me-backend-cuda:latest> .env
    echo USE_CUDA=1>> .env
)

REM Create a flag file to indicate GPU use
echo GPU > .gpu_selected

echo Environment set to use CUDA support
goto end

:nocuda
echo Selected: WITHOUT CUDA support (CPU only)

REM Determine which image to use based on architecture
FOR /F "tokens=*" %%g IN ('powershell -Command "if ([Environment]::Is64BitOperatingSystem -and [System.Environment]::GetEnvironmentVariable('PROCESSOR_ARCHITECTURE') -eq 'ARM64') {'arm64'} else {'x64'}"') do SET ARCH=%%g

if "%ARCH%"=="arm64" (
    SET BACKEND_IMAGE=wyxhhhh/second-me-backend-apple:latest
    echo Detected Apple Silicon/ARM64 architecture
) else (
    SET BACKEND_IMAGE=wyxhhhh/second-me-backend:latest
    echo Detected x86_64 architecture
)

REM Create or update .env file with the Docker image selection
if exist .env (
    REM Check if variable already exists in file
    findstr /c:"DOCKER_BACKEND_IMAGE" .env >nul
    if %ERRORLEVEL% EQU 0 (
        REM Update existing variable
        powershell -Command "(Get-Content .env) -replace '^DOCKER_BACKEND_IMAGE=.*', ('DOCKER_BACKEND_IMAGE=' + '%BACKEND_IMAGE%') | Set-Content .env"
    ) else (
        REM Append to file with newline before
        echo.>> .env
        echo DOCKER_BACKEND_IMAGE=%BACKEND_IMAGE%>> .env
    )
    
    REM Set USE_CUDA flag
    findstr /c:"USE_CUDA" .env >nul
    if %ERRORLEVEL% EQU 0 (
        powershell -Command "(Get-Content .env) -replace '^USE_CUDA=.*', 'USE_CUDA=0' | Set-Content .env"
    ) else (
        echo USE_CUDA=0>> .env
    )
) else (
    REM Create new file
    echo DOCKER_BACKEND_IMAGE=%BACKEND_IMAGE%> .env
    echo USE_CUDA=0>> .env
)

REM Remove any GPU flag file if it exists
if exist .gpu_selected (
    del .gpu_selected
)

echo Environment set to use without CUDA support

:end

REM Ask if user wants to pull the latest images
echo.
set /p pull_choice="Would you like to pull the latest Docker images now? (y/n): "

if /i "%pull_choice%"=="y" goto pull
if /i "%pull_choice%"=="yes" goto pull
goto skip_pull

:pull
echo Pulling the latest Docker images...

REM Extract backend image from .env file
for /f "tokens=2 delims==" %%a in ('type .env ^| findstr "DOCKER_BACKEND_IMAGE"') do set BACKEND_IMAGE=%%a

REM Pull images
docker pull %BACKEND_IMAGE%
docker pull wyxhhhh/second-me-frontend:latest

echo Docker images successfully updated
goto finish

:skip_pull
echo Skipped pulling Docker images

:finish
echo === CUDA Selection Complete ===