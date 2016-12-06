## What does this script do?

[![NuGet](https://img.shields.io/nuget/v/SmartB.Squirrel.Scripts.svg?style=flat-square)](https://www.nuget.org/packages/SmartB.Squirrel.Scripts)


Basically this script is a shortcut for publishing/generating  [Squirrel](https://github.com/Squirrel/Squirrel.Windows) packages.

1. Compile the selected project in release mode
1. Create the nuget package for your project
1. Releasify
1. Open the file explorer with the generated files.

When working with squirrel, this is very time consuming so the script does all this for you automatically.

## Installation


Get the package via [nuget](https://www.nuget.org/packages/SmartB.Squirrel.Scripts)

    Install-Package SmartB.Squirrel.Scripts
    
:information_source: Make sure that your .csproj name matches your .nuspec name. 
For example if you have MyProject.csproj you must have MyProject.nuspec in your project's root

## Usage 

1. Choose the project you want to releasify in the nuget package manager
1. Run the following command
```powershell
New-Squirrel -version <version>
New-Squirrel -version <version> -project <project> # Or specify the project name (Default is current)
```

## Contributing

Please feel free to contribute or give me a thumbs up if this script worked for you.
You can build the nuget package using the .bat script
