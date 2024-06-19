function Build-FactorioMod {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [string]$Version,
        [switch]$Launch
    )

    $GitDirectory = "$env:factorio_repo_dir\$Name"
    $ModDirectory = "$GitDirectory\$env:factorio_repo_subdir"

    if ($Launch) {
        Write-Host "Force-closing factorio"
            Stop-Process -Name 'factorio' -Force -ErrorAction SilentlyContinue
    }

    Write-host "Getting Details from ${ModDirectory}\info.json"
        $info = Get-Content -Path "${ModDirectory}\info.json" | ConvertFrom-JSON -Depth 100

        $Version = $info.version.split('.')[0,1] -join '.'
        $Build = [int]$info.version.split('.')[2]
        $Build++
        $info.version = "$Version.$Build"
        $Version = $info.version

        $info | ConvertTo-JSON -Depth 100 | Out-File -FilePath "${ModDirectory}\info.json"

    Write-Host "Compiling the following Factorio mod:"
        $info
        
    Write-Host "Copying files to $env:temp\${Name}_${Version}"
        [void](New-Item -Path "$env:temp\" -Name "${Name}_${Version}" -ItemType Directory -Force)
        Copy-Item -Path "${ModDirectory}\*" -Destination "$env:temp\${Name}_${Version}" -Recurse -Force

    Write-Host "Creating mod archive"
        Compress-Archive -Path "$env:temp\${Name}_${Version}" -DestinationPath "$env:AppData\Factorio\mods\${Name}_${Version}.zip" -Force

    Write-Host "Cleaning up"
        Remove-Item -Path "$env:temp\${Name}_${Version}" -Recurse -Force

    if ($Launch) {
        Write-Host "Waiting 10 seconds for steam to catch up, and then launching game"
            Start-Sleep -Seconds 3
            Start-Process -FilePath $env:factorio_exe -ArgumentList @('--load-game','"Lab.zip"')
            # Cometimes helps with the console not rendering once the game hands off the console back to the user.
            Start-Sleep -Seconds 3
    }
    Write-Host "Done."
}
