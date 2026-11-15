#!/bin/sh
# 게이브 서버 켜기(리눅스, macOS). 끌 때는 stop 을 입력한다.
cd "$(dirname "$0")" || exit 1

if ! command -v java >/dev/null 2>&1; then
  echo "자바를 찾지 못했습니다. 이 서버는 자바 25 가 필요합니다: https://adoptium.net/temurin/releases/?version=25"
  exit 1
fi
JV=$(java -version 2>&1 | awk -F'"' '/version/ {print $2; exit}')
JMAJOR=$(echo "$JV" | cut -d. -f1 | cut -d- -f1 | cut -d+ -f1)
case "$JMAJOR" in ''|*[!0-9]*) JMAJOR=0 ;; esac
if [ "$JMAJOR" -lt 25 ]; then
  echo "지금 자바는 $JV 입니다. 이 서버는 자바 25 이상이 필요합니다: https://adoptium.net/temurin/releases/?version=25"
  exit 1
fi

if command -v ss >/dev/null 2>&1 && ss -ltn 2>/dev/null | grep -q ':25565 '; then
  echo "25565 포트를 이미 다른 프로그램이 쓰고 있습니다. 다른 서버를 끄고 다시 켜 주세요."
  exit 1
fi

[ -f server.properties ] || cp server.properties.default server.properties

# 리소스팩: github eiqq/danta-resourcepack 의 gave 브랜치. 서버가 이 파일을 읽고, 접속자에게는 이 주소를 보낸다
PACK_URL="https://raw.githubusercontent.com/eiqq/danta-resourcepack/2c4d194197f36a4fa369833ea507b44d27bdeea4/gave_pack.zip"
PACK_SHA1="e1b9abedf352d5b3529b1f9cc66998bf72d6dac9"
mkdir -p pack
HAVE=""
if [ -f pack/Gave-pack.zip ]; then
  if command -v sha1sum >/dev/null 2>&1; then HAVE=$(sha1sum pack/Gave-pack.zip | cut -d' ' -f1)
  else HAVE=$(shasum -a 1 pack/Gave-pack.zip | cut -d' ' -f1); fi
fi
if [ "$HAVE" != "$PACK_SHA1" ]; then
  echo "리소스팩을 받습니다. 약 95MB 라 조금 걸립니다."
  curl -fL --retry 3 -o pack/Gave-pack.zip "$PACK_URL" || { echo "리소스팩을 받지 못했습니다: $PACK_URL"; exit 1; }
fi

echo "게이브 서버를 25565 포트로 켭니다. 끌 때는 stop 을 입력하세요."
exec java -Xms2G -Xmx4G -Dfile.encoding=UTF-8 -Dspark.backgroundProfiler=false -Dgave.packPort=8088 -Dgave.packUrl="$PACK_URL" \
  -Dgave.packDir=pack -Dgave.datapackDir=datapack/gave_env \
  -jar server.jar --nogui
