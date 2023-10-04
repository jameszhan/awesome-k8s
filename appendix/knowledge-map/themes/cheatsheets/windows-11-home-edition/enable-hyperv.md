Save hyperv-home.bat

```bat
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hv-home.txt
for /f %%i in ('findstr /i . hv-home.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hv-home.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL
pause
```

Right-click the hyperv-home.bat file and select the “Run as administrator” option.

```bat
Enable-WindowsOptionalFe ature -Online -FeatureName Microsoft-Hyper-V -All
```



