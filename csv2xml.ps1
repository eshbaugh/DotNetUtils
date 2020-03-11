
# Format output row as ...
#  <contact firstname="Bob" lastname="Smith" email="Bobs@email.com" Phone="1111" room="Suite 101" id="1"/>
$entryTemplate = @'
firstname="$($row.Group.Firstname)" lastname="$($row.Group.Lastname)" email="$($row.Group.Email)" phone="$($row.Group.Phone)" room="$($row.Group.Room)" id="$($row.Group.id)"
'@

$docTemplate = @'
<contact $($contacts -join "`n") />
'@

$P = Import-Csv ./Data/simple-sample.csv -Delimiter ',' 
Write-Output "Imported CSV...", $P

$P | Group-Object Id -ov grp |

Group-Object Id -ov grp | ForEach-Object {
#    Write-Output "-->",$_.Group
    $contacts = ForEach ($row in $_.Group) {
#        Write-Output "***>",$ii.Group

        $ExecutionContext.InvokeCommand.ExpandString($entryTemplate)  

    }
}

Write-Output "Out:", $contacts

$ExecutionContext.InvokeCommand.ExpandString($docTemplate) | 
  Set-Content -LiteralPath ./Data/out-file.xml



#  $contacts = foreach ($Phone in $_.Group) {
#   $ExecutionContext.InvokeCommand.ExpandString($entryTemplate)  


# Original Code with issue 
<#

$docTemplate = @'
<contact $($contacts -join "`n") />
'@
$entryTemplate = @'
Firstname ="$($Phone.Firstname)" Lastname= "$($Phone.Lastname) Email= "$($Phone.Email) Phone= "$($Phone.Phone)" Room= "$($Phone.Room)" Phone= "$($Phone.Phone)"
'@

Import-Csv Test.csv -Delimiter ',' | Group-Object Id -ov grp | ForEach-Object {
  $contacts = foreach ($Phone in $_.Group) {
    $ExecutionContext.InvokeCommand.ExpandString($entryTemplate)  
  }
 $ExecutionContext.InvokeCommand.ExpandString($docTemplate) } | 
  Set-Content -LiteralPath file.xml

#>


#Desired Output ...
#<?xml version="1.0" encoding="UTF-8"?>
#<TSP version="1.1">
#    <contact firstname="Bob" lastname="Smith" email="Bobs@email.com" Phone="1111" room="Suite 101" id="1"/>
#    <contact firstname="John" lastname="Doe" email="John@email.com" phone="2222" room="Suite 102" id="2"/>
#</TSP>

#Output produced by original code...
#<contact Firstname ="Bob" Lastname= "Smith Email= "Bobs@email.com Phone= "1111" Room= "Suite 101" Phone= "1111" />
#<contact Firstname ="John" Lastname= "Doe Email= "John@email.com Phone= "2222" Room= "Suite 102" Phone= "2222" />