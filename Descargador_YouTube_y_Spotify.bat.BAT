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
py -m pip install --upgrade pip
py -m pip install --upgrade yt-dlp

ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo Instalando FFmpeg mediante winget...
    winget install -e --id Gyan.FFmpeg --accept-package-agreements --accept-source-agreements
)

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
--merge-output-format mp4 ^
--remux-video mp4 ^
--embed-thumbnail ^
--embed-metadata ^
--no-keep-video ^
-P "%carpeta%" ^
-o "%%(title)s.%%(ext)s" ^
"%url%"

echo.
echo ==========================================
echo Descarga finalizada.
echo ==========================================
pause
goto YT_MENU

:YT_AUDIO
cls
echo ==========================================
echo DESCARGAR AUDIO MP3 (YOUTUBE)
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
echo Carpeta de destino (Pulsa ENTER para usar %USERPROFILE%\Desktop\YouTube_MP3):
set "carpeta="
set /p "carpeta=Carpeta: "
if not defined carpeta set "carpeta=%USERPROFILE%\Desktop\YouTube_MP3"

if not exist "%carpeta%" mkdir "%carpeta%"

echo.
echo Descargando audio...

py -m yt_dlp ^
-x ^
--audio-format mp3 ^
--audio-quality 0 ^
--embed-thumbnail ^
--embed-metadata ^
-P "%carpeta%" ^
-o "%%(title)s.%%(ext)s" ^
"%url%"

echo.
echo ==========================================
echo Descarga finalizada.
echo ==========================================
pause
goto YT_MENU

:YT_CANAL
cls
echo ==========================================
echo DESCARGAR CANAL COMPLETO (YOUTUBE)
echo ==========================================
echo.
set "url="
set /p "url=Introduce la URL del canal (ej: https://www.youtube.com/@nombre) : "
if not defined url (
    echo Debes introducir la URL del canal.
    pause
    goto YT_MENU
)

echo.
echo Carpeta de destino (Pulsa ENTER para guardar en el Escritorio):
echo %USERPROFILE%\Desktop\Canales_YouTube
echo.
set "carpeta="
set /p "carpeta=Carpeta: "
if not defined carpeta set "carpeta=%USERPROFILE%\Desktop\Canales_YouTube"

if not exist "%carpeta%" mkdir "%carpeta%"

echo.
echo Procesando y descargando todos los videos del canal...
echo.

py -m yt_dlp ^
-f "bestvideo+bestaudio/best" ^
--merge-output-format mp4 ^
--remux-video mp4 ^
--embed-thumbnail ^
--embed-metadata ^
--no-keep-video ^
-P "%carpeta%" ^
-o "%%(uploader)s/%%(title)s.%%(ext)s" ^
"%url%"

echo.
echo ==========================================
echo Descarga del canal finalizada.
echo ==========================================
pause
goto YT_MENU


:: ==========================================
:: MÓDULO SPOTIFY
:: ==========================================
:SPOTIFY_INIT
cls
echo ==========================================
echo Comprobando dependencias de Spotify...
echo ==========================================
py --version >nul 2>&1
if errorlevel 1 goto ERROR_PYTHON

py -m pip install --upgrade pip
py -m pip install --upgrade spotdl
if errorlevel 1 goto ERROR_SPOTDL

ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo Instalando FFmpeg mediante winget...
    winget install -e --id Gyan.FFmpeg --accept-package-agreements --accept-source-agreements
)

:SPOTIFY_MENU
cls
echo ==========================================
echo        SPOTIFY DOWNLOADER
echo ==========================================
echo.
echo 1. Descargar desde Spotify
echo 2. Volver al menu principal
echo.
echo ==========================================
choice /c 12 /n /m "Selecciona una opcion [1-2]: "

if errorlevel 2 goto MENU_PRINCIPAL
if errorlevel 1 goto SPOTIFY_DESCARGAR

:SPOTIFY_DESCARGAR
cls
echo ==========================================
echo        DESCARGAR DESDE SPOTIFY
echo ==========================================
echo.
echo Pega aqui el enlace de Spotify.
echo Puede ser una cancion, album, playlist o artista.
echo.
set "URL="
set /p "URL=URL: "

if not defined URL goto SPOTIFY_MENU

echo.
echo Carpeta de destino:
echo Pulsa ENTER para crear/usar una carpeta en el Escritorio:
echo %USERPROFILE%\Desktop\Spotify
echo.
set "CARPETA="
set /p "CARPETA=Carpeta: "

if not defined CARPETA set "CARPETA=%USERPROFILE%\Desktop\Spotify"

if not exist "%CARPETA%" mkdir "%CARPETA%"

cls
echo ==========================================
echo              DESCARGANDO
echo ==========================================
echo.
echo Destino:
echo %CARPETA%
echo.
echo Procesando enlace de Spotify...
echo.

py -m spotdl download "%URL%" --format mp3 --output "%CARPETA%\{artist} - {title}.{output-ext}"

echo.
echo ==========================================
if errorlevel 1 (
    echo [ERROR] No se pudo completar la descarga.
) else (
    echo [OK] Descarga finalizada.
    echo.
    echo Abriendo carpeta de destino...
    start "" "%CARPETA%"
)
echo ==========================================
echo.
pause
goto SPOTIFY_MENU

:ERROR_PYTHON
cls
echo ==========================================
echo               ERROR
echo ==========================================
echo.
echo Python no esta instalado o no funciona.
echo.
pause
goto MENU_PRINCIPAL

:ERROR_SPOTDL
cls
echo ==========================================
echo               ERROR
echo ==========================================
echo.
echo No se pudo instalar o actualizar spotDL.
echo.
pause
goto MENU_PRINCIPAL
