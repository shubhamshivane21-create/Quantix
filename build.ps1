Set-Location "C:\Users\subham\Quantix"
$out = "build\quantix"
if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory -Path "$out\WEB-INF\classes","$out\WEB-INF\lib" | Out-Null
Copy-Item "src\main\webapp\*" $out -Recurse -Force
Copy-Item "lib\mysql-connector-j-26.7.0.jar" "$out\WEB-INF\lib\"
$files = (Get-ChildItem -Recurse src\main\java -Filter *.java).FullName
javac -d "$out\WEB-INF\classes" -cp "lib\*" $files
if ($LASTEXITCODE -eq 0) { Write-Host "Build OK" } else { Write-Host "Build FAILED"; exit 1 }
