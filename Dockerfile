FROM openjdk:8-windowsservercore
SHELL ["powershell", "-Command"]
RUN wget https://download.microsoft.com/download/C/5/0/C5092724-4FFE-4DD3-9EE7-0AE31BF17620/vs_Professional.exe -OutFile vs_Professional.exe;
RUN c:\vs_Professional.exe --quiet --wait --norestart --allWorkloads --includeRecommended --includeOptional
