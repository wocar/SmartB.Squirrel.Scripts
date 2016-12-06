function New-Squirrel
{
param(
	 [Parameter(Mandatory=$false)]
	 [Alias("Project")]
	 [string]$sistema = $((Get-Project).ProjectName),
	 [Parameter(Mandatory=$true)]
	 [string]$version
)
$packagesDir = "$((Get-Item $dte.Solution.FullName).DirectoryName)\packages\"
$project = Get-Project -all | Where-Object { $_.ProjectName -match $sistema } | select -first 1
Write-Host "Compiling '$($project.ProjectName)'"
$DTE.Solution.SolutionBuild.BuildProject("Release", $project.FullName, $true)
$projectName = $project.Name
if ($DTE.Solution.SolutionBuild.LastBuildInfo)
{
    throw "ERROR: '$projectName' failed to build."
}

$squirrel = (gci -Path "$packagesDir" -Filter "Squirrel.exe" -Recurse  | select -First 1).FullName
$nuget =  (gci -Path "$packagesDir" -Filter "nuget.exe" -Recurse  | select -First 1).FullName
if (!($nuget))
{
	Write-Error "ERROR: nuget.exe could not be found! Install-Package NuGet.CommandLine -Version 3.4.3 -projectName $projectName"
	return;
}
if(!($squirrel))
{
	Write-Error "ERROR: squirrel.exe could not be found!"
	return;
}


try
{
	$nuspecObj = Get-Item "$((get-item $project.FullName).DirectoryName)\$projectName.nuspec"  -ErrorAction Stop
}
catch{
	Write-Error "ERROR: $($projectName).nuspec could not be found!"
	return;
}


$nuspec = $nuspecObj.FullName

$nuspecPackageNameId = ([xml] (Get-Content -Path $nuspec)).package.metadata.id
Write-Output "Generating nuget '$($nuspecObj.Name.ToLower())'"

&$nuget pack $nuspec -version $version | Out-Null 
if ($lastexitcode -ne 0)
{
	throw $errorMessage
}
$nupkg = "$pwd\$nuspecPackageNameId.$version.nupkg"
$publishPath = "$pwd\publish\$projectName"

Write-Output "Generating release (id=$nuspecPackageNameId, v=$version)"


New-Item -ItemType Directory -Force -Path $publishPath  | Out-Null

&$squirrel --no-msi --releasify $nupkg -r $publishPath | Out-Null

Write-Host "Cleaning up..."
Remove-Item $nupkg
Write-Output "Ready!"
explorer $publishPath
}

Export-ModuleMember "New-Squirrel"