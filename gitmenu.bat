echo off
REM --------------------------------------------------------------------------------------------
REM This is a front-end script for GIT on a development machine
REM --------------------------------------------------------------------------------------------
SETLOCAL enabledelayedexpansion
REM --------------------------------------------------------------------------------------------
REM Set these for your local machine:
REM     BASE = Here (where this script resides)
REM     PROJ = where your projects reside 
REM --------------------------------------------------------------------------------------------
SET BASE_DRIVE=C:
SET BASE_DIR=\Users\Kim Kitchen\Documents
SET PROJ_DRIVE=Z:
SET PROJ_DIR=Documents\workspace
REM --------------------------------------------------------------------------------------------
REM Set Base URL on GitHub (Where GitHub stores your projects)
SET GIT_URL=https://github.com/kim-cloudconversion
REM --------------------------------------------------------------------------------------------
SET PROJECT=
SET FOLDER=
SET USER=
SET PASS=
SET GITPATH=
SET INI_FILE=gitmenu.ini
SET OLDDIR=%CD%
SET REPO=origin
SET DEBUG=1


REM --------------------------------------------------------------------------------------------
rem -- Read the ini file into variables --
FOR /F "tokens=1,2 delims==" %%G IN (%INI_FILE%) DO if NOT "%G%" == "#" SET %%G=%%H
if DEFINED LAST_PROJECT call:SELECT2 %LAST_PROJECT%
REM --------------------------------------------------------------------------------------------

:MENU
  call:CLEAR
  echo   Choose a Saved Project
  for /l %%x in (1, 1, 10) do if DEFINED PROJECT%%x call:SHOWVALUE %%x PROJECT%%x
  echo.
  echo   N) Create a New Project
  echo   D) Delete an Existing Project

  echo   Q) Quit this menu (I'm So Done Here, I Can't Even ...)
  echo +----------------------------------------------------------------------------+
  set /P OPT1=Please Select -^>
  rem echo You chose '%OPT1%'
  if "%OPT1%" == "n" GOTO ADD1
  if "%OPT1%" == "d" call:DELETE1
  if "%OPT1%" == "z" call:DEBUG1

  if "%OPT1%" == "q" GOTO DONE
  if "%OPT1%" == "Q" GOTO DONE

  REM the FOLDER function takes 3 arguments: Foldername, remote_repo, remote_alias
  
  if not DEFINED PROJECT%OPT1% echo Sorry, '%OPT1%' is not a valid selection.
  if DEFINED PROJECT%OPT1% call:SELECT2 %OPT1%
  if DEFINED PROJECT call:FOLDER %PROJECT% %FOLDER% %REPO%
  rem pause
  GOTO MENU
REM ############################################################################################
:
REM ############################################################################################
:SELECT2
  SET PROJECT=!PROJECT%1%!
  SET FOLDER=!FOLDER%1%!
  SET USER=!USER%1%!
  SET PASS=!PASS%1%!
  SET GITPATH=!GITPATH%1%!
  rem echo Project '%PROJECT%' Selected.
  SET LAST_PROJECT=%1%
  exit /b
REM ############################################################################################
:FOLDER REM requires 3 argument: FolderName, RemoteRepositoryName, RemoteAlias
  set REPO=%3
  call:CLEAR
  echo   Selected Project: %PROJECT%
  echo +----------------------------------------------------------------------------+
  echo.
  echo   A) Add ALL files to %PROJECT%'s GitHub Index
  echo   O) Add ONE File to %PROJECT%'s GitHub Index
  echo   C) Commit changed files to local %PROJECT%'s repository
  echo   P) PUSH local %PROJECT% repository up to GitHub
  echo   L) PULL local %PROJECT% repository down from GitHub
  echo   R) Refresh %PROJECT% from Github Remote repository
  echo   B) Branch - Change local files to a specific branch
  echo   S) Show Status (Files changed, not committed)
  echo   E) Edit This Projects Properties
  echo   U) Update Remote Settings 
  echo.
  echo   Q) Quit (return to main menu)
  echo.
  echo +----------------------------------------------------------------------------+
  set /p OPT2=Please Select -^>
  if "%OPT2%" == "a" call:ADD_ALL %1
  if "%OPT2%" == "o" call:ADD_ONE %1
  if "%OPT2%" == "c" call:COMMIT %1
  if "%OPT2%" == "p" call:PUSH %1 %2
  if "%OPT2%" == "l" call:PULL %1 %2
  if "%OPT2%" == "r" call:REFRESH %1 %2
  if "%OPT2%" == "b" call:BRANCH %1 
  if "%OPT2%" == "s" call:STATUS %1
  if "%OPT2%" == "e" call:EDIT1
  if "%OPT2%" == "u" call:UPDATE
  rem if "%OPT2%" == "d" call:DELETE1

  if "%OPT2%" == "q" exit /b
  GOTO FOLDER
