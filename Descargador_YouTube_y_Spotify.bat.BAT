
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

if errorlevel 1 (
    echo.
    echo ==========================================
    echo [ERROR] No se pudo completar la descarga.
) else (
    echo.
    echo ==========================================
    echo [OK] Descarga finalizada.
    echo.
    echo Abriendo carpeta de destino...
    start "" "%CARPETA%"
)
echo ==========================================
echo.
pause
goto SPOTIFY_MENU

:: Comprueba FFmpeg del sistema. Si no existe, instala imageio-ffmpeg
:: y obtiene la ruta del ejecutable para yt-dlp. También lo copia con
:: el nombre ffmpeg.exe para que spotDL pueda encontrarlo por PATH.
:CHECK_FFMPEG
set "FFMPEG_EXE="
set "FFMPEG_DIR="
where ffmpeg >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%F in ('where ffmpeg 2^>nul') do if not defined FFMPEG_EXE set "FFMPEG_EXE=%%F"
    for %%D in ("%FFMPEG_EXE%") do set "FFMPEG_DIR=%%~dpD"
    set "PATH=%FFMPEG_DIR%;%PATH%"
    exit /b 0
)

echo FFmpeg no esta disponible en PATH. Comprobando imageio-ffmpeg...
py -c "import imageio_ffmpeg" >nul 2>&1
if errorlevel 1 (
    echo Instalando imageio-ffmpeg...
    py -m pip install imageio-ffmpeg
    if errorlevel 1 exit /b 1
)

for /f "delims=" %%F in ('py -c "import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())" 2^>nul') do set "FFMPEG_EXE=%%F"
if not defined FFMPEG_EXE exit /b 1
for %%D in ("%FFMPEG_EXE%") do set "FFMPEG_DIR=%%~dpD"

:: spotDL normalmente busca un ejecutable llamado ffmpeg.exe en PATH.
:: Copia el binario de imageio-ffmpeg a una carpeta auxiliar del usuario.
set "FFMPEG_HELPER=%LOCALAPPDATA%\DescargadorMultimedia\ffmpeg.exe"
if not exist "%LOCALAPPDATA%\DescargadorMultimedia" mkdir "%LOCALAPPDATA%\DescargadorMultimedia" >nul 2>&1
copy /y "%FFMPEG_EXE%" "%FFMPEG_HELPER%" >nul 2>&1
if exist "%FFMPEG_HELPER%" (
    set "FFMPEG_DIR=%LOCALAPPDATA%\DescargadorMultimedia"
    set "PATH=%FFMPEG_DIR%;%PATH%"
)
exit /b 0

:ERROR_PYTHON
@echo off
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
@echo off
cls
echo ==========================================
echo               ERROR
echo ==========================================
echo.
echo No se pudo instalar o actualizar spotDL.
echo.
pause
goto MENU_PRINCIPAL

:ERROR_YTDLP
@echo off
cls
echo ==========================================
echo               ERROR
echo ==========================================
echo.
echo No se pudo instalar o actualizar yt-dlp.
echo.
pause
goto MENU_PRINCIPAL

:ERROR_FFMPEG
@echo off
cls
echo ==========================================
echo               ERROR
echo ==========================================
echo.
echo No se pudo encontrar o instalar FFmpeg mediante imageio-ffmpeg.
echo Comprueba tu conexion a Internet y que pip funcione.
echo.
pause
goto MENU_PRINCIPAL
