@ECHO OFF
:: CleanForCheckIn.cmd
:: Clear out folders and files not wanted in the repository.
SET SOURCE=%~dp0
:: Does the string have a trailing slash? if so remove it 
IF %SOURCE:~-1%==\ SET SOURCE=%SOURCE:~0,-1%
FOR /d %%d IN ("%SOURCE%\*") DO (
	IF EXIST "%SOURCE%\%%~nxd\%%~nxd\bin" (
		ECHO Scrub "%SOURCE%\%%~nxd\%%~nxd\bin"
		DEL /Q /S "%SOURCE%\%%~nxd\%%~nxd\bin\*.*"
		RMDIR /Q /S "%SOURCE%\%%~nxd\%%~nxd\bin\"
	)
	IF EXIST "%SOURCE%\%%~nxd\%%~nxd\obj" (
		ECHO Scrub "%SOURCE%\%%~nxd\%%~nxd\obj"
		DEL /Q /S "%SOURCE%\%%~nxd\%%~nxd\obj\*.*"
		RMDIR /Q /S "%SOURCE%\%%~nxd\%%~nxd\obj\"
	)
)