REM ############################################################################################
:ADD_ALL
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%FOLDER%
  rem echo %CD%
  git add --all
  %BASE_DRIVE%
  cd %BASE_DIR%
  pause
  GOTO eof
REM ############################################################################################
:ADD_ONE
  set /p FILE=Please Enter a Filename (relative to %1%) -^>
  if "%FILE%" == "" GOTO eof
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%FOLDER%
  git add %FILE%
  %BASE_DRIVE%
  cd %BASE_DIR%
  pause
  GOTO eof
REM ############################################################################################
:COMMIT
  echo Commit Changes to %PROJECT% ...
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%FOLDER%
  echo Please enter your descriptive Commit Message
  set /p MESG=-^>
  git commit -a -m "%MESG%"
  %BASE_DRIVE%
  cd %BASE_DIR%
  pause
  GOTO eof
REM ############################################################################################
:PUSH
  set /p YN=Are you SURE you want to PUSH %PROJECT% up to GitHub (y/n) ?
  if not "%YN%" == "y" GOTO eof
  echo.
  echo D) Development Branch
  echo M) Master Branch
  echo.
  set BRANCH=""
  set /p B=Select Branch to PUSH to -^>
  if "%B%" == "d" set BRANCH=development
  if "%B%" == "m" set BRANCH=master
  if "%BRANCH%" == "" goto eof
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%FOLDER%
  git push --tags %REPO% HEAD:%BRANCH%
  %BASE_DRIVE%
  cd %BASE_DIR%
  pause  
  GOTO eof
REM ############################################################################################
:PULL
  set /p YN=Are you SURE you want to PULL %PROJECT% down from GitHub (y/n) ?
  if not "%YN%" == "y" GOTO eof
  echo.
  echo D) Development Branch
  echo M) Master Branch
  echo.
  set BRANCH=""
  set /p B=Select Branch to PULL from -^>
  if "%B%" == "d" set BRANCH=development
  if "%B%" == "m" set BRANCH=master
  if "%BRANCH%" == "" goto eof
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%FOLDER%
  git pull --tags %REPO% %BRANCH%
  %BASE_DRIVE%
  cd %BASE_DIR%
  pause  
  GOTO eof
REM ############################################################################################
:BRANCH
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%FOLDER%
  git branch
  set /p BRANCH=Enter Branch to switch to -^>
  git checkout %BRANCH%
  %BASE_DRIVE%
  cd %BASE_DIR%
  GOTO eof 
