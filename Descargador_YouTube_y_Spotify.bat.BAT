echo ==========================================
echo Comprobando dependencias de Spotify...
echo ==========================================
py --version >nul 2>&1
if errorlevel 1 goto ERROR_PYTHON

py -m pip install --upgrade pip
py -m pip install --upgrade spotdl
if errorlevel 1 goto ERROR_SPOTDL

rem Comprobar imageio-ffmpeg e instalarlo si falta.
py -c "import imageio_ffmpeg" >nul 2>&1
if errorlevel 1 (
    echo Instalando imageio-ffmpeg...
    py -m pip install imageio-ffmpeg
    if errorlevel 1 (
        echo [ERROR] No se pudo instalar imageio-ffmpeg.
        pause
        goto MENU_PRINCIPAL
    )
)

rem Obtener el ejecutable FFmpeg incluido en el paquete.
set "IMAGEIO_FFMPEG="
for /f "delims=" %%F in ('py -c "import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())" 2^>nul') do set "IMAGEIO_FFMPEG=%%F"
if not defined IMAGEIO_FFMPEG goto ERROR_FFMPEG

rem Añadir su carpeta al PATH para que spotDL pueda localizar FFmpeg.
for %%F in ("%IMAGEIO_FFMPEG%") do set "IMAGEIO_FFMPEG_DIR=%%~dpF"
set "PATH=%IMAGEIO_FFMPEG_DIR%;%PATH%"

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

:ERROR_FFMPEG
cls
echo ==========================================
echo               ERROR FFmpeg
echo ==========================================
echo.
echo No se pudo encontrar FFmpeg. Comprueba que Python y pip funcionan.
echo.
pause
goto MENU_PRINCIPAL

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
