"Hardware Description:"
function Hardware {
get-wmiobject -class win32_computersystem | ft
 }
Hardware

"Operating System Description:"
function OperatingSystem {
 get-wmiobject -class win32_operatingsystem | ft PSComputerName, Version
}
OperatingSystem

"Processor Description"
function Processor {
get-wmiobject -class win32_processor |
 foreach {
            new-object -TypeName psobject -Property @{
                       Description = $_.Description
                       L3CacheSize = $_.L3CacheSize
                       MaxClockSpeed = $_.MaxClockSpeed
                       NumberOfCores = $_.NumberOfCores

		}| fl Description, L3CacheSize, L3CacheSpeed, MaxClockSpeed, NumberOfCores
	}
}
Processor


"RAM Description"
function RAMSummary {
get-wmiobject -class win32_physicalmemory |
 foreach {
  new-object -TypeName psobject -Property @{
  Manufacturer = $_.manufacturer
  "Size(MB)" = $_.capacity/1mb
  Description = $_.Description
  Bank = $_.banklabel
  Slot = $_.devicelocator
  }
  $totalcapacity += $_.capacity/1mb
 }| Format-Table Manufacturer, "Size(MB)", Bank, Slot, Description
 "Total RAM: ${totalcapacity}MB "
}
RAMSummary 


"Physical Drives"
function PhysicalDrives {
$diskdrives = Get-CIMInstance CIM_diskdrive

   foreach ($disk in $diskdrives) {
       $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
       foreach ($partition in $partitions) {
             $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
             foreach ($logicaldisk in $logicaldisks) {
                      new-object -typename psobject -property @{ManufacturerOfDisk=$disk.Manufacturer
                                                                SpaceOccupied=($disk.size - $logicaldisk.FreeSpace) /1gb -as [int]
                                                                ModelOfDiskDrive=$disk.model
                                                                FreeSpaceOfLogicalDisk=$logicaldisk.FreeSpace
                                                               "SizeOfDiskDrive(GB)"=$disk.size / 1gb -as [int]
                                                                 }|Format-table ManufacturerOfDisk, SpaceOccupied, ModelOfDiskDrive, FreeSpaceOfLogicalDisk, "SizeOfDiskDrive(GB)"
													}
											}
									}
						}
PhysicalDrives


"Network Adapter Description"
function NetworkAdapter {
Get-CimInstance win32_networkadapterconfiguration | Where-Object {$_.ipenabled -eq "True" } | ft -AutoSize Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder
}
NetworkAdapter


"Video Controller Description"
function VideoController {
get-wmiobject -class win32_videocontroller |
 foreach{
              new-object -TypeName psobject -Property @{
                        Description = $_.Description
                        VideoArchitecture = $_.VideoArchitecture
                        CurrentScreenResolution =[string]$_.CurrentHorizontalResolution + "x" +  $_.CurrentVerticalResolution
 }| ft Description, VideoArchitecture, CurrentScreenResolution
 }
 }
 VideoController
