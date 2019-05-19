$path = "Saves"

Write-Host "Save visual studio code extensions(Script)"

if((Test-Path $path) -eq $false)
{
    Write-Host "Creating saves directory"
    New-Item -ItemType directory -Path $path
}

Write-Host "Enter filename (without extension or let it empty)"

$filename = Read-Host ">"

if(!$filename)
{
    Write-Host "Default save in : save.txt"
    code --list-extensions > ./$path/save.txt
}
else 
{    
    code --list-extensions > ./$path/$filename.txt
    Write-Host "Save "$filename" in directory "$path "successful"
}
