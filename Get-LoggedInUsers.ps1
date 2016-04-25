﻿function Get-LoggedInUsers
{
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$ComputerName
    )

    Begin
    {
    }
    Process
    {
        foreach($Computer in $ComputerName)
        {
        Get-TerminalSession -ComputerName $computer `
        | select Server, State, ClientAddress, Id, UserName
        }
    }
    End
    {
    }
}