cls

$myClassDef = @"
    public class MyClass
    {
      public int DoSomething(int i){return i;}
    }
"@
Add-Type -TypeDefinition $myClassDef
$myClass = New-Object MyClass
$myClass.Dosomething(666);
