@echo off
title Compile Payload

:: Pyinstaller Verbose Console
pyinstaller --onefile --noconsole firmware_update.py

echo.
echo Press Enter to close...
pause >nul


REM echo       __    __   _______  __       __        ______   
REM echo      |  |  |  | |   ____||  |     |  |      /  __  \  
REM echo      |  |__|  | |  |__   |  |     |  |     |  |  |  | 
REM echo      |   __   | |   __|  |  |     |  |     |  |  |  | 
REM echo      |  |  |  | |  |____ |  `----.|  `----.|  `--'  | 
REM echo      |__|  |__| |_______||_______||_______| \______/  
REM echo.
REM echo.	cringy text and lil'hackerman brought to you by: Blake Sando
REM echo.
REM echo                 /^^^^^^^^^^^^^^^^^\      
REM echo                |   [ O ]    [ O ]  |     
REM echo                |      ___         |      
REM echo                |    \_____/       |     
REM echo                 \_________________/      
REM echo                     ||     ||          
REM echo                  __||_____||__        
REM echo                 (____|___|____)       
REM echo.

