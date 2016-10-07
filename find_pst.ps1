function find-pst {
    # Initialize variables. Find the user currently logged into remote machine, and the home directory that has been assigned to them via AD.
    $comp = $args[0]
    $local_drives = Get-WmiObject Win32_LogicalDisk -ComputerName $comp | Select-Object -ExpandProperty DeviceID
    $remote_user = Get-WmiObject Win32_ComputerSystem -ComputerName $comp | Select-Object -ExpandProperty username
    $home_dir = Get-ADUser -Identity $remote_user.Substring($remote_user.IndexOf("\") + 1) -Properties * | Select-Object -ExpandProperty homedirectory
    $out_filename = $remote_user.Substring($remote_user.IndexOf("\") + 1) + "_" + $comp + "_pst_paths.txt"

    foreach ($local_drive in $local_drives) {
        $path = "\\" + $comp + "\" + $local_drive[0] + "$"
        Get-ChildItem $path -ErrorAction Ignore -Recurse -Include "*.pst"  >> $out_filename
    }

    # Search user's home directory on remote server.
    Get-ChildItem $home_dir -ErrorAction Ignore -Recurse -Include "*.pst"  >> $out_filename
}

$computer = $args[0]

find-pst $computer