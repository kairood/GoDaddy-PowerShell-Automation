Function Check-GoDaddySSL {
     Param(
    [parameter(Mandatory=$true)]
    [String]$apiKey,
    [Parameter(Mandatory=$true)]
    [string]$apiSecret,
    [Parameter(Mandatory=$true)]
    [ValidateSet('OTE','Production')]
    [string]$Enviorment
    )

$Headers = @{}
$Headers["Authorization"] = 'sso-key ' + $apiKey + ':' + $apiSecret

Write-Verbose "Connecting to the GoDaddy $Enviorment... Enviorment" -Verbose

if ($Enviorment -eq "OTE") {


$data = Invoke-WebRequest https://api.ote-godaddy.com/v1/certificates -Method Get -Headers $Headers | ConvertFrom-Json

}

elseif ($Enviorment -eq "Production") {

$data = Invoke-WebRequest https://api.godaddy.com/v1/certificates -Method Get -Headers $Headers | ConvertFrom-Json

}

foreach ($cert in $data) {
$CertID = $cert.certificateId
$CertDomain = $cert.commonName
$CertStatus = $cert.active
$CertEndDate = $cert.validEnd


if ($CertStatus -eq "active") {

#Work out Amount Of Days Until Expiry

$TodayDate = Get-Date

$TimeSpan = New-TimeSpan -Start $TodayDate -End $CertEndDate

$DaysLeft = $TimeSpan.Days

Write-Verbose "$CertID | $CertDomain | $CertStatus | $CertEndDate | Days Until Certificate Expires $DaysLeft " -Verbose

}

}

}