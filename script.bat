@echo off
echo ===================================================
echo     INSTALACAO E CONFIGURACAO DO LIBREOFFICE
echo ===================================================
echo.

REM 1. Definindo as variaveis Iniciais
set "SOURCE_DIR=\\TECS\Trabalhos"
set "FILE_NAME=LibreOffice_26.2.3_Win_x86-64 (1).msi"
set "DEST_DIR=C:\Users\Aluno\Downloads"
set "MSI_PATH=%DEST_DIR%\%FILE_NAME%"

set "LO_BASE_DIR=C:\Users\Aluno\AppData\Roaming\LibreOffice\4"
set "ORIGEM_REDE=\\TECS\Trabalhos\user"

REM 2. Copia o instalador da rede para a maquina local com progresso
echo [ETAPA 1] Copiando o instalador da rede...
if not exist "%DEST_DIR%" mkdir "%DEST_DIR%"
robocopy "%SOURCE_DIR%" "%DEST_DIR%" "%FILE_NAME%" /Z /NJH /NJS /NDL

REM Verifica se a copia do instalador funcionou
if not exist "%MSI_PATH%" goto ERRO_MSI
echo - [SUCESSO] Instalador copiado para a maquina local.
echo.

REM 3. Instalação do LibreOffice
echo [ETAPA 2] Instalando o LibreOffice...
echo - Aguarde, isso pode levar alguns minutos.
start /wait msiexec /i "%MSI_PATH%" /passive /norestart ADDLOCAL=ALL REMOVE=gm_o_Onlineupdate

REM Verifica se a instalação deu certo
if errorlevel 1 goto ERRO_INSTALACAO
echo - [SUCESSO] Instalacao concluida!
echo.

REM 4. Matar processos residuais
echo [ETAPA 3] Garantindo fechamento de processos em segundo plano...
taskkill /F /IM soffice.bin /T >nul 2>&1
taskkill /F /IM soffice.exe /T >nul 2>&1
echo - Processos encerrados.
echo.

REM 5. Testar acesso a pasta de configuracoes na rede
echo [ETAPA 4] Verificando configuracoes do usuario na rede...
if not exist "%ORIGEM_REDE%" goto ERRO_REDE
echo - [SUCESSO] Pasta de configuracoes encontrada!
echo.

REM 6. Manipular pasta local
echo [ETAPA 5] Aplicando configuracoes padronizadas...
if not exist "%LO_BASE_DIR%" mkdir "%LO_BASE_DIR%"
if exist "%LO_BASE_DIR%\user-old" rmdir /S /Q "%LO_BASE_DIR%\user-old"

if not exist "%LO_BASE_DIR%\user" goto PULA_RENOMEAR
ren "%LO_BASE_DIR%\user" "user-old"

:PULA_RENOMEAR
REM 7. Copiar nova pasta de configuracao
xcopy /E /I /H /Y "%ORIGEM_REDE%" "%LO_BASE_DIR%\user" >nul
if errorlevel 1 goto ERRO_COPIA

echo.
echo ===================================================
echo [SUCESSO] LibreOffice instalado e configurado!
echo ===================================================
goto FIM

:ERRO_MSI
echo.
echo [ERRO] O instalador nao foi encontrado ou houve falha na copia.
goto FIM

:ERRO_INSTALACAO
echo.
echo [ERRO] Falha na instalacao do LibreOffice. Codigo de erro: %errorlevel%
goto FIM

:ERRO_REDE
echo.
echo [ERRO] Nao foi possivel acessar a pasta de configuracoes na rede: "%ORIGEM_REDE%"
goto FIM

:ERRO_COPIA
echo.
echo [ERRO] Falha ao copiar a pasta de configuracoes do usuario. Verifique as permissoes.

:FIM
echo.
pause