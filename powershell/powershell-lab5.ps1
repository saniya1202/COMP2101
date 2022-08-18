param ( [switch]$System, [switch]$Disks, [switch]$Network)

if ($System -eq $false -and $Disks -eq $false -and $Network -eq $false) {
  Hardware  
  OperatingSystem
  Processor
  RAMSummary
  VideoController
  PhysicalDrives
  NetworkAdapter
}
if ($System) {   
  Hardware  
  OperatingSystem
  Processor
  RAMSummary
  VideoController
}
if ($Disks) { 
  PhysicalDrives
}
if ($Network) { 
  NetworkAdapter
}
