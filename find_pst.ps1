function find-pst {
    # Initialize variables. Find the user currently logged into remote machine, and the home directory that has been assigned to them via AD.
    $comp = $args[0]
    $local_drives = Get-WmiObject Win32_LogicalDisk | Select-Object -ExpandProperty DeviceID
    $pst_paths = @()

    foreach ($local_drive in $local_drives) {
        $path = $local_drive[0] + ":\"
        $pst_paths += Get-ChildItem $path -ErrorAction SilentlyContinue -Recurse -Include "*.pst" | select LastWriteTime, Name, Directory
    }

    return $pst_paths
}

$pst_paths = find-pst $args[0]
return $pst_paths
