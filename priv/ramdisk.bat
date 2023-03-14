@echo off

title "RAMdisk Handler"

SET mypath=%~dp0
echo %mypath:~0,-1%

GOTO imdisk

rem first check if we really need admin previliges
:imdisk
    WHERE imdisk >nul 2>&1 && (
        echo imdisk already installed
        GOTO ramdisk
    ) || (
        GOTO check_permissions
    )

:ramdisk
    IF exist R:\ (
        echo Ramdisk already exists
        GOTO end
    ) ELSE (
        GOTO check_permissions
    )

:check_permissions
    echo Administrative permissions needed, checking now...
    net session >nul 2>&1
    IF %errorLevel% == 0 (
      echo Success: Administrative permissions confirmed.
      GOTO menu
    ) ELSE (
      GOTO UACPrompt
    )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    rem SET params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"

    START /W cmd.exe /c "%temp%\getadmin.vbs"
    echo wait for it
    del "%temp%\getadmin.vbs"
    exit /B

:menu
    WHERE imdisk >nul 2>&1 && (
        echo imdisk already installed
    ) || (
        rem start /wait cmd /c %mypath%/ImDiskTk/install.bat /fullsilent
        call %mypath%/ImDiskTk/install.bat /fullsilent
        echo waiting for install to complete
        timeout /t 5 /nobreak
        WHERE imdisk >nul 2>&1 || (
          echo error installing imdisk
          goto end
        )
    )
    IF exist R:\ (
        echo Ramdisk exists
    ) ELSE (
        imdisk.exe -a -s 64M -m R: -p "/fs:ntfs /q /y" -P
    )
    call %mypath%/bootstrap.bat
    pause

:end
    exit /B
