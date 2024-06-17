function Remove-FactorioModBuildToolSettings {
    [Environment]::SetEnvironmentVariable('factorio_repo_dir'   , $null, 'User')
    [Environment]::SetEnvironmentVariable('factorio_repo_subdir', $null, 'User')
    [Environment]::SetEnvironmentVariable('factorio_steamuri'   , $null, 'User')
    [Environment]::SetEnvironmentVariable('factorio_exe'        , $null, 'User')
    [Environment]::SetEnvironmentVariable('factorio_mod_author' , $null, 'User')
}