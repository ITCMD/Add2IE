@echo off
set count32=0
if /i "%~1"=="" goto gui
if /i "%~1"=="File" goto file2
if /i "%~1"=="8437492749374GUI" goto gotGUI2
if /i "%~1"=="help" goto help
if /i "%~1"=="/?" goto help
if /i "%~1"=="-?" goto help
if /i "%~1"=="-help" goto help
net session >nul 2>nul
if %errorlevel%==0 goto continue
echo Administrative Access not found.
exit /b 7
:continue
if /i "%1"=="" echo Finished Proccessing %count32% domains.&exit /b
set /a count32+=1
echo Processing %~1 . . .
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v %~1 /t REG_DWORD /d 0 >nul
if %errorlevel%==0 (
    echo Success.
) ELSE (
    echo Operation Failed.]
)
goto continue




:gui
net session >nul 2>nul
if not %errorlevel%==0 goto GUI2
title ITCMD Website Truster (use paramaters to do automatically)
echo Enter Website to add to Trusted Sites:
echo Enter DONE to quit. Enter FILE to add a text document of domains to add.
set /p trust=">"
if /i "%trust%"=="DONE" exit /b
if /i "%trust%"=="FILE" goto file
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v %trust% /t REG_DWORD /d 2 >nul
if %errorlevel%==0 echo Success & pause & exit /b
echo Operation Was Unsuccessful.
pause
exit /b



:GUI2
echo Loading as Administrator . . .& cd>C:\users\Public\PST.txt & powershell start -verb runas '%0' 8437492749374GUI & exit /b
exit /b


:gotGUI2
set /p cdd=<C:\users\Public\PST.txt
cd %cdd%
title ITCMD Website Truster (use paramaters to do automatically)
echo Enter Website to add to Trusted Sites:
echo Enter DONE to quit. Enter FILE to add a text document of domains to add.
set /p trust=">"
if /i "%trust%"=="DONE" exit /b
if /i "%trust%"=="FILE" goto file
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v %trust% /t REG_DWORD /d 2 >nul
if %errorlevel%==0 echo Success & pause & goto gotGUI2
echo Operation Was Unsuccessful.
pause
goto gotGUI2


:file
cls
echo Enter path to File with list of sites.
set /p file=">"
if not exist %file% echo File not found & exit /b
echo.
setlocal EnableDelayedExpansion
for /f "usebackq" %%A in (%file%) do (
    reg query "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v "%%A" >nul 2>nul
	if !errorlevel!==1 (
	    reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v %%A /t REG_DWORD /d 2 >nul
	    if !errorlevel!==0 (
	        echo Success for %%A
	    ) ELSE (
	        echo Operation Was Unsuccessful for %%A.
	    )
	) ELSE (
	    echo Operation Was Unsuccessful for %%A. Value already exists.
	)
)
echo Finished.
pause
exit /b

:file2
net session >nul 2>nul
if %errorlevel%==0 goto continue2
echo Administrative Access not found.
exit /b 7
:continue2
set file=%2
if not exist %file% echo File not found & exit /b
echo.
setlocal EnableDelayedExpansion
for /f "usebackq" %%A in (%file%) do (
    reg query "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v "%%A" >nul 2>nul
	if !errorlevel!==1 (
	    reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v %%A /t REG_DWORD /d 2 >nul
	    if !errorlevel!==0 (
	        echo Success for %%A
	    ) ELSE (
	        echo Operation Was Unsuccessful for %%A.
	    )
	) ELSE (
	    echo Operation Was Unsuccessful for %%A. Value already exists.
	)
)
echo Finished.
exit /b

:help
echo Adds websites to trusted list in internet explorer.

echo call %~n0 [/?] [help] [website1 website2 website3...] [File] [File path]
echo.
echo  [/?] [help]    displays this.
echo                 Running this file without any attributes runs the GUI.
echo.
echo  [website]      adds the specified domain to the trusted site list. You can have any amount.
echo                 This option requires pre-given admin access.
echo.
echo  [File]         allows you to add a file with a list of sites to add.    
echo.
echo.
echo      EXAMPLES:
echo.
echo                 call %~n0 google.com itcommand.tech facebook.com
echo      This would add google.com, itcommand.tech and facebook.com to the trusted site list.
echo.
echo                 call %~n0 file "C:\users\My username\website list.txt"
echo      This would add any domains in the specified file (seperated by new lines).
echo.
echo.
echo      TIPS FOR USE:
echo.
echo             You can turn this file into a function and put it in a batch file by addding :Add2IE to the top of it.
echo             the you would use call :Add2IE instead of call %~n0
echo.
echo             You can ask for admin access inside your file by adding this to the top of your file:
echo.
echo net session ^>nul 2^>nul
echo if not %%errorlevel%%==0 (echo Loading as Administrator . . .^& cd^>C:\users\Public\TST.txt ^& powershell start -verb runas '%0' ^& exit /b)
echo set /p cdd=^<C:\users\Public\TST.txt
echo cd %%cdd%%
echo.
echo.
echo.
echo This program was created by Lucas Elliott with IT Command (www.itcommand.tech)
exit /b
