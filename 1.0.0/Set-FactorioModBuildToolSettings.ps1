function Set-FactorioModBuildToolSettings {
    param(
        [string]$RepositoryPath,
        [string]$RepositorySubPath,
        [string]$SteamURI = 'steam://run/427520',
        [string]$EXE = 'C:\Program Files (x86)\steam\steamapps\common\Factorio\bin\x64\factorio.exe',
        [string]$Author = $env:username,
        [string]$SPDXPreferredLicense = 'MIT'
    )
    [Environment]::SetEnvironmentVariable('factorio_repo_dir', $RepositoryPath, 'User')
    [Environment]::SetEnvironmentVariable('factorio_repo_subdir', $RepositorySubPath, 'User')
    [Environment]::SetEnvironmentVariable('factorio_steamuri', $SteamURI, 'User')
    [Environment]::SetEnvironmentVariable('factorio_exe', $EXE , 'User')
    [Environment]::SetEnvironmentVariable('factorio_mod_author', $Author, 'User')
    [Environment]::SetEnvironmentVariable('preferred_software_license', $SPDXPreferredLicense, 'User')
}