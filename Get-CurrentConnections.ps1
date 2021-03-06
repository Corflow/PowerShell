﻿function Get-CurrentConnections
{
<#
.Synopsis
   This function gets the current connection count from IIS Web Servers. 
   If you do not use the -SiteName switch then it returns the Total connections to the web server.
.DESCRIPTION
   This function gets the current connection count from IIS Web Servers. 
   If you do not use the -SiteName switch then it returns the Total connections to the web server.
   You can run it against multiple servers but they will all return the default Total connections. 
.EXAMPLE
PS C:\> Get-CurrentConnections BNA-PR-GW-WEB34

Computer Name   Timestamp           Current Connections
-------------   ---------           -------------------
BNA-PR-GW-WEB34 2/1/2016 8:11:52 AM                  97
.EXAMPLE
PS C:\> Get-CurrentConnections BNA-PR-GW-WEB34 -SiteName MT_136087

Computer Name   Timestamp           Current Connections
-------------   ---------           -------------------
BNA-PR-GW-WEB34 2/1/2016 8:14:55 AM                  51
.EXAMPLE
$POD3 = Get-Content \\bna-vm-fs2\Public\_\Servers\PrimeSuite\Prod_Web_POD3.txt

PS C:\> Get-CurrentConnections $POD3

Computer Name               Timestamp           Current Connections
-------------               ---------           -------------------
BNA-PR-GW-WEB31.HWWIN.local 2/1/2016 8:15:41 AM                   3
BNA-PR-GW-WEB32.HWWIN.local 2/1/2016 8:15:51 AM                  38
BNA-PR-GW-WEB33.HWWIN.local 2/1/2016 8:15:59 AM                  30
BNA-PR-GW-WEB34.HWWIN.local 2/1/2016 8:16:07 AM                  96
#>
    [CmdletBinding()]
    Param
    (
        # Enter computer to query.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$ComputerName,

        [string]$SiteName="_total",

        # Create an error log?
        [int]
        $ErrorLog
    )

    Begin
    {
    }
    Process
   {
        foreach ($computer in $ComputerName)
        {
        Write-Verbose "Querying $computer"

            Try
                {
                $everything_ok = $true

                $os = Get-WmiObject -Class Win32_OperatingSystem `
                        -ComputerName $computer `
                        -erroraction Stop
                } 
            Catch
                {
                $everything_ok = $false
                Write-Warning "Failed to query $computer with the following error:
                $_"
                    if ($LogErrors)
                    {
                    Write-Output "$Date - $computer was unable to be reached. Error = $_" | Out-File $ErrorLog -Append
                    Write-Warning "Errors logged to $ErrorLog"
                    }
                }

            if ($everything_ok)
                {
                
                Get-Counter "\\$computer\web service($SiteName)\current connections" `
                | select @{Name="Computer Name";Expression={$computer}}, "Timestamp", @{Name="Current Connections";Expression={$_.CounterSamples[0].CookedValue}}
                
                }

            Write-Verbose "Query on $computer is complete."

        
        }  
    }
    End
    {
    }
}