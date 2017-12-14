# check if SQL module is already imported
Get-PSDrive

#import SQLPS module
import-module SQLPS -DisableNameChecking;

# script out all foreign keys in T-SQL
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\Dental\tables | % {$_.foreignkeys } | % {$_.script()}; 

# save the script to a file by adding out-file at the end of the code
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\Dental\tables | % {$_.foreignkeys } | % {$_.script()} | out-file F:\DatabaseMaintenance\fk.sql -force;

# scripting out all foreign key drop statements in T-SQL
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\Dental\tables | % {$_.foreignkeys } | % {"alter table $($_.parent) drop $_;"};

#scripting out all stored procedures
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\Dental\StoredProcedures | % {$_.script() + 'go'};

#scripting out views with prefix as 'billing'
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\methasoft_mrc\Views | ? {$_.name -like 'billing*' } | % {$_.script() + 'GO'};

#scripting out all DDL triggers
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\Dental\Triggers | % {$_.script() + 'GO'};

#scripting out UDFs
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\Dental\UserDefinedFunctions | % {$_.script() + 'GO'};

#scripting out SQL Server Agent Jobs whose name is 'PowerShell - Test' and save it to a file at F:\DatabaseMaintenance\job.sql, if the file exist, just append the script to it
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\jobserver\jobs | ? {$_.name -eq 'Powershell - Test'}| % {$_.script() + 'go'} | out-file F:\DatabaseMaintenance\job.sql -append;

#find the top 10 largest tables (in rows) in a database
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\Dental\tables | sort rowcount -desc | select name, rowcount -first 10;

#find out logins with sysadmin rights on mulitple servers (assume the default sql instance only)
'cshstestdb3_1', 'cshstestdb3_2', 'ngtest' | % { dir "sqlserver:\sql\$_\default\logins" }  | ? {$_.ismember('sysadmin')} | select Parent, Name;

#script out datatabases to a file
$DBServer = "CSHSDB02"

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null 

$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') $DBServer  

$dbs=$s.Databases 

$dbs["VeeamBackup","VeeamOne"].Script() | Out-File F:\DatabaseMaintenance\script_dbs.sql 

#Generate script for all tables within a db

foreach ($tables in $dbs["VeeamOne"].Tables) 
{
    $tables.Script() + "`r GO `r " | Out-File F:\DatabaseMaintenance\Script_Tables.sql -append;
} 






