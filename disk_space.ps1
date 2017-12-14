
# check local disk space (in bytes)
Get-WMIObject Win32_Logicaldisk -filter "deviceid='C:'" -ComputerName MS000004767 |
Select PSComputername,DeviceID,Size,Freespace

# check local disk space (in GB)
Get-WMIObject Win32_Logicaldisk -filter "deviceid='C:'" -ComputerName MS000004767 |
Select PSComputername,DeviceID,
@{Name="SizeGB";Expression={$_.Size/1GB -as [int]}},
@{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)}} | Out-File C:\Users\desdheressa\Documents\GitLab\Database\AdHocScripts\disk_space.txt
Get-Date | out-file C:\Users\desdheressa\Documents\GitLab\Database\AdHocScripts\disk_space.txt -append;