@echo off
setlocal
title 게이브 서버 25565
cd /d "%~dp0"

rem 자바 25 확인(PATH 의 java)
where java >nul 2>nul || goto :nojava
set "JV="
for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i "version"') do if not defined JV set "JV=%%~v"
set "JMAJOR=0"
for /f "tokens=1 delims=.-+_" %%m in ("%JV%") do set "JMAJOR=%%m"
set /a JMAJOR=JMAJOR+0 >nul 2>nul
if %JMAJOR% LSS 25 goto :oldjava

rem 25565 포트 확인
netstat -ano | findstr /r /c:":25565 .*LISTENING" >nul && (
  echo 25565 포트를 이미 다른 프로그램이 쓰고 있습니다. 다른 서버를 끄고 다시 켜 주세요.
  pause
  exit /b 1
)

rem 서버 설정: 처음 한 번 기본값을 복사
if not exist server.properties copy server.properties.default server.properties >nul

rem 리소스팩: github eiqq/danta-resourcepack 의 gave 브랜치. 서버가 이 파일을 읽고, 접속자에게는 이 주소를 보낸다
set "PACK_URL=https://raw.githubusercontent.com/eiqq/danta-resourcepack/f89a448e3b380be8e5b6dc099d26c7b172afd56b/gave_pack.zip"
set "PACK_SHA1=fff5f1b120132fbcd34e69a8cb50fc25478e4009"
if not exist pack mkdir pack
set "HAVE="
if exist pack\Gave-pack.zip for /f "usebackq delims=" %%h in (`powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA1 -LiteralPath 'pack\Gave-pack.zip').Hash.ToLower()"`) do set "HAVE=%%h"
if /i "%HAVE%"=="%PACK_SHA1%" goto :run
echo 리소스팩을 받습니다. 약 95MB 라 조금 걸립니다.
curl -fL --retry 3 -o pack\Gave-pack.zip "%PACK_URL%" || goto :nopack

:run
echo 게이브 서버를 25565 포트로 켭니다. 끌 때는 이 창에 stop 을 입력하세요.
echo 처음 켤 때는 Paper 가 Mojang 서버 파일을 받느라 1~2분 걸립니다.
echo 다른 PC 에서 들어오게 하려면 공유기와 방화벽에서 25565 포트(팩 예비 8088 포트도)를 이 PC 로 열어 주세요.
echo 운영자 지정: 이 창에 op 닉네임. 판 시작: 게임 안에서 /gave 시작
echo.
java -Xms2G -Xmx4G -Dfile.encoding=UTF-8 -Dspark.backgroundProfiler=false -Dgave.packPort=8088 -Dgave.packUrl=%PACK_URL% -Dgave.packDir=pack -Dgave.datapackDir=datapack\gave_env -jar server.jar --nogui
echo.
echo 서버가 꺼졌습니다.
pause
exit /b 0

:nopack
echo 리소스팩을 받지 못했습니다. 인터넷 연결을 확인하고 다시 켜 주세요.
echo 주소: %PACK_URL%
pause
exit /b 1

:nojava
echo 자바를 찾지 못했습니다. 이 서버는 자바 25 가 필요합니다.
echo Adoptium 에서 Temurin 25(JDK 또는 JRE)를 받아 설치하세요. 설치할 때 PATH 에 추가를 켭니다.
echo https://adoptium.net/temurin/releases/?version=25
pause
exit /b 1

:oldjava
echo 지금 PATH 의 자바는 %JV% 입니다. 이 서버는 자바 25 이상이 필요합니다.
echo Adoptium 에서 Temurin 25(JDK 또는 JRE)를 받아 설치하세요. 설치할 때 PATH 에 추가를 켭니다.
echo https://adoptium.net/temurin/releases/?version=25
pause
exit /b 1
