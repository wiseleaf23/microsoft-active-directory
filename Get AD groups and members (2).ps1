#Inform host, request information
    $CSVpath = Read-Host -Prompt "Please enter path to CSV file to export to, for example `"C:\Contoso\ADGroupsAndMembers.csv`""
    $Searchbase = Read-Host -Prompt "Please enter the OU you want to export the groups from, for example `"ou=Groups,ou=Contoso,dc=contoso,dc=com`""
    $Recursive = Read-Host -Prompt "Recursive? y/n"
    Write-Host ""

#Functions


#Get the AD groups
    Write-Host "Getting AD groups..."
    $ADgroups = Get-ADGroup -Filter * -SearchBase $Searchbase

#Get AD groups an members based on recursive y/n
    Switch ($Recursive) {
        "y" {
            Write-Host "Running commands recursive" -ForegroundColor Green
            $Results = foreach($ADGroup in $ADGroups) {
                Get-ADGroupMember -Identity $ADGroup -Recursive | foreach {
                    [pscustomobject]@{
                        GroupName = $ADGroup.Name
                        Name = $_.Name
                        SamAccountName = $_.SamAccountName
                    }
                }
            }
        }
 
        "n" {
            Write-Host "Running commands running non-recursive" -ForegroundColor Green
            $Results = foreach($ADGroup in $ADGroups) {
                Get-ADGroupMember -Identity $ADGroup | foreach {
                    [pscustomobject]@{
                        GroupName = $ADGroup.Name
                        Name = $_.Name
                        SamAccountName = $_.SamAccountName
                    }
                }
            }
        }
 
        default {Write-Error "No selection made for recursive"}
    }

#Export results
    $Results | Export-CSV $CSVpath -NoTypeInformation
