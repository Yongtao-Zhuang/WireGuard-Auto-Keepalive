@echo off
chcp 936 >nul
setlocal enabledelayedexpansion

:: ================= 配置区 =================
:: [重要]要ping的地址，比如wg对端地址，这个地址不通，就会重启wg
set "TARGET_IP=5.5.5.1"
:: [重要]隧道名称（即 .conf 文件名，建议用英文或者数字或者英文数字组合）
set "TUN_NAME=25"
:: 下面一行不用修改
set "WG_SERVICE=WireGuardTunnel$%TUN_NAME%"
:: [重要]多久检查一次隧道状态单位是秒，默认30秒
set "INTERVAL=30"
:: [重要] 请确认你的 .conf 配置文件存放的绝对路径
set "CONF_PATH=C:\Program Files\WireGuard\25.conf"
:: [重要] WireGuard 程序路径（安装目录）
set "WG_EXE=C:\Program Files\WireGuard\wireguard.exe"
:: [重要] 默认日志存放的地方
set "LOG_FILE=%TEMP%\WG_Watchdog.log"
:: =========================================

:: 权限预检
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员身份运行！
    pause
    exit
)

:: 初始化日志
echo [%date% %time%] 监控服务启动 > "%LOG_FILE%"

title WG-Watchdog 

echo ========================================
echo   WireGuard 守护程序 
echo ========================================
echo   监控 IP: %TARGET_IP%
echo   日志路径: %LOG_FILE%
echo ========================================

:LOOP
title [监控中] 最后检查: %time%
echo [%time%] 正在检测 %TARGET_IP%...

:: --- 第一步：检查 WireGuard 服务是否还在服务列表中 ---
sc query "%WG_SERVICE%" >nul 2>&1
if %errorlevel% neq 0 (
    echo %date% %time%---服务缺失，正在尝试安装 >> "%LOG_FILE%"
    echo [%time%] 警告: 服务 %WG_SERVICE% 已消失，正在重新安装...
    
    :: 执行安装命令
    "%WG_EXE%" /installtunnelservice "%CONF_PATH%"
    
    if !errorlevel! equ 0 (
        echo [%time%] 服务安装指令已发送，等待初始化...
        timeout /t 5 /nobreak >nul
    ) else (
        echo %date% %time%---安装服务失败，请检查路径 >> "%LOG_FILE%"
        echo [%time%] 错误: 无法安装服务，请确认配置文件路径正确。
    )
)

:: --- 第二步：执行网络检测 ---
ping -n 2 -w 2000 %TARGET_IP%

if %errorlevel% neq 0 (
    echo %date% %time%---通道异常，正在重启 >> "%LOG_FILE%"
    echo [%time%] !!! 链路不通，正在尝试重启服务 !!!
    
    :: 停止并重新启动
    net stop "%WG_SERVICE%" >nul 2>&1
    timeout /t 2 /nobreak >nul
    net start "%WG_SERVICE%"
    
    if !errorlevel! equ 0 (
        echo [%time%] 重启成功。
        timeout /t 10 /nobreak >nul
    ) else (
        echo [%time%] 无法启动服务，尝试强制重新安装...
        :: 如果启动失败，可能服务已损坏，尝试卸载重装
        "%WG_EXE%" /uninstalltunnelservice "%TUN_NAME%" >nul 2>&1
        timeout /t 2 /nobreak >nul
        "%WG_EXE%" /installtunnelservice "%CONF_PATH%"
        echo %date% %time%---服务启动失败，已触发强制重装 >> "%LOG_FILE%"
    )
) else (
    echo %date% %time%-----通道正常 >> "%LOG_FILE%"
    echo [%time%] 状态正常。
)

:: 等待下一次循环
timeout /t %INTERVAL% /nobreak >nul
goto LOOP