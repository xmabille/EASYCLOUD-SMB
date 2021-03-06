function Initialize-O365OneDrive
{
    [cmdletbinding()]
    param(
     [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Users,
        [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $SPOAdminUrl
        )
        process {

            Try
            {
                #throw "Test Exception"
                Connect-SPOService -Url $SPOAdminUrl -Credential $Credential
                Request-SPOPersonalSite -UserEmails $Users -NoWait

            }

            Catch

            {
            throw "Cannot provision one drive for users: $_"

            }
        }




}