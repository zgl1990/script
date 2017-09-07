@echo off
setlocal enabledelayedexpansion

rem ------------------------------------------------------------------------------
echo "Error When Replace Fileds!"
exit /b
rem ------------------------------------------------------------------------------

set absolutePath="%1"

if exist %absolutePath%\ (
	goto :error %absolutePath% Exist!
)

md %absolutePath%

set sourcePath="F:\galen\ProjectsTemplate\NewAppTemplate2\*.*"
pushd %absolutePath%
xcopy %sourcePath% . /s/q

for %%a in (%absolutePath%) do set project=%%~nxa

set dateValue=%date:~,10%
set timeValue=%time:~,8%
set authorValue=Galen
set projectLowerValue=!project!

call ::renameDF @D{PROJ_NAME} !project!
call ::renameDF @D{PROJ_NAME_LOWER} !projectLowerValue!

set Fileds="@D{PROJ_NAME} @D{PROJ_NAME_LOWER} @D{DATE} @D{TIME} @D{AUTHOR}"

for /r %%i in (*) do (
    findstr %Fileds% %%i > nul && (
rem		set content=^&type %%i
rem		for /f "tokens=*" %%a in (%%i) do (
		for /f "delims=" %%a in ('type %%i') do (
rem bug
			set content=%%a
			set "content=!content:@D{PROJ_NAME}=%project%!"
			set "content=!content:@D{PROJ_NAME_LOWER}=%projectLowerValue%!"
			set "content=!content:@D{DATE}=%dateValue%!"
			set "content=!content:@D{TIME}=%timeValue%!"
			set "content=!content:@D{AUTHOR}=%authorValue%!"
			echo !content! >> %%i_tmp_bak
		)
		
		if exist %%i_tmp_bak (
			move %%i_tmp_bak %%~pi%%~nxi
		)
	)
)

echo make project success! %cd%

popd
exit /b

:error
(
	set ErrorCode=%errorlevel%
	if !ErrorCode! neq 0 (
	    echo Error !ErrorCode! %1
	)
	exit /b !ErrorCode!
)

:renameDF
(
	for /R %%s in (*%1*) do (
		set newfilename=%%~nxs
		set "newfilename=!newfilename:%1=%2!"
		ren %%s !newfilename!
	)
	goto :error
)