$P = Import-Csv ./Data/simple-sample.csv -Delimiter ',' 
Write-Output "Imported CSV...", $P

$P | Group-Object Id -ov grp |

Group-Object Id -ov grp | ForEach-Object {
    Write-Output "-->",$_.Group
    ForEach ($ii in $_.Group) {
        Write-Output "***>",$ii
    }
   }
#  $contacts = foreach ($Phone in $_.Group) {
#   $ExecutionContext.InvokeCommand.ExpandString($entryTemplate)  

