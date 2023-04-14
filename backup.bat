@REM
@REM 
@REM This is a DOS batch file that, when executed, will
@REM back up CERTAIN folders to the Kingston USB drive, which normally
@REM when installed on this computer is referred to as drive G.
@REM
@REM
@REM However, you can set the following variable to a different letter if
@REM you know that the drive that you are backing up to happens to be 
@REM different than the letter G (you can determine which letter the USB
@REM thumb/flash drive is by looking at it in windows file explorer).  But
@REM be sure you know what you are doing and are certain that the letter is correct
@REM for what you are doing.
@REM
@REM Note that when you see a line in this script that is prefaced with the
@REM "@REM", it is a comment and therefore does not get executed, it is just
@REM informational.
@REM
SET VERSION=1
SET /A TOTAL_DISK_SIZE_NEEDED=0

@REM
@REM First set this variable as the letter that represents your USB drive, which,
@REM normally ON THIS COMPUTER, this is usually the letter G, but you can
@REM change this here IF YOU KNOW WHAT YOU ARE DOING
SET USB_DRIVE_LETTER=G

@REM
@REM Next, this is the name of the user account (folder) from which we are going
@REM to save.  For this script, we assume that the account name is Office (yes,
@REM I agree that is a weird user account name, but eh). So you can change this
@REM variable if you know what you are doing.
SET USER_NAME=Office

@REM
@REM Next, this is the alias/name for the computer that we use to save to on
@REM the usb drive, in case you want to use this script for another computer
@REM you can change this variable name and have the backup from another computer
@REM saved to a different folder on the usb drive
SET COMPUTER_NAME=Computer1

@ECHO Hello I am about to backup stuff to the USB drive (%USB_DRIVE_LETTER%)...
@ECHO Backup script version (%VERSION%)
@ECHO For the computer (%COMPUTER_NAME%)
@ECHO And for the user (%USER_NAME%)
@REM @ECHO Please press a key to start! 
@PAUSE
@ECHO Thank you, starting backup now... 

@REM ***************************
@REM  Backup Documents
@REM ***************************
SET TARGET_DIR="%USB_DRIVE_LETTER%:\Backup\%COMPUTER_NAME%\%USER_NAME%\Documents"
if not exist %TARGET_DIR% mkdir %TARGET_DIR%
CALL :FUNCTION_FOLDER_SIZE C:\users\%USER_NAME%\Documents
xcopy /D /S /E /C /I /Y "C:\users\%USER_NAME%\Documents" %TARGET_DIR% || goto :ERROR


@REM ***************************
@REM  Backup Desktop
@REM ***************************
SET TARGET_DIR="%USB_DRIVE_LETTER%:\Backup\%COMPUTER_NAME%\%USER_NAME%\Desktop"
if not exist %TARGET_DIR% mkdir %TARGET_DIR%
CALL :FUNCTION_FOLDER_SIZE C:\users\%USER_NAME%\Desktop
xcopy /D /S /E /C /I /Y "C:\users\%USER_NAME%\Desktop" %TARGET_DIR% || goto :ERROR


@REM ***************************
@REM  Backup Quickbooks
@REM ***************************
SET TARGET_DIR="%USB_DRIVE_LETTER%:\Backup\%COMPUTER_NAME%\%USER_NAME%\Quickbooks"
if not exist %TARGET_DIR% mkdir %TARGET_DIR%
CALL :FUNCTION_FOLDER_SIZE C:\Quickbooks
xcopy /D /S /E /C /I /Y "C:\Quickbooks" %TARGET_DIR% || goto :ERROR

@REM ***************************
@REM  DONE !
@REM ***************************
@ECHO ... SUCCESSFULLY Done backing up, hit a key to exit!
pause
GOTO :EXIT

@REM ***************************
@REM  ERROR FUNCTION
@REM ***************************
@REM Code at this label (":ERROR") will get called if any of the above
@REM copy commands hork out, otherwise this code is not called, think of
@REM it like a subroutine.  Looks complicated, but its just printing out
@REM details about the error.
:ERROR
@echo off 
@ECHO ********************************************************************
@ECHO  E R R O R     E R R O R    E R R O R     E R R O R 
@ECHO HORKAGE !!! AN ERROR OCCURRED AND BACKUP MAY NOT BE COMPLETE
@ECHO Please take a screen shot!
@ECHO When calling IT support, please take a screen shot of this error!!!
@ECHO OFF
@ECHO There was an error when running the betterbackup.bat script.
@ECHO The script is located at: C:/users/office/desktop/betterbackup.bat
@ECHO The script assumes there is a USB drive installed.  
@ECHO My USB drive's letter is one of these:
for /F "skip=1 tokens=1-10" %%A IN ('wmic logicaldisk get description^, deviceid')DO (
   if "%%A %%B" == "Removable Disk" (
      @echo USB Disk %%C
   )
)
@ECHO The USB drive letter being used by the script is:
@ECHO %USB_DRIVE_LETTER%
@ECHO The User folder being used by the script is:
@ECHO %USER_NAME%
@ECHO 
@ECHO When I run the script, the following error is reported: (insert the error message here)
@ECHO  E R R O R     E R R O R    E R R O R     E R R O R   
@ECHO ********************************************************************
@ECHO Now please hit a key to exit
pause
GOTO :EXIT


@REM ***************************
@REM  Folder Size Function
@REM ***************************
@REM This code is a callable function.
@REM Compute the approx size of a folder
@REM Inputs: name of a folder
@REM Outputs: RET_VAL_SIZE, approx size of the folder,
@REM as an string
@REM Example usage:
@REM CALL :FUNCTION_FOLDER_SIZE some_folder_name
@REM ECHO The size of folder some_folder_name is: %RET_VAL_SIZE%
:FUNCTION_FOLDER_SIZE
@ECHO OFF
setlocal enableextensions enableDelayedExpansion
set "size=0"
    set "last=#"
    set "pre_last=#"
    rem set "pre_pre_last=#"
    for /f "tokens=3" %%a in ('
        dir /a:-d /s /w /-c "%~1"  
    ') do  (

        set "pre_last=!last!"
        set "last=%%a"
    )
    @REM note, set RET_VAL_SIZE to an integer
    SET RET_VAL_SIZE=!pre_last!
    
    echo DEBUG Size of %~1 is roughly %RET_VAL_SIZE%
    @REM return from function
    EXIT /B 0

@REM ***************************
@REM  Exit the script
@REM ***************************
@REM Code at this label (":EXIT") is executed at the end
:EXIT
@ECHO Buh Bye!
