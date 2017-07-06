FROM openjdk:8-windowsservercore
SHELL ["powershell", "-Command"]

# Instal VS 2017
RUN wget https://download.microsoft.com/download/C/5/0/C5092724-4FFE-4DD3-9EE7-0AE31BF17620/vs_Professional.exe -OutFile vs_Professional.exe;
RUN c:\vs_Professional.exe --quiet --wait --norestart --allWorkloads --includeRecommended --includeOptional

# Install Windows SDK 10.1
RUN powershell -Command \
    mkdir c:\install_logs; \
    Invoke-WebRequest https://coderobin.blob.core.windows.net/public/fakenet/x64/FakeNet.exe -OutFile $env:temp\fakenet64.exe; \
    Invoke-WebRequest https://coderobin.blob.core.windows.net/public/fakenet/x86/FakeNet.exe -OutFile $env:temp\fakenet.exe; \
    Copy C:\Windows\System32\net.exe C:\Windows\System32\net.exe.bak; \
    Copy C:\Windows\SysWOW64\net.exe C:\Windows\SysWOW64\net.exe.bak; \
    $acl1 = Get-Acl C:\Windows\System32\net.exe; \
    $acl11 = Get-Acl C:\Windows\System32\net.exe; \
    $acl2 = Get-Acl C:\Windows\SysWOW64\net.exe; \
    $acl21 = Get-Acl C:\Windows\SysWOW64\net.exe; \
    $permission = 'BUILTIN\Administrators','FullControl','Allow'; \
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission; \
    $acl11.SetAccessRule($accessRule); \
    Set-Acl C:\Windows\System32\net.exe -AclObject $acl11; \
    $acl21.SetAccessRule($accessRule); \
    Set-Acl C:\Windows\SysWOW64\net.exe -AclObject $acl21; \
    Copy $env:temp\fakenet64.exe C:\Windows\System32\net.exe; \
    Copy $env:temp\fakenet.exe C:\Windows\SysWOW64\net.exe; \
    wget http://download.microsoft.com/download/2/1/2/2122BA8F-7EA6-4784-9195-A8CFB7E7388E/StandaloneSDK/sdksetup.exe -OutFile sdksetup.exe; \
    Start-Process -FilePath "C:\sdksetup.exe" -ArgumentList /Quiet, /NoRestart, /Log, c:\install_logs\sdksetup.log -PassThru -Wait; \
    rm sdksetup.exe; \
    Remove-Item C:\Windows\System32\net.exe; \
    Remove-Item C:\Windows\SysWOW64\net.exe; \
    Rename-Item C:\Windows\System32\net.exe.bak C:\Windows\System32\net.exe; \
    Rename-Item C:\Windows\SysWOW64\net.exe.bak C:\Windows\SysWOW64\net.exe; \
    Set-Acl C:\Windows\System32\net.exe -AclObject $acl1; \
    Set-Acl C:\Windows\SysWOW64\net.exe -AclObject $acl2;
