@echo off
setlocal enabledelayedexpansion
if "%1"=="list" (
  SET /A RULECOUNT=0
  for /f %%i in ('netsh advfirewall firewall show rule name^=all ^| findstr Blockit') do (
    SET /A RULECOUNT+=1
    netsh advfirewall firewall show rule Blockit!RULECOUNT! | findstr RemoteIP
  )
  SET "RULECOUNT="
  exit/b
)

REM Deleting existing block on ips
SET /A RULECOUNT=0
for /f %%i in ('netsh advfirewall firewall show rule name^=all ^| findstr Blockit') do (
  SET /A RULECOUNT+=1
  netsh advfirewall firewall delete rule name="Blockit!RULECOUNT!"
)
SET "RULECOUNT="

REM Block new ips (while reading them from blockit.txt)
SET /A IPCOUNT=0
SET /A BLOCKCOUNT=1
for /f %%i in (ipblock.txt) do (
  SET /A IPCOUNT+=1
  if !IPCOUNT! == 201 (
    netsh advfirewall firewall add rule name="Blockit!BLOCKCOUNT!" protocol=any dir=in action=block remoteip=!IPADDR!
    netsh advfirewall firewall add rule name="Blockit!BLOCKCOUNT!" protocol=any dir=out action=block remoteip=!IPADDR!
    SET /A BLOCKCOUNT+=1
    SET /A IPCOUNT=1
    set IPADDR=%%i
  ) else (
    if not "!IPADDR!" == "" (  
      set IPADDR=!IPADDR!,%%i
    ) else (
      set IPADDR=%%i
    )
  )
)

REM add the final block of IPs of length less than 200
netsh advfirewall firewall add rule name="Blockit!BLOCKCOUNT!" protocol=any dir=in action=block remoteip=!IPADDR!
netsh advfirewall firewall add rule name="Blockit!BLOCKCOUNT!" protocol=any dir=out action=block remoteip=!IPADDR!

SET "IPCOUNT="
SET "BLOCKCOUNT="
SET "IPADDR="

REM call this batch again with list to show the blocked IPs
call %0 list