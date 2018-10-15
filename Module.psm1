Function Add-Numbers($x,$y)
{
    $x+$y
}
Function Substract-Numbers($x,$y)
{
    $x-$y
}

New-Alias -Name an -Value Add-Numbers
New-Alias -Name sn -Value Substract-Numbers

Export-ModuleMember -Function * -Alias *