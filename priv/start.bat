if exist demo\ (
  echo Already extracted here
) else (
  echo Extracting, please do not modify the path
  demo
  powershell.exe -Command "Start-Process cmd \"/c %cd%\demo\bin\bootstrap.bat\" -Verb RunAs"
)
taskkill /T /F /IM erl.exe
cd demo\bin\ & demo start
