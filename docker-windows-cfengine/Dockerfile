# https://mcr.microsoft.com/en-us/product/windows/nanoserver/tags
# no matching manifest for windows/amd64 10.0.19044 in the manifest list entries
FROM mcr.microsoft.com/windows/servercore:10.0.19042.1889
ADD https://cfengine-package-repos.s3.amazonaws.com/enterprise/Enterprise-3.24.0/agent/windows_x86_64/cfengine-nova-3.24.0-1-x86_64.msi /cfe.msi
# https://learn.microsoft.com/en-us/archive/blogs/nanoserver/wsa-updates-in-ws-2016-tp5
# https://learn.microsoft.com/en-us/archive/blogs/nanoserver/installing-windows-server-apps-on-nano-server
RUN msiexec /i /cfe.msi
RUN cf-agent -IB 192.168.1.238
CMD powershell -command "while($true){Start-Sleep -Seconds 5}"
