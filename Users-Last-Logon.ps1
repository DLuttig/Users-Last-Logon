$NumDays = 0
 $LogDir = "C:\temp\Users-Last-Logon.csv"

$currentDate = [System.DateTime]::Now
 $currentDateUtc = $currentDate.ToUniversalTime()
 $lltstamplimit = $currentDateUtc.AddDays(- $NumDays)
 $lltIntLimit = $lltstampLimit.ToFileTime()
 $adobjroot = [adsi]''
 $objstalesearcher = New-Object System.DirectoryServices.DirectorySearcher($adobjroot)
 $objstalesearcher.filter = "(&(objectCategory=person)(objectClass=user)(lastLogonTimeStamp<=" + $lltIntLimit + "))"
 $objstalesearcher.PageSize=4000

$users =  $objstalesearcher.findall() | select `
 @{e={$_.properties.cn};n='Display Name'},`
 @{e={$_.properties.samaccountname};n='Username'},`
 @{e={$_.properties.mail};n='Email'},`
 @{e={[datetime]::FromFileTimeUtc([int64]$_.properties.lastlogontimestamp[0])};n='Last Logon'},`
 @{e={[datetime]::FromFileTimeUtc([int64]$_.properties.pwdlastset[0])};n='Password Last set'},`
 @{e={[string]$adspath=$_.properties.adspath;$account=[ADSI]$adspath;$account.psbase.invokeget('AccountDisabled')};n='Account Is Disabled'}

$users  | Export-CSV -NoType $LogDir