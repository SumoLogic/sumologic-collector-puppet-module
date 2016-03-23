(new-object net.webclient).DownloadFile('https://collectors.sumologic.com/rest/download/windows', 'c:\\sumo\\sumo.exe')
c:\\windows\\system32\\icacls.exe "c:\\sumo\\sumo.exe" "/grant" "Administrators:(RX)"