REM ############################################################################################
:REFRESH
  REM This function expects 2 arguments: 1=Foldername, 2=Repositoryname
  echo -------------------------------------------------------------------------------
  echo This routine will DELETE the %FOLDER% folder from your machine
  echo and then Re-Create it from the GitHub %PROJECT% repository
  echo.
  set /P YN=Are you SURE you want to DELETE/Re-Create '%PROJECT%' (y/n) ? -^>
  if NOT "%YN%" == "y" exit /b
  echo.
  echo Select a GIT Branch to pull from:
  echo.
  echo D) 'Development' Branch
  echo M) 'Master' Branch
  echo Q) Quit (Cancel)q
  echo. 
  set /p B=Please Select Branch -^>
  echo You chose %B%
  if "%B%" == "q" GOTO eof
  if "%B%" == "d" set BRANCH=development
  if "%B%" == "m" set BRANCH=master
  if "%B%" == "" set BRANCH=development
  echo Branch is set to '%BRANCH%'
  echo Deleting %1 Folder ...
  %PROJ_DRIVE%
  cd \%PROJ_DIR%
  rmdir /s /q %1%
  del /s /f /q %1%
  echo Re-Creating %1% Folder ...
  mkdir %1%
  echo Initializing GIT Repository in %1% ...
  cd %1
  git init
  echo Adding remote entry for GitHub
  git remote add %REPO% https://github.com/PerformanceDepot/%2%.git
  echo Pulling %1% from GitHub ...
  REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  REM I can't seem to figure out why the variable %BRANCH is not working in the 'git pull'
  REM so I'm trying creating the complete command in one variable
  set URL=https://customh2:DoIKnow2#@github.com/PerformanceDepot/%2.git
  echo URL=%URL%
  REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  git pull %URL% %BRANCH%
  echo setting 'full control' permissions for 'Everyone'
  icacls "%PROJ_DRIVE%\%PROJ_DIR%\%1"  /grant Everyone:(OI)(CI)F
  %BASE_DRIVE%
  cd %BASE_DIR%
  echo -------------------------------------------------------------------------------
  echo %PROJECT% has been Re-Created !
  pause
  exit /b
REM ############################################################################################
:STATUS
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%1%
  git status
  %BASE_DRIVE%
  cd %BASE_DIR%
  pause
  exit /b
REM ############################################################################################
:SHOWVALUE
  SET G=!%2!
  echo   %1) %G%
  exit /b
REM ############################################################################################
:EDIT1
  call:CLEAR
  echo Editing %PROJECT% Project Properties ...
  echo +----------------------------------------------------------------------------+
  echo Project Name: %PROJECT%
  SET /p VAL1=Please Enter Project Name -^>
  if not "%VAL1%" == "" SET PROJECT=%VAL1%
  echo Project Folder: %FOLDER%
  SET /p VAL2=Please Enter Project Folder -^>
  if not "%VAL2%" == "" SET FOLDER=%VAL2%
  echo GIT Username: %USER%
  SET /p VAL3=Please Enter GIT Username -^>
  if not "%VAL3%" == "" SET USER=%VAL3%
  echo GIT Password:    %PASS%
  SET /p VAL4=Please Enter GIT Password -^>
  if not "%VAL4%" == "" SET PASS=%VAL4%
  echo GIT Path:    %GITPATH%
  SET /p VAL5=Please Enter GIT Path -^>
  if not "%VAL5%" == "" SET GITPATH=%VAL5%
  SET /p YN=Save These Changes (Y/N) ? -^>
  if "%YN%" == "y" CALL:SAVE2	
  exit /b
REM ############################################################################################
:SAVE1
  SET NEXT=
  for /l %%x in (1, 1, 10) do if NOT DEFINED PROJECT%%x call:GETNEXT %%x
  if "%DEBUG%" == "1" echo Next Project Index = %NEXT%
  SET LAST_PROJECT=%NEXT%
  goto SAVE2

REM ############################################################################################
:GETNEXT
  if "%NEXT%" == "" SET NEXT=%1%
  rem echo GETNEXT - Index=%1%, NEXT='%NEXT%'
  exit /b
REM ############################################################################################
:SAVE2
  if "%DEBUG%" == "1" echo SAVE2: LAST_PROJECT = %LAST_PROJECT%
  
  SET PROJECT%LAST_PROJECT%=%PROJECT%
  SET FOLDER%LAST_PROJECT%=%FOLDER%
  SET USER%LAST_PROJECT%=%USER%
  SET PASS%LAST_PROJECT%=%PASS%
  SET GITPATH%LAST_PROJECT%=%GITPATH%
  
  call:INI_HEADER
  for /l %%x in (1, 1, 10) do if DEFINED PROJECT%%x call:SAVE3 %%x
  rem echo LAST_PROJECT=%LAST_PROJECT%>> %INI_FILE%
  echo %INI_FILE% Written !
  pause
  exit /b
