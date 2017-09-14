set PACKSUFFIX="1825"
set DCC="C:\Program Files (x86)\Embarcadero\Studio\19.0\Bin\Dcc32.exe"
set SYSTEMDIR="C:\Windows\system32"
set LIBDIR="C:\repositorio\components\thirdparty-Tokyo\RBuilder\Lib\Win32"
set SOURCEDIR="C:\repositorio\components\thirdparty-Tokyo\RBuilder\Source"
set WIN32="TRUE"
cd "C:\repositorio\components\thirdparty-Tokyo\RBuilder\TeeChart\Win32\TeeStd900"
C:

REM Building dcu's...

Copy %SOURCEDIR%\ppIfDef.pas /y

%DCC% BuildTee.dpr -B 

REM Building packages...

%DCC% rbTC%PACKSUFFIX%.dpk 

%DCC% rbTCUI%PACKSUFFIX%.dpk 

%DCC% rbTDBC%PACKSUFFIX%.dpk 

IF DEFINED WIN32 %DCC% dclRBC%PACKSUFFIX%.dpk 

REM Copy packages and source

Copy *.pas %SOURCEDIR% /y
Copy *.dpk %SOURCEDIR% /y
Copy *.dfm %SOURCEDIR% /y

Copy *.dcu %LIBDIR% /y
Copy *.dcp %LIBDIR% /y
Copy *.dfm %LIBDIR% /y

IF DEFINED WIN32 copy dcl*.bpl %LIBDIR% /y

copy rb*.bpl %SYSTEMDIR% /y
