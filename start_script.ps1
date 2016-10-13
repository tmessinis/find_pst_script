do {
    $computer = Read-Host -Prompt "Enter hostname or IP address of remote computer"
} until ($computer -match "^(\w{2}){2}[\d]{6}$" -or $computer -match "^([0-9]\.|[1-9][0-9]\.|1[0-9][0-9]\.|2[0-4][0-9]\.|25[0-4]\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])$")
$remote_user = Get-WmiObject Win32_ComputerSystem -ComputerName $computer | Select-Object -ExpandProperty username
$home_dir = Get-ADUser -Identity $remote_user.Substring($remote_user.IndexOf("\") + 1) -Properties * | Select-Object -ExpandProperty homedirectory
$out_filename = $remote_user.Substring($remote_user.IndexOf("\") + 1) + "_" + $computer + "_pst_paths.txt"

$out = Invoke-Command -ComputerName $computer -FilePath .\find_pst.ps1 -ArgumentList $computer, $home_dir
$out += Get-ChildItem $home_dir -ErrorAction SilentlyContinue -Recurse -Include "*.pst" | select LastWriteTime, Name, Directory
$out >> $out_filename