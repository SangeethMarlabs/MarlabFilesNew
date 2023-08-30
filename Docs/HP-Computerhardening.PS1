###########################################
#Scrpit Name: Computer Harderning         #
#Manufacturer:HP                          #
#Scrpit Created by: Sivabalan             #
###########################################
$head=@'
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; font-size: 15px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; font-size: 12px; padding: 3px; border-style: solid; border-color: black;}
</style>
'@

$hostname=hostname
$date=get-date

$bios =get-computerinfo | Select WindowsProductName,WindowsInstallDateFromRegistry,BiosSeralNumber,CsModel,CsName, @{Name="RAM (GB)";Expression={$_.CsTotalPhysicalMemory/1024MB}} |convertto-html –PreContent "<h3> Computer Info </h3>" –Fragment
$biospassword=Get-WmiObject -Namespace root/hp/InstrumentedBIOS -Class HP_BIOSSetting |where-object name -EQ "Setup Password" |select pscomputername,Active |convertto-html –PreContent "<h3> BIOS Password status </h3>" –Fragment
$Update = get-wmiobject -class win32_quickfixengineering | Select PSComputerName, Description,HotFixID ,InstalledBy,InstalledOn | ConvertTo-Html –PreContent "<h3>Security Updates </h3>" –Fragment
$disks = Get-CimInstance Win32_LogicalDisk | where{$_.DriveType -eq '3'} | Select DeviceID, @{N='Total Size(GB)';E={[math]::Round($_.Size/1GB,2)}}, @{N='Free size(GB)';E={[math]::Round($_.Freespace/1GB)}} | ConvertTo-Html –PreContent "<h3>Disk Information</h3>" -Fragment
$Bitlocket =Get-BitLockerVolume | ? {$_.KeyProtector.KeyProtectorType -eq "RecoveryPassword"} | Select-Object MountPoint,@{Label='Key';Expression={"$($_.KeyProtector.RecoveryPassword)"}} |ConvertTo-Html –PreContent "<h3> Bitlocker Recovery Key</h3>" -Fragment
$localuser= get-localuser |select Name,Enabled,Description | ConvertTo-Html –PreContent "<h3> Local Account  </h3>" –Fragment
$BitlockerStatus = get-bitlockervolume |Select  ComputerName, MountPoint,EncryptionMethod,AutoUnlockEnabled,VolumeStatus,ProtectionStatus,VolumeType,CapacityGB |convertto-html -PreContent "<h3>BitlockerStatus </h3>" –Fragment
$softwareinventory=Get-WmiObject -Class Win32_Product | select Name,version,vendor |ConvertTo-Html -PreContent "<h3> Installed Software list </h3>" –Fragment
$licenseactivationstatus=Get-CimInstance -ClassName SoftwareLicensingProduct | where {$_.PartialProductKey} |select Description, LicenseStatus |ConvertTo-Html -PreContent "<h3> Windows Activation status </h3>" –Fragment
$Systemrestore=Get-ComputerRestorePoint | select CreationTime,Description,RestorePointType  |ConvertTo-Html -PreContent "<h3>  System restore points list </h3>" –Fragment
$finalline= "<h4> This an auto generated report </h4>"
ConvertTo-Html  -head $head -postcontent "$bios $biospassword $Update $disks $Bitlocket $BitlockerStatus $localuser  $licenseactivationstatus $Systemrestore $softwareinventory $finalline " -precontent "<H2> Computer hardening report of $hostname </h2> <h3> Report generated on $date</h3> " - | Out-File D:\$hostname.html