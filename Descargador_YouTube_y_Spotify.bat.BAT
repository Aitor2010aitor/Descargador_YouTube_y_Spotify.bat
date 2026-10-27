@echo off
setlocal EnableExtensions
title Descargador Multimedia (YouTube y Spotify)

:MENU_PRINCIPAL
cls
echo ==========================================
echo        DESCARGADOR MULTIMEDIA
echo ==========================================
echo.
echo 1. Descargar de YouTube (yt-dlp)
echo 2. Descargar de Spotify (spotDL)
echo 3. Salir
echo.
echo ==========================================
choice /c 123 /n /m "Selecciona una opcion [1-3]: "

if errorlevel 3 exit /b 0
if errorlevel 2 goto SPOTIFY_INIT
if errorlevel 1 goto YOUTUBE_INIT

goto MENU_PRINCIPAL

:: ==========================================
:: MÓDULO YOUTUBE
:: ==========================================
:YOUTUBE_INIT
cls
echo ==========================================
echo Actualizando yt-dlp y comprobando dependencias...
echo ==========================================
py --version >nul 2>&1
if errorlevel 1 goto ERROR_PYTHON
py -m pip install --upgrade pip
py -m pip install --upgrade yt-dlp
if errorlevel 1 goto ERROR_YTDLP

call :CHECK_FFMPEG
if errorlevel 1 goto ERROR_FFMPEG

goto YT_MENU

:YT_MENU
cls
echo ==========================================
echo          YOUTUBE DOWNLOADER
echo ==========================================
echo.
echo 1. Descargar Video (Maxima calidad)
echo 2. Descargar Audio (MP3)
echo 3. Descargar Canal Completo
echo 4. Volver al menu principal
echo.
echo ==========================================
choice /c 1234 /n /m "Selecciona una opcion [1-4]: "

if errorlevel 4 goto MENU_PRINCIPAL
if errorlevel 3 goto YT_CANAL
if errorlevel 2 goto YT_AUDIO
if errorlevel 1 goto YT_VIDEO

goto YT_MENU

:YT_VIDEO
cls
echo ==========================================
echo DESCARGAR VIDEO (YOUTUBE)
echo ==========================================
echo.
set "url="
set /p "url=Introduce la URL del video: "
if not defined url (
    echo Debes introducir una URL.
    pause
    goto YT_MENU
)

echo.
echo Carpeta de destino (Pulsa ENTER para usar %USERPROFILE%\Desktop\YouTube):
set "carpeta="
set /p "carpeta=Carpeta: "
if not defined carpeta set "carpeta=%USERPROFILE%\Desktop\YouTube"

if not exist "%carpeta%" mkdir "%carpeta%"

echo.
echo Descargando en la maxima calidad disponible...
echo.

py -m yt_dlp ^
-f "bestvideo+bestaudio/best" ^
--ffmpeg-location "%FFMPEG_EXE%" ^
--merge-output-format mp4 ^
--remux-video mp4 ^
--embed-thumbnail ^
--embed-metadata ^
