# Replace by your environment information
$resourceGroupSQL = "DBProject_Drone_Demo_RG" #
$resourceGroupStorage = "DBProject_Drone_Demo_RG"
$sqlServer = "db-project-server-demo"
$sqlUsername = "cjadmin"
$sqlPassword = "Password1"
$securePassword = ConvertTo-SecureString -String $sqlPassword -AsPlainText -Force
$sqlCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $sqlUsername, $securePassword
$databaseName = "DBProject_Drone_Demo_POC"
$storageAccount = "dbprojectdemodrone"
$containerName = "sqlexport"

# You don't need to change the next lines
$bacpacFilename = (Get-Date).ToString("yyyy-MM-dd-HH-mm") + ".bacpac"
$storageKeyType = "StorageAccessKey"
$storageKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupStorage -AccountName $storageAccount)| Where-Object {$_.KeyName -eq "key2"}
$copyDatabaseName = (Get-Date).ToString("yyyyMMddHHmmss") + "-" + $databaseName
$bacpacFilename = (Get-Date).ToString("yyyy-MM-dd") + "-" + $copyDatabaseName + ".bacpac"
$baseStorageUri = "https://" + $storageAccount + ".blob.core.windows.net"
$bacpacUri = $baseStorageUri + "/" + $containerName + "/" + $bacpacFilename

# Copy database
Write-Host "Copying" $databaseName "to" $copyDatabaseName
New-AzSqlDatabaseCopy -ResourceGroupName $resourceGroupSQL -ServerName $sqlServer -DatabaseName $databaseName -CopyResourceGroupName $resourceGroupSQL -CopyServerName $sqlServer -CopyDatabaseName $copyDatabaseName
Write-Host "Copy completed"

# Export database
Write-Host "Exporting" $copyDatabaseName "to" $bacpacUri
$exportRequest = New-AzSqlDatabaseExport -ResourceGroupName $resourceGroupSQL -ServerName $sqlServer -DatabaseName $copyDatabaseName -StorageKeyType "StorageAccessKey" -StorageKey $storageKey.Value -StorageUri $bacpacUri -AdministratorLogin $sqlCredentials.UserName -AdministratorLoginPassword $sqlCredentials.Password
$exportRequest
$exportStatus = Get-AzSqlDatabaseImportExportStatus -OperationStatusLink $exportRequest.OperationStatusLink
while ($exportStatus.Status -eq "InProgress")
{
	Start-Sleep -s 10
	$exportStatus = Get-AzSqlDatabaseImportExportStatus -OperationStatusLink $exportRequest.OperationStatusLink
}

# Remove the copied database
Remove-AzSqlDatabase -ResourceGroupName $resourceGroupSQL -ServerName $sqlServer -DatabaseName $copyDatabaseName