REM ############################################################################################
:SAVE3
  if "%DEBUG%" == "1" echo SAVE3: Saving Project #%1% ...
  echo #= Project %1 ----------------------->> %INI_FILE%
  SET P=PROJECT%1%
  echo %P%=!%P%!>> %INI_FILE%
  SET P=FOLDER%1%
  echo %P%=!%P%!>> %INI_FILE%
  SET P=USER%1%
  echo %P%=!%P%!>> %INI_FILE%
  SET P=PASS%1%
  echo %P%=!%P%!>> %INI_FILE%
  SET P=GITPATH%1%
  echo %P%=!%P%!>> %INI_FILE%
  exit /b
REM ############################################################################################
:ADD1
  echo Add a New Project ...
  SET /p VAL1=Please Enter Project Name -^>
  if not "%VAL1%" == "" SET PROJECT=%VAL1%
  SET /p VAL2=Please Enter Project Folder -^>
  if not "%VAL2%" == "" SET FOLDER=%VAL2%
  SET /p VAL3=Please Enter GIT Username -^>
  if not "%VAL3%" == "" SET USER=%VAL3%
  SET /p VAL4=Please Enter GIT Password -^>
  if not "%VAL4%" == "" SET PASS=%VAL4%
  SET /p VAL5=Please Enter GIT Path -^>
  if not "%VAL5%" == "" SET GITPATH=%VAL5%
  SET /p YN=Save These Changes (Y/N) ? -^>
  if "%YN%" == "y" GOTO ADD2
  echo New Project NOT Saved !
  pause
  GOTO MENU	
REM ############################################################################################
:ADD2
  SET V=!%1%! 
  if "%V%" == "%PROJECT%" GOTO ADD3
REM ############################################################################################
:ADD3
  rem Step 1) Save the new project in the ini file  
  call:SAVE1

  rem Step 2) Try to 'CD' into the new projects folder
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%FOLDER%

  rem Step 3) If we're NOT standing in the correct folder then we need to create it
  if /I "%PROJ_DRIVE%\%PROJ_DIR%\%FOLDER%" == "%CD%" GOTO ADD5
  if "%DEBUG%" == "1" echo Current Directory: %CD%
  echo Project Folder '%PROJ_DRIVE%\%PROJ_DIR%\%FOLDER%' Does Not Exist.
  SET /p YN=Do you want to Create This Folder (Y/N) ? -^>
  if "%YN%" == "y" GOTO ADD4

  REM We chose NOT to create the new folder
  echo OK, after you create the folder don't forget to run the following commands:
  echo git init
  echo git remote add %REPO% https://github.com/%GITPATH%/%PROJECT%.git
  pause
  GOTO MENU
REM ############################################################################################
:ADD4
  mkdir \%PROJ_DIR%\%FOLDER%
  cd \%PROJ_DIR%\%FOLDER%
  rem falls into ADD5
REM ############################################################################################
:ADD5
  git init
  echo Adding remote entry for GitHub
  git remote add %REPO% https://github.com/%GITPATH%/%PROJECT%.git
  echo setting 'full control' permissions for 'Everyone'
  icacls "%PROJ_DRIVE%\%PROJ_DIR%\%FOLDER%"  /grant Everyone:(OI)(CI)F
  echo New Project %PROJECT% Created !
  pause
  GOTO MENU
REM ############################################################################################
:DELETE1
  echo --------------------------------------------
  echo Current Project: %PROJECT%
  echo --------------------------------------------
  echo Delete a project ...

  for /l %%x in (1, 1, 10) do if DEFINED PROJECT%%x call:SHOWVALUE %%x PROJECT%%x
  echo.
  echo Q) Quit without deleting
  echo.
  SET /p OPT3=Please Select -^>
  if "%OPT3%" == "q" GOTO MENU
  if not DEFINED PROJECT%OPT3% echo Sorry, '%OPT3%' is not a valid selection.
  if DEFINED PROJECT%OPT3% call:DELETE2 %OPT3%
  pause
  exit /b
