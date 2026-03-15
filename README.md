# WireGuard-Auto-Keepalive
Stop Reconnecting Manually! WireGuard Auto-Keepalive Script

English Version
Important Notes:

WireGuard Path: The default installation directory is C:\Program Files\WireGuard\. If you installed it elsewhere, please update the configuration paths as shown in the video.

Permissions: All CMD or PowerShell commands MUST be executed with Administrator privileges.

Step 1: Export WireGuard Configuration
Export your tunnel as a ZIP file, extract it, and copy the .conf configuration file to the WireGuard installation directory.

Step 2: Install Daemon Files
Copy reload.bat, win.exe, and win.xml to the WireGuard installation directory.

Step 3: Verify Configuration & Scripts

Check win.xml.

Check reload.bat. (Note: If you modify this file, you must "Save As" with ANSI encoding. Do not use standard UTF-8/default saving.)

Step 4: Install Daemon Service
Open CMD or PowerShell as Administrator, navigate to the WireGuard directory, and run:

win.exe install (If an error occurs here, please provide a screenshot for assistance or consult an AI tool.)

win.exe start

win.exe status

Step 5: Verification
Confirm the service is running as expected.


定义：wg安装目录一般为C:\Program Files\WireGuard\如果你安装到其他目录了，需要看视频自行修改配置文件
定义：所有需要运行CMD或者powershell的地方均需要管理员权限运行

1：导出WG配置文件
将隧道导出为ZIP，解压ZIP文件，将.conf配置文件复制到wg安装目录

3：安装守护程序
把reload.bat/win.exe/win.xml复制到WG安装目录


4：检查服务配置文件，检查重启脚本
win.xml
reload.bat（如果修改了文件，需要另存文件为ANSI编码，不要直接保存）

5:安装守护服务
运行cmd或者powershell,进入WG安装目录运行
win.exe  install   （如果此处命令后报错，可提供截图请求帮助，或者自行AI解决）
win.exe start 
win.exe status

6:验证
