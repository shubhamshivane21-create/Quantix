$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Write-Host "Run this from an ADMINISTRATOR PowerShell."; exit 1 }

Set-Location "C:\Users\subham\Quantix"
powershell -ExecutionPolicy Bypass -File "C:\Users\subham\Quantix\build.ps1"
if ($LASTEXITCODE -ne 0) { Write-Host "Build failed, not deploying."; exit 1 }

$src = "C:\Users\subham\Quantix\build\quantix"
$roots = @(
  "C:\Program Files\Apache Software Foundation\Tomcat 10.1",
  "C:\Program Files\Apache Software Foundation\Tomcat 10.1_Tomcat@10"
)
$services = @("Tomcat10", "Tomcat@10")

Write-Host "Stopping Tomcat..."
foreach ($s in $services) { Stop-Service $s -Force -ErrorAction SilentlyContinue }
Start-Sleep -Seconds 4

foreach ($r in $roots) {
  if (Test-Path "$r\webapps") {
    Remove-Item "$r\webapps\quantix" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$r\work\Catalina\localhost\quantix" -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item $src "$r\webapps\quantix" -Recurse
    Write-Host "Servlets in $r :"
    Get-ChildItem "$r\webapps\quantix\WEB-INF\classes\com\quantix\servlet" | Select-Object -ExpandProperty Name
  }
}

Write-Host "Starting Tomcat..."
foreach ($s in $services) { Start-Service $s -ErrorAction SilentlyContinue }
Write-Host "Done. Wait about 15 seconds, then refresh the browser."