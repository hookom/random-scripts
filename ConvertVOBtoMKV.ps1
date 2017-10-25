function convertDirectories
{
    Param ([string]$path)

    $dirs = Get-ChildItem $path

    foreach ($dir in $dirs)
    {
        $goDeeper = 0
        $currentPath = "$path\$dir"

        echo "Checking to ensure $currentPath contains no subdirectories."
        $children = Get-ChildItem $currentPath

        foreach ($child in $children)
        {
            $child = Get-Item "$currentPath\$child"
            if ($child.PSIsContainer -eq $True)
            {
                $goDeeper = 1
            }
        }

        if (-not $goDeeper)
        {
            echo "Converting: $currentPath"
            &$mkvcmd mkv file:$currentPath all $temp_dir

            if ($dir -match ', the$')
            {
                $dir = $dir -replace ', the', ''
                $dir = "the-$dir"
            }
            
            $dir = $dir -replace ' ', '-'

            $temp_mkvs = Get-ChildItem $temp_dir

            if ($temp_mkvs -isnot [array]) {
                $name = "$temp_dir\$temp_mkvs"

                $out_name = "$output_dir\$dir.mkv"

                echo "Moving single: $name to $out_name"
                Move-Item $name -destination $out_name
            } else {
                New-Item "$output_dir\$dir" -type directory

                for ($i = 0; $i -lt $temp_mkvs.Length; $i++) {
                    $name = "$temp_dir\"
                    $name += $temp_mkvs[$i]

                    $out_name = "$output_dir\$dir\$dir"
                    if ($i -lt 1) {
                        $out_name += ".mkv"
                    } else {
                        $out_name += "-$i.mkv"
                    }

                    echo "Moving multiple: $name to $out_name"
                    Move-Item $name -destination $out_name
                }
            }
        } else {
            echo "Found a sub-directory. Will recurse."
            convertDirectories $currentPath
        }

        # $diskData=(get-WmiObject Win32_LogicalDisk -filter "DeviceID = 'C:'") 

        # if (($diskData.FreeSpace / $diskData.Size) -lt $minfreespace)
        # {
        #     echo "Disk Space Low.."
        #     break
        # }
    }
}

if (-not $args) {
    echo "Please specify an input directory"
    Exit(1)
}

$input_dir = $args[0]

$output_dir = "C:\Users\Isaac\Desktop\output"

$temp_dir = "C:\Users\Isaac\Desktop\temp"

$mkvcmd = "C:\Program Files (x86)\MakeMKV\makemkvcon64.exe"

$minfreespace = .10

if ((Test-Path -path $temp_dir) -eq $false)
{
    New-Item $temp_dir -type directory
}

if ((Test-Path -path $output_dir) -eq $false)
{
    New-Item $output_dir -type directory
}

convertDirectories $input_dir

Remove-Item $temp_dir

echo "done"
