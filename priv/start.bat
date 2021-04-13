@echo off
if exist "Z:\" (
  echo Disk exists at Z:\, this will be used as a filesystem for many reads and writes
) else (
  echo Please create a ramdisk with drive letter Z: using ImDisk from https://sourceforge.net/projects/imdisk-toolkit/
  exit
)
echo Also add "-exec chatur/startup" as a launch option for CS:GO
if exist demo\ (
  echo Already extracted here
) else (
  echo Extracting, please do not modify the path
  demo
  mkdir demo\bin\external\
  copy demo\lib\chatur-0.1.0\priv\external\ demo\bin\external\
  copy demo\lib\chatur-0.1.0\priv\bootstrap.bat demo\bin\
  copy demo\lib\chatur-0.1.0\priv\startup.cfg demo\bin\
  powershell.exe -Command "Start-Process cmd \"/c %cd%\demo\bin\bootstrap.bat\" -Verb RunAs"
)
taskkill /T /F /IM erl.exe
cd demo\bin\ & demo start
