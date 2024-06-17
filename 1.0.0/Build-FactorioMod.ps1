function Build-FactorioMod {
    param(
        [string]$ModName,
        [string]$Version,
        [switch]$Launch
    )

    $ModDirectory = "$env:factorio_repo_dir\$ModName\$env:factorio_repo_subdir"
    $GitDirectory = "$env:factorio_repo_dir\$ModName"

    Write-Host "Incrementing build number"
        $BuildFile = Get-Content -Path "$GitDirectory\Build.json" | ConvertFrom-JSON -Depth 100
        $BuildFile.BuildNo++
        $BuildFile | ConvertTo-JSON -Depth 100 | Out-File -FilePath "$GitDirectory\Build.json"

    if ($Launch) {
        Write-Host "Force-closing factorio"
            Stop-Process -Name 'factorio' -Force -ErrorAction SilentlyContinue
    }

    Write-host "Getting Details from ${ModDirectory}\info.json"
        $info = Get-Content -Path "${ModDirectory}\info.json" | ConvertFrom-JSON -Depth 100
        if ( $Version ) {
            $info.version = $Version
            $info | ConvertTo-JSON -Depth 100 | Out-File -FilePath "${ModDirectory}\info.json" -Force
        }
        $Version = $info.version

    Write-Host "Compiling the following Factorio mod:"
        $info
        
    Write-Host "Copying files to $env:temp\${ModName}_${Version}"
        New-Item -Path "$env:temp\" -Name "${ModName}_${Version}" -ItemType Directory -Force
        Copy-Item -Path "${ModDirectory}\*" -Destination "$env:temp\${ModName}_${Version}" -Recurse -Force

    Write-Host "Creating mod archive"
        Compress-Archive -Path "$env:temp\${ModName}_${Version}" -DestinationPath "$env:AppData\Factorio\mods\${ModName}_${Version}.zip" -Force

    Write-Host "Cleaning up"
        Remove-Item -Path "$env:temp\${ModName}_${Version}" -Recurse -Force

    if ($Launch) {
        Write-Host "Waiting 10 seconds for steam to catch up, and then launching game"
            Start-Sleep -Seconds 10
            Start-Process -FilePath $env:factorio_exe -ArgumentList @('--load-game','"Lab.zip"')
            # Cometimes helps with the console not rendering once the game hands off the console back to the user.
            Start-Sleep -Seconds 10
    }
    Write-Host "Done."
}
