
$extensionsList=@()
$extensionsCount = 0
[int[]]$numInstall = [int[]]@()

function InstallExt {
    param (
        $IdExt
    )
    code --install-extension $IdExt
}
function GetFiles {
    return Get-ChildItem -Path Saves\* -Include *.txt    
}
function SelectFile {
    param (
        $FilesList
    )
    Write-Host "Saves list"
    for ($i = 0; $i -lt $FilesList.Count; $i++) {
        Write-Host ($i+1) "-" "Filename:" $FilesList[$i].BaseName "Last Write:" $FilesList[$i].LastWriteTimeUtc
    }
    Write-Host "Select file"
    $selectId = Read-Host ">"
    Write-Host Fichier selectionné $FilesList[$selectId-1].BaseName
    return Get-Content($FilesList[$selectId-1])
}

Write-Host "Restore extension"
$SavedFiles = GetFiles

Write-Host "Number of saved file:"$SavedFiles.Count

if ($SavedFiles.Count -le 1) 
{
    Write-Host "No existing save file , try to save before and retry." 
}
else 
{

    $lines = SelectFile($SavedFiles)
    Write-Host "VsCode Extensions list (id):"
    foreach($line in $lines)
    {
        Write-Host ($extensionsCount+1)"-"$line
        $extensionsCount+=1
        $extensionsList+=$line         
    }
    Write-Host "Total number of extensions:"$extensionsCount
    Write-Host "Do you want to all restore ? (y/n) press ENTER to leave"
    $installEveryThing = Read-Host ">"

    if($installEveryThing -eq 'y')
    {
        foreach($extension in $extensionsList)
        {
            InstallExt($extension)
        } 
    }
    elseif ($installEveryThing -eq 'n') 
    {
        Write-Host "-- Restore Mode --"
        Write-Host "1) mode 1: You will give the list of extensions you want to restore(recommended if number of extensions to restore is less bigger)"
        Write-Host "2) mode 2: You will five list of extensions you don't want to restore (recommended if number of extension to not restore is less bigger)"
        Write-Host "Choose restore mode"
        $modeInstall = Read-Host ">"
        
        Write-Host "Give the extensions list by they number seperate by blank space (example: 15 20 32)"
        $entrySelect = Read-Host ">"
        $entrySelect = $entrySelect -split ' '

        
        foreach($v in $entrySelect)
        {
            $numInstall+= ($v.ToInt32($null)-1)
        }

        switch ($modeInstall) {
            1 
            {   
                $installLeft = 0
                $total = $numInstall.Count
                foreach($ext in $numInstall)
                {
                    Write-Host "Restoring of:"  $extensionsList[$ext]
                    InstallExt($extensionsList[$ext])
                    $installLeft = $installLeft+1
                    Write-Host "Progress:" ($installLeft) "/"  $total
                }
            }
            2
            {  
                $total = $extensionsList.Count - $numInstall.Count
                $installed = 0
                for ($i = 0; $i -lt $extensionsList.Count; $i++) 
                {
                    if ($numInstall -notcontains $i) 
                    {
                        Write-Host "Restoring of:" $extensionsList[$i]
                        InstallExt($extensionsList[$i])
                        $installed+=1
                        Write-Host "Progress:" $installed "/" $total "Extensions"
                    }
                    else 
                    {
                        Write-Host "Extension :"$extensionsList[$i]" will not be restored"
                    }
                }
            }
            Default { Write-Host "Error this mode didn't exist."}
        }
    }
    else 
    {
        Write-Host "Exit."
    }
}
Write-Host "Script Finish"
#Fin
