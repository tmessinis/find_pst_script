function find-pst {
    # Initialize variables. Find all local drives on remote user's machine.
    $comp = $args[0]
    $local_drives = Get-WmiObject Win32_LogicalDisk | Select-Object -ExpandProperty DeviceID
    $pst_paths = @()

    # Loop through the local drives and recursively search them for PST files. Add paths to array.
    foreach ($local_drive in $local_drives) {
        $path = $local_drive[0] + ":\"
        $pst_paths += Get-ChildItem $path -ErrorAction SilentlyContinue -Force -Recurse -Include "*.pst" | Select-Object LastWriteTime, Name, Directory
    }

    return $pst_paths
}

# Call main function
$pst_paths = find-pst $args[0]
return $pst_paths
