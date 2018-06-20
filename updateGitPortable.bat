@ECHO OFF
cls

echo "Starting Git Portable upgrade process"
:GITRUNNING
tasklist | find /i "mintty.exe" >nul 2>&1
IF ERRORLEVEL 1 (
  GOTO GITUPDATE
) ELSE (
  cls
  ECHO Git cannot be updated while running.
  Timeout /t 5 /Nobreak
  GOTO GITRUNNING
)

:GITUPDATE
echo "No mintty process found.  Proceeding"
Timeout /t 3 /Nobreak

set drive=%CD:~0,3%
move %drive%PortableApps\GitPortable\App\Git %drive%PortableApps\GitPortable\App\Git-old
Timeout /t 3 /Nobreak
move %drive%tmp\GitUpdate %drive%PortableApps\GitPortable\App\Git