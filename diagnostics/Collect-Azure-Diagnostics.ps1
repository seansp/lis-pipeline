. .\Utilities.ps1


# Collect up the storage accounts.
$accounts = Get-AzureRmStorageAccount

$numberAccounts = $accounts.Length 
Message "Total of $numberAccounts Accounts."
foreach( $storageAccount in $accounts | Sort-Object Location, CreationTime, StorageAccountName )
{
  $include = $false;

  switch -Wildcard ( $storageAccount.ResourceGroupName.ToLower() )
  {
    "*jpl*" { $include = $true }
    "*hippie*" { $include = $true }
    "*my*" { $include = $true }
  }
  switch -Wildcard ( $storageAccount.StorageAccountName.ToLower() )
  {
    "*jpl*" { $include = $true }
    "*hippie*" { $include = $true }
    "*my*" { $include = $true }
  }

  if( $include -eq $true )
    {

      $name = $storageAccount.StorageAccountName
      $resourceGroup = $storageAccount.ResourceGroupName
      $location = $storageAccount.Location
      $creationDate = $storageAccount.CreationTime

      Message "$creationDate | $location | $resourceGroup | $name"
      
      $key1 = (Get-AzureRmStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -name $storageAccount.StorageAccountName)[0].value
      $storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $key1
      $storageContainer = Get-AzureStorageContainer -Context $storageContext

  }
}





#Import-Module ..\ConvertFrom-ArbritraryXml.psm1
#$xmlAsText = Get-Content -Path .\deploy_Drone.xml
#$ob = ConvertFrom-ArbritraryXml( [xml] $xmlAsText )
#$json = $ob | ConvertTo-Json -Depth 10