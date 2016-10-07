function find-pst {
    # Initialize variables. Find the user currently logged into remote machine, and the home directory that has been assigned to them via AD.
    $comp = $args[0]
    $local_drives = Get-WmiObject Win32_LogicalDisk -ComputerName $comp | Select-Object -ExpandProperty DeviceID
    $remote_user = Get-WmiObject Win32_ComputerSystem -ComputerName $comp | Select-Object -ExpandProperty username
    $home_dir = Get-ADUser -Identity $remote_user.Substring($remote_user.IndexOf("\") + 1) -Properties * | Select-Object -ExpandProperty homedirectory
    $out_filename = $remote_user.Substring($remote_user.IndexOf("\") + 1) + "_" + $comp + "_pst_paths.txt"

    # For loop to through alphabet via ASCII codes, and check each local drive on user's remote computer for pst files.
    #65..90 | foreach {
    #    $path = "\\" + $comp + "\" + [char]$_ + "$"
    #    Get-ChildItem $path -ErrorAction Ignore -Recurse -Include "*.pst"  >> $out_filename
    #}
    foreach ($local_drive in $local_drives) {
        $path = "\\" + $comp + "\" + $local_drive[0] + "$"
        Get-ChildItem $path -ErrorAction Ignore -Recurse -Include "*.pst"  >> $out_filename
    }

    #$map_drives = Get-WmiObject Win32_MappedLogicalDisk -computer $comp | select providername
    #foreach ($drive in $map_drives) {
    #    if ($drive.providername -match "^\\{2}[a-zA-Z0-9]+\\{1}[Uu](SER|ser)") {
    #        Get-ChildItem $drive.providername -ErrorAction Ignore -Recurse -Include "*.pst" >> $out_filename
    #    }
    #    else {
    #        continue
    #    }
    #}

    # Search user's home directory on remote server.
    Get-ChildItem $home_dir -ErrorAction Ignore -Recurse -Include "*.pst"  >> $out_filename
}

# Have user input the hostname or IP address of target computer
#$computer = Read-Host -Prompt "Enter computer hostname or IP address"
$computer = $args[0]

find-pst $computer