REM ############################################################################################
:DELETE2
  SET P=PROJECT%1%
  SET /p YN=Are you SURE you want to DELETE Project !%P%! (Y/N) -^>
  if "%YN%" NEQ "y" exit /b
  SET TO_DELETE=%1%
  SET NEXT=1
  call:INI_HEADER
  for /l %%x in (1, 1, 10) do if DEFINED PROJECT%%x call:DELETE3 %%x 
  if [%TO_DELETE%] == [%LAST_PROJECT%] SET LAST_PROJECT=1
  rem echo LAST_PROJECT=%LAST_PROJECT%>> %INI_FILE%
  SET PROJECT%NEXT%=
  SET FOLDER%NEXT%=
  SET USER%NEXT%=
  SET PASS%NEXT%=
  SET PROJECT=
  SET FOLDER=
  SET USER=
  SET PASS=
  SET GITPATH=

  exit /b
REM ############################################################################################
:DELETE3
  if "%DEBUG%" == "1" echo DELETE3 - THIS='%1' - NEXT='%NEXT%' = TO_DELETE='%TO_DELETE%'
  if [%1] EQU [%TO_DELETE%] exit /b
  echo #= Project %NEXT% ----------------------->> %INI_FILE%
  SET P=PROJECT%1%
  echo PROJECT%NEXT%=!%P%!>> %INI_FILE%
  SET PROJECT%NEXT%=!%P%!
  SET P=FOLDER%1%
  echo FOLDER%NEXT%=!%P%!>> %INI_FILE%
  SET FOLDER%NEXT%=!%P%!
  SET P=USER%1%
  echo USER%NEXT%=!%P%!>> %INI_FILE%
  SET USER%NEXT%=!%P%!
  SET P=PASS%1%
  echo PASS%NEXT%=!%P%!>> %INI_FILE%
  SET PASS%NEXT%=!%P%!
  SET /a "NEXT+=1"
  
  rem pause
  exit /b
REM ############################################################################################
:UPDATE
  %PROJ_DRIVE%
  cd \%PROJ_DIR%\%FOLDER%
  if "%DEBUG%" == "1" echo Current Directory: %CD%
  git remote remove %REPO%
  git remote add %REPO% https://github.com/%GITPATH%/%PROJECT%.git
  %BASE_DRIVE%
  cd %BASE_DIR%
  pause
  exit /b
  
REM ############################################################################################
:INI_HEADER
  for /F "tokens=2" %%i in ('date /t') do set mydate=%%i
  set mytime=%time%
  echo #= %INI_FILE% - %mydate% %mytime% - Saved Projects for ini_test script > %INI_FILE%
  echo BASE_DRIVE=%BASE_DRIVE%>> %INI_FILE%
  echo BASE_DIR=%BASE_DIR%>> %INI_FILE%
  echo PROJ_DRIVE=%PROJ_DRIVE%>> %INI_FILE%
  echo PROJ_DIR=%PROJ_DIR%>> %INI_FILE%
  exit /b
REM ############################################################################################
:CLEAR
  cls
  echo +----------------------------------------------------------------------------+
  echo ^| gitmenu.bat - V1.00a - GIT Frontend Menu for Local Development             ^|
  echo +----------------------------------------------------------------------------+
exit /b
REM ############################################################################################
:DEBUG1
  if "%DEBUG%" == "0" GOTO DEBUG2
  SET DEBUG=0
  echo Debug Mode Disabled !
  pause
  exit /b
REM ############################################################################################
:DEBUG2
  SET DEBUG=1
  echo Debug Mode Enabled !
  pause
  exit /b
REM ############################################################################################
:DONE
  echo Thank-you for using gitmenu
  pause

