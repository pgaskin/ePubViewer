@echo off
cd App
mkdir data 2>&1
start ePubViewer.exe --user-data-dir="%CD%/data"