do {
    $computer = Read-Host -Prompt "Enter hostname or IP address of remote computer"
} until ($computer -match "^(\w{2}){2}[\d]{6}$" -or $computer -match "^([0-9]\.|[1-9][0-9]\.|1[0-9][0-9]\.|2[0-4][0-9]\.|25[0-4]\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])$")

cp .\find_pst.ps1 \\$computer\c$

\\$computer\c$\find_pst.ps1 $computer
rm \\$computer\c$\find_pst.ps1