$path = "Saves"

Write-Host "Sauvegarde des extensions visual studio code (Script)"

if((Test-Path $path) -eq $false)
{
    Write-Host "Création du répetoire de sauvegarde ..."
    New-Item -ItemType directory -Path $path
}

Write-Host "Entrez le nom du fichier (ou laissez vide)"

$filename = Read-Host ">"

if(!$filename)
{
    Write-Host "Sauvegarde par défault save.txt"
    code --list-extensions > ./$path/save.txt
}
else 
{    
    code --list-extensions > ./$path/$filename.txt
    Write-Host "Sauvegarde "$filename" dans le repetoire "$path "a bien été effectué"
}
