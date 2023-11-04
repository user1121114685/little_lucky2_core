copy ./alist/diy/diy.go diy.bak /y
cd %~dp0alist
git fetch --all
git reset --hard origin/main
git pull
go mod tidy
for /F %%i in ('git rev-parse --short HEAD') do ( set commitid=%%i)
echo commitid=%commitid%

cd %~dp0
go mod tidy
:: 将创建的网盘全部设置为 web代理等true
go run ..\diy\main.go

rd /s /Q %~dp0alist\public\dist
PowerShell -Command "& wget https://github.com/alist-org/alist-web/releases/latest/download/dist.zip -o ./dist.zip"
"C:\Program Files\7-Zip-Zstandard\7z.exe" x dist.zip -o%~dp0alist\public -aoa
del dist.zip
SET GOARCH=amd64
SET GOOS=windows
SET CGO_ENABLED=1
go build -ldflags "-s -w -X mian.AlistCommit=%commitid%" -buildmode=c-shared -o ../libcore.dll


SET ANDROID_NDK_HOME=I:\android-ndk-r26b\toolchains\llvm\prebuilt\windows-x86_64\bin
SET output=%~dp0..\android\app\src\main\jniLibs

rd /s /Q %output%
SET GOARCH=arm
SET GOOS=android
SET CGO_ENABLED=1
SET CC=%ANDROID_NDK_HOME%/armv7a-linux-androideabi24-clang
go build  -ldflags="-s -w -X mian.AlistCommit=%commitid%" -buildmode=c-shared -o %output%/armeabi-v7a/libcore.so

SET GOARCH=arm64
SET GOOS=android
SET CGO_ENABLED=1
SET CC=%ANDROID_NDK_HOME%/aarch64-linux-android24-clang
go build -ldflags="-s -w -X mian.AlistCommit=%commitid%" -buildmode=c-shared -o %output%/arm64-v8a/libcore.so



