cd ..\..\source\windows
del *.dcu
cd ..\..\lib\19.0\win32
del *.dcu
cd ..\..\..\bin\19.0
del *.dcu
del *.~*
copy ..\..\source\windows\*.dfm ..\..\lib\19.0\win32
copy ..\..\source\windows\*.res ..\..\lib\19.0\win32
"c:\program files (x86)\embarcadero\studio\19.0\bin\dcc32" -NB..\..\lib\19.0\win32 -LEwin32 -LUvcl -LN..\..\lib\19.0\win32 -$D- -$L- -B -JL -N..\..\lib\19.0\win32 -NH..\..\bin\19.0\win32 -U..\..\source\windows ..\..\bin\19.0\ipstudiowin.dpk

"c:\program files (x86)\embarcadero\studio\19.0\bin\dcc32" -NB..\..\lib\19.0\win32 -LEwin32 -LUvcl;ipstudiowin -LN..\..\lib\19.0\win32 -$D- -$L- -B -JL -N..\..\lib\19.0\win32 -NH..\..\bin\19.0\win32 -u..\..\source\windows ..\..\bin\19.0\ipstudiowinclient.dpk

"c:\program files (x86)\embarcadero\studio\19.0\bin\dcc32" -NB..\..\lib\19.0\win32 -LEwin32 -LUipstudiowin -LN..\..\lib\19.0\win32 -$D- -$L- -JL -B -N..\..\lib\19.0\win32 -NH..\..\bin\19.0\win32 -u..\..\source\windows ..\..\bin\19.0\ipstudiowinWordxp.dpk

"c:\program files (x86)\embarcadero\studio\19.0\bin\dcc32" -NB..\..\lib\19.0\win32 -LEwin32 -LUipstudiowin -LN..\..\lib\19.0\win32 -$D- -$L- -JL -Awintypes=windows -Awinprocs=windows -B -N..\..\lib\19.0\win32 -NH..\..\bin\19.0\win32 -U..\..\source\windows ..\..\bin\19.0\dipstudiowin.dpk

"c:\program files (x86)\embarcadero\studio\19.0\bin\dcc32" -DwwEmbarcaderoVersion -NB..\..\lib\19.0\win32 -LEwin32 -LUipstudiowin -LN..\..\lib\19.0\win32 -$D- -$L- -JL -Awintypes=windows -Awinprocs=windows -B -N..\..\lib\19.0\win32 -NH..\..\bin\19.0\win32 -U..\..\source\windows ..\..\bin\19.0\dipgridswin.dpk

copy *.lib ..\..\lib\19.0\win32
copy win32\*.hpp "..\..\include\19.0\windows"

del *.lib
del win32\*.hpp

cd ..\source
del *.obj
del *.dcu
del *.~*
del *.old