@echo off
setlocal enabledelayedexpansion  

set Filter=Debug Release ipch *.sdf *.db *.sln *.vcxproj* .vs

for /r . %%a in (%Filter%) do (
  if exist %%a (
    echo "delete" %%a

    if exist %%a\ (
      rd /s /q "%%a"
    ) else (
      del "%%a"
    )	  
  )
)