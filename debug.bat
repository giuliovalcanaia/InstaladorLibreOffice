@echo off
echo ===================================================
echo               MODO DEBUG: PASTAS (PLANO)
echo ===================================================
echo.

REM 1. Definindo as variaveis
set "LO_BASE_DIR=C:\Users\Aluno\AppData\Roaming\LibreOffice\4"
set "ORIGEM_REDE=\\TECS\Trabalhos\user"

echo Caminho Base Local: "%LO_BASE_DIR%"
echo Caminho da Rede: "%ORIGEM_REDE%"
echo.

REM 2. Matar processos
echo [ETAPA 1] Garantindo que o LibreOffice esta fechado...
taskkill /F /IM soffice.bin /T >nul 2>&1
taskkill /F /IM soffice.exe /T >nul 2>&1
echo - Processos encerrados.
echo.

REM 3. Testar acesso a rede
echo [ETAPA 2] Testando acesso a rede...
if not exist "%ORIGEM_REDE%" goto ERRO_REDE
echo - [SUCESSO] Acesso a pasta confirmado!
echo.
goto ETAPA_3

:ERRO_REDE
echo - [ERRO FATAL] O sistema nao conseguiu enxergar a pasta na rede.
goto FIM_DEBUG

:ETAPA_3
REM 4. Manipular pasta local
echo [ETAPA 3] Renomeando pasta local...
if not exist "%LO_BASE_DIR%" mkdir "%LO_BASE_DIR%"
if exist "%LO_BASE_DIR%\user-old" rmdir /S /Q "%LO_BASE_DIR%\user-old"

if not exist "%LO_BASE_DIR%\user" goto PULA_RENOMEAR
echo - Renomeando user para user-old...
ren "%LO_BASE_DIR%\user" "user-old"
if errorlevel 1 echo - [ERRO] O comando falhou. Algum outro programa esta usando a pasta!
goto ETAPA_4

:PULA_RENOMEAR
echo - A pasta user ainda nao existia. Nenhuma renomeacao necessaria.

:ETAPA_4
REM 5. Copiar nova pasta
echo.
echo [ETAPA 4] Iniciando a copia...
xcopy /E /I /H /Y "%ORIGEM_REDE%" "%LO_BASE_DIR%\user"

if errorlevel 1 goto ERRO_COPIA
echo.
echo - [SUCESSO] Arquivos copiados corretamente!
goto FIM_DEBUG

:ERRO_COPIA
echo.
echo - [ERRO] Falha na copia! Verifique se ha permissoes suficientes.

:FIM_DEBUG
echo.
echo ===================================================
echo Pressione qualquer tecla para fechar o teste...
pause >nul