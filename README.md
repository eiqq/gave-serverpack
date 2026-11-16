# 게이브 서버(개조판)

마인크래프트 자바 26.3(바닐라 클라이언트)으로 들어오는 Paper 26.3 협동 웨이브 미니게임 '게이브'의 개조판 서버 구동기다. 사방에서 몰려오는 게이브를 총으로 막고, 트럭 상점에서 강해지며 35라운드를 건넌다.

- 원작: https://github.com/tinymita2-pixel/gave-server
- 개조한 소스: https://github.com/eiqq/gave-server 의 `overhaul` 브랜치(원작자에게 보낸 PR #1)

## 켜기

1. 자바 25 를 설치한다: https://adoptium.net/temurin/releases/?version=25 (설치할 때 PATH 에 추가를 켠다)
2. `run.bat` 을 두 번 누른다(리눅스, macOS 는 `./run.sh`).
   - 처음 켤 때 리소스팩(약 95MB)을 받아 `pack/` 에 둔다. Mojang EULA(https://aka.ms/MinecraftEULA)는 `eula.txt` 에 미리 동의해 두었다(이 서버를 켜면 그 계약에 동의하는 것).
   - 처음에는 Paper 가 Mojang 서버 파일을 받느라 1~2분 걸린다. 월드 `gave_plaza` 는 플러그인이 만든다.
   - 서버 설정 `server.properties` 는 처음 켤 때 `server.properties.default` 에서 복사된다. 고칠 때는 `server.properties` 를 고친다.
3. 다른 PC 에서 들어오게 하려면 공유기(포트 포워딩)와 방화벽에서 **25565**(게임)와 **8088**(팩 예비)을 이 PC 로 연다.
4. 마인크래프트 26.3 으로 `이 PC 주소:25565` 에 접속한다(같은 PC 면 `localhost`).

## 리소스팩

접속하는 사람은 리소스팩을 https://github.com/eiqq/danta-resourcepack 의 `gave` 브랜치(`gave_pack.zip`, 모습과 소리를 합친 팩 하나)에서 저절로 받는다. 서버는 `pack/Gave-pack.zip` 을 읽어 같은 파일인지 맞춰 보고, 다르거나 못 받으면 이 PC 의 8088 포트로 보낸다. 팩을 바꾸면 `run.bat` 과 `run.sh` 의 `PACK_URL`, `PACK_SHA1` 두 줄을 고친다.

## 운영자와 명령

서버 창에 `op 닉네임` 을 친다. 운영자만 `/gave` 명령을 쓴다.

| 명령 | 하는 일 |
|---|---|
| `/gave 시작` | 판 시작 |
| `/gave 중지` | 판을 멈추고 대기실로 |
| `/gave 상태` | 상태, 라운드, 남은 게이브 수 |
| `/gave 원정 [on\|off]` | 원정(트럭 상점, 길 투표) 켜고 끄기 |
| `/gave 다시하기` | 진 판이 끝나는 20초 동안 채팅의 다시 하기를 누른 것과 같음(진 라운드부터, 총과 증강 그대로) |
| `/gave 최대인원 <수>` | 서버 최대 인원(`/maxplayer <수>` 도 같음) |
| `/maxplayer <수>` | 최대 인원을 바로 바꾸고 설정에도 저장(= `/gave 최대인원 <수>`) |
| `/gave 팩` | 리소스팩 파일을 다시 읽어 모두에게 다시 보냄 |

## 들어 있는 것

- `server.jar`: Paper 26.3-231
- `plugins/Gave.jar`: 개조판 플러그인(위 소스의 `overhaul` 브랜치로 빌드)
- `plugins/Gave/config.yml`: 원작 실서버의 설정 값(난이도, 배율 등)
- `plugins/KAKC-2.0.0.jar`: 영어 자판으로 친 한글 자동 변환(원작 서버 꾸러미에 든 것)
- `datapack/gave_env`: 하늘, 안개, 비 같은 환경 데이터팩
- `server.properties.default`, `bukkit.yml`(월드 생성기), `spigot.yml`, `config/`

팬이 만든 비상업 서버이고 Mojang, Microsoft 와 관계없다. 팩에 든 것의 출처와 라이선스는 팩 맨 위 `CREDITS.txt` 에 있다.
