
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
    Write-Host "Liste des sauvegardes"
    for ($i = 0; $i -lt $FilesList.Count; $i++) {
        Write-Host ($i+1) "-" "Nom de fichier:" $FilesList[$i].BaseName "Derniere Modif:" $FilesList[$i].LastWriteTimeUtc
    }
    Write-Host "Selectionner un fichier"
    $selectId = Read-Host ">"
    Write-Host Fichier selectionné $FilesList[$selectId-1].BaseName
    return Get-Content($FilesList[$selectId-1])
}

Write-Host "Restore extension"
$SavedFiles = GetFiles

Write-Host "Nombre de fichiers sauvegarde:"$SavedFiles.Count

if ($SavedFiles.Count -le 1) 
{
    Write-Host "Il n'existe aucun fichier de sauvegarde, pensez à sauvegarder puis relancez le script." 
}
else 
{

    $lines = SelectFile($SavedFiles)
    Write-Host "Liste des extensions visual studio code (id):"
    foreach($line in $lines)
    {
        Write-Host ($extensionsCount+1)"-"$line
        $extensionsCount+=1
        $extensionsList+=$line         
    }
    Write-Host "Nombre d'extensions total:"$extensionsCount
    Write-Host "Souhaitez vous tout installer? (o/n) touche ENTREE pour quitter"
    $installEveryThing = Read-Host ">"

    if($installEveryThing -eq 'o')
    {
        foreach($extension in $extensionsList)
        {
            InstallExt($extension)
        } 
    }
    elseif ($installEveryThing -eq 'n') 
    {
        Write-Host "-- Mode d'installation --"
        Write-Host "1) mode 1: vous donnerez la liste des extensions vous souhaitez installer (idéal si le nombre d'extensions à installer est moins important)"
        Write-Host "2) mode 2: Vous donnerez la liste des extensions que vous ne souhaitez pas installer (idéal si le nombre d'extension à ne pas installer est moins important)"
        Write-Host "Choisissez le mode d'installation"
        $modeInstall = Read-Host ">"
        
        Write-Host "Donnez la liste des extensions par leur numéro, séparé par un espace (ex 15 20 32)"
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
                    Write-Host "Installation de:"  $extensionsList[$ext]
                    InstallExt($extensionsList[$ext])
                    $installLeft = $installLeft+1
                    Write-Host "Avancement:" ($installLeft) "/"  $total
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
                        Write-Host "Installation de:" $extensionsList[$i]
                        InstallExt($extensionsList[$i])
                        $installed+=1
                        Write-Host "Avancement:" $installed "/" $total "Extensions"
                    }
                    else 
                    {
                        Write-Host "L'extension :"$extensionsList[$i]" ne sera pas installé"
                    }
                }
            }
            Default { Write-Host "Erreur ce mode n'existe pas."}
        }
    }
    else 
    {
        Write-Host "Sortie."
    }
}
Write-Host "Fin du script."
#Fin
