function Check-DiskSpace
{
    Param
    (
         [Parameter(Mandatory=$True, Position=0)]
         [string] $ComputerName
    )
    $Disks = Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName
    Foreach ($Disk in $Disks)
    { IF ($Disk.DriveType -eq "3")
      {
        $DiskCapacity = [math]::Round(($Disk.Size/1GB ),2)
        $DiskFree = [math]::Round(($Disk.FreeSpace/1GB ),2)
        $DiskPercent = [math]::Round((($DiskFree/$DiskCapacity)*100),2)
        $DiskUsed = ($DiskCapacity - $DiskFree)

      $infoObject = New-Object PSObject
      #The following add data to the infoObjects.
      Add-Member -inputObject $infoObject -memberType NoteProperty -name "DriveLetter" -value $Disk.DeviceID
      Add-Member -inputObject $infoObject -memberType NoteProperty -name "Label" -value $Disk.VolumeName
      Add-Member -inputObject $infoObject -memberType NoteProperty -name "% Free" -value $DiskPercent
      Add-Member -inputObject $infoObject -memberType NoteProperty -name "Capacity (GB)" -value $DiskCapacity
      Add-Member -inputObject $infoObject -memberType NoteProperty -name "FreeSpace (GB)" -value $DiskFree
      Add-Member -inputObject $infoObject -memberType NoteProperty -name "UsedSpace (GB)" -value $DiskUsed

      $infoObject |Format-table

      }
    }

}
