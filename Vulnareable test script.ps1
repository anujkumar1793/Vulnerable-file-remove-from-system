# Add as many groups as deemed necessary in the variable $groups
$groups = "Everyone", "NT AUTHORITY\Authenticated Users", "Domain Users", "BUILTIN\Users"
$result = $true
$ShareList = Get-SmbShare -Special $false
if ($ShareList) 
{
  ForEach ($SmbShareName in ($ShareList).Name)
  {
    $users = Get-SmbShareAccess -Name $SmbShareName
    ForEach ($user in $users) 
    {
        if ($groups -contains $user.AccountName) 
        {
          echo ("Share $SmbShareName is *not* correctly configured allowing a share permission to the general group "+ $user.AccountName +".")
          $result = $false
        }
    }
  }
  if ($result)
  {
    echo "Your system is compliant: All shares are configured correctly not allowing a share permission to a general group."
  }
  else
  {
    echo "Your system is not compliant: One or more shares are *not* configured correctly allowing a share permission to a general group."
  } 
}
else
{
  echo "Your system is compliant: No shares are configured."
}
