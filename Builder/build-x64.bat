@echo off
set "PATH=%CD%\bin\7zip;%CD%\bin\wget;%CD%\bin\rcedit;%CD%\bin\tar;%PATH%"

set "CURVERSION=2.0.2-x64"

set "CODEDIR=%CD%\.."

echo Creating temp folder
set "TMPDIR=%TMP%\ePubViewer-build-%RANDOM%"
mkdir "%TMPDIR%" 2>NUL

echo Creating output folder
set "BUILDDIR=%CD%\..\..\ePubViewer-build"
rd "%BUILDDIR%" /S /Q 2>NUL
mkdir "%BUILDDIR%" 2>NUL

echo Downloading node-webkit
echo ---- Downloading Windows binaries
wget -O "%TMPDIR%\nwjs-windows.zip" https://dl.nwjs.io/v0.17.3/nwjs-v0.17.3-win-x64.zip 2>NUL
echo -------- Extracting Windows binaries
7z x "%TMPDIR%\nwjs-windows.zip" -o"%BUILDDIR%" >NUL
ren "%BUILDDIR%\nwjs-v0.17.3-win-x64" "ePubViewer-%CURVERSION%-windows"

echo ---- Downloading Linux binaries
wget -O "%TMPDIR%\nwjs-linux.tar.gz" https://dl.nwjs.io/v0.17.3/nwjs-v0.17.3-linux-x64.tar.gz 2>NUL
echo -------- Extracting Linux binaries
7z x "%TMPDIR%\nwjs-linux.tar.gz" -o"%TMPDIR%" >NUL
7z x "%TMPDIR%\nwjs-v0.17.3-linux-x64.tar" -o"%BUILDDIR%" >NUL
ren "%BUILDDIR%\nwjs-v0.17.3-linux-x64" "ePubViewer-%CURVERSION%-linux"

echo Copying application files
echo ---- Copying Windows application files
robocopy "%CODEDIR%" "%BUILDDIR%\ePubViewer-%CURVERSION%-windows\package.nw" /S /E >NUL
echo ---- Copying Linux application files
robocopy "%CODEDIR%" "%BUILDDIR%\ePubViewer-%CURVERSION%-linux\package.nw" /S /E >NUL

echo Patching Windows executables
rcedit "%BUILDDIR%\ePubViewer-%CURVERSION%-windows\nw.exe" --set-version-string "Comments" "" --set-version-string "CompanyName" "Patrick G" --set-version-string "FileDescription" "ePubViewer" --set-version-string "FileVersion" "%CURVERSION%" --set-version-string "LegalCopyright" "Copyright 2016 Patrick G" --set-version-string "LegalTrademarks" "" --set-version-string "OriginalFilename" "ePubViewer.exe" --set-version-string "ProductName" "ePubViewer" --set-version-string "ProductVersion" "%CURVERSION%" --set-icon "../icon.ico"
ren "%BUILDDIR%\ePubViewer-%CURVERSION%-windows\nw.exe" "ePubViewer.exe"

echo Patching Linux executables
ren "%BUILDDIR%\ePubViewer-%CURVERSION%-linux\nw" "ePubViewer"

echo Creating portable Windows version
echo ---- Copying files
robocopy "%BUILDDIR%\ePubViewer-%CURVERSION%-windows" "%BUILDDIR%\ePubViewer-%CURVERSION%-windows-portable\App" /S /E >NUL
echo ---- Creating launcher
move "%BUILDDIR%\ePubViewer-%CURVERSION%-windows-portable\App\package.nw\ePubViewerPortable.bat" "%BUILDDIR%\ePubViewer-%CURVERSION%-windows-portable\ePubViewerPortable.bat"

echo Zipping executables
set "OD=%CD%"
cd "%BUILDDIR%"
for /d %%X in (*) do ( 
  echo ---- Zipping %%X
  7z a "%%X.zip" "%%X\" >NUL && rd /S /Q %%X 
)
cd "%OD%"

echo Cleaning up
rd "%TMPDIR%" /S /Q

echo Build finished of ePubViewer %CURVERSION%
echo Output is in %BUILDDIR%