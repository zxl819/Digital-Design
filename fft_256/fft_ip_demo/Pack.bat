@echo off
:: 切换当前编码方式为 UTF-8，处理命令行窗口标题乱码问题
:: chcp 65001
:: title 批量压缩当前目录下个文件到各自压缩包
:: 切换回默认 GBK 编码，处理命令行输出乱码问题
:: chcp 936
echo ---------- START -------------

:: 获取当前目录名
set bat_dir=%~dp0
for %%a in ("%bat_dir:~,-1%") do set cur_dir=%%~nxa
echo %cur_dir%


set zipname="%cur_dir%_bak%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%.zip"

echo %zipname% %cd%


:: 压缩当前文件夹所有文件到一个文件里面，并以年月日时分命名 -x!_bak*.*：exclude _bak*.* 
:: D:\7-Zip\7z.exe a -t7z "Backup.7z"
D:\7-Zip\7z.exe a -tzip %zipname% -x!*bak*.*



:: set WinRAR_Dir=%ProgramFiles%\WinRAR
:: set PATH=%PATH%;%WinRAR_Dir%
:: WinRAR.exe a -r "backup.zip" -rr -m5 * -ibck

echo ----------  END  -------------
pause