# Loop to verify that user enters correct hostname or IP address
do {
    $computer = Read-Host -Prompt "Enter hostname or IP address of remote computer"
} until ($computer -match "^(\w{2}){2}[\d]{6}$" -or $computer -match "^([0-9]\.|[1-9][0-9]\.|1[0-9][0-9]\.|2[0-4][0-9]\.|25[0-4]\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])$")
# Find out the remote user's sam account name.
$remote_user = Get-WmiObject Win32_ComputerSystem -ComputerName $computer | Select-Object -ExpandProperty username
# Find out the remote user's home folder that's associated with AD.
$home_dir = Get-ADUser -Identity $remote_user.Substring($remote_user.IndexOf("\") + 1) -Properties * | Select-Object -ExpandProperty homedirectory
# Variable to format the filename of the text file which will include the PST paths.
$out_filename = $remote_user.Substring($remote_user.IndexOf("\") + 1) + "_" + $computer + "_pst_paths.txt"

# Run the find_pst.ps1 script on the remote user's machine and save the returned array in a variable.
Invoke-Command -ComputerName $computer -FilePath .\find_pst.ps1 -ArgumentList $computer >> $out_filename
# Look for PST files in the remote user's home folder. Append the results in the array to be outputted.
Get-ChildItem $home_dir -ErrorAction SilentlyContinue -Recurse -Include "*.pst" | Select-Object LastWriteTime, Name, Directory >> $out_filename