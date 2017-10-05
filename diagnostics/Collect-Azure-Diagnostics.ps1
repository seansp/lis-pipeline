. .\Utilities.ps1


$disable_name_filter = $true
$disable_file_filter = $false

# Collect up the storage accounts.
$accounts = Get-AzureRmStorageAccount

$numberAccounts = $accounts.Length 
Message "Total of $numberAccounts Accounts."

$found_files = @{}

$currentAccount = 1

foreach( $storageAccount in $accounts | Sort-Object Location, CreationTime, StorageAccountName )
{
  $include = $disable_name_filter

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

  $name = $storageAccount.StorageAccountName
  Alert " $name -- $currentAccount / $numberAccounts"
  $currentAccount = $currentAccount + 1
  
  if( $include -eq $true )
    {
      $resourceGroup = $storageAccount.ResourceGroupName
      $location = $storageAccount.Location
      $creationDate = $storageAccount.CreationTime
      Message "$creationDate | $location | $resourceGroup | $name"   
      $key1 = (Get-AzureRmStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -name $storageAccount.StorageAccountName)[0].value
      $storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $key1
      $storageContainer = Get-AzureStorageContainer -Context $storageContext
      $containers = @()
      #Sometimes there is just one container.  Sometimes an array.
      if( !($storageContainer -is [system.array]) )
      {
        $containers += $storageContainer
      }
      else {
        $containers = $storageContainer
      }
      foreach( $container in $containers )
      {
        $containerFilter = $true
        switch -Wildcard ( $container.Name.ToLower() ) 
        {
          "*bootdiagnostics*" { $containerFilter = $false }
        }
        if( $containerFilter -eq $true )
        {
            Message $container.Name
            $containerName = $container.Name
            $files = @()
            foreach( $blob in Get-AzureStorageBlob -Container $container.Name -Context $storageContext )
            {
              $fileFilter = $disable_file_filter
              switch -Wildcard ( $blob.Name.ToLower() )
              {
                "*.iso" { $fileFilter = $true }
                "*.vhd" { $fileFilter = $true }
                "*.vdhx" { $fileFilter = $true }
                "*.wim" { $fileFilter = $true }
              }
              if( $fileFilter -eq $true )
              {
                Message $blob.Name
                $files += $blob.Name 
              }
            }
            $found_files.Add(  $name + "." + $resourceGroup + "." + $location + "\\" + $containerName, $files )
        }
      }
  }
}

ConvertTo-Json -InputObject $found_files > diag-files.json




#Import-Module ..\ConvertFrom-ArbritraryXml.psm1
#$xmlAsText = Get-Content -Path .\deploy_Drone.xml
#$ob = ConvertFrom-ArbritraryXml( [xml] $xmlAsText )
#$json = $ob | ConvertTo-Json -Depth 10