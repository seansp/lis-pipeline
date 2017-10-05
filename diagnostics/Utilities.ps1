function Alert( $msg )
{
  $now = [Datetime]::Now.ToUniversalTime().ToString("MM/dd/yyyy HH:mm:ss")
  Write-Host -BackgroundColor Yellow -ForegroundColor DarkBlue "$now| $msg"
}
function Message( $msg )
{
  $now = [Datetime]::Now.ToUniversalTime().ToString("MM/dd/yyyy HH:mm:ss")
  Write-Host -BackgroundColor White -ForegroundColor Blue "$now| $msg"
}
function Error( $msg )
{
  $now = [Datetime]::Now.ToUniversalTime().ToString("MM/dd/yyyy HH:mm:ss : ")
  Write-Host -BackgroundColor Red -ForegroundColor Yellow "$now| ERR | $msg"
}

#TODO: Some mechanism for querying/using the global variable for the CTX file.
Message "Loading the ProfileContext from $($Global:ProfileContextPath)"
try
{
  Import-AzureRmContext -Path $Global:ProfileContextPath -ErrorAction Stop
#  Import-AzureRmContext -Path 'C:\Azure\ProfileContext.ctx' -ErrorAction Stop
  Select-AzureRmSubscription -SubscriptionId 2cd20493-fe97-42ef-9ace-ab95b63d82c4
} catch
{
  Error "An error occurred while loading the context."
  return
} 



#Import-Module ..\ConvertFrom-ArbritraryXml.psm1
#$xmlAsText = Get-Content -Path .\deploy_Drone.xml
#$ob = ConvertFrom-ArbritraryXml( [xml] $xmlAsText )
#$json = $ob | ConvertTo-Json -Depth 10