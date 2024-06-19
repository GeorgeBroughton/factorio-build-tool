function Set-FactorioModBuildToolSettings {
    param(
        [string]$RepositoryPath,
        [string]$RepositorySubPath,
        [string]$EXE,
        [string]$Author,
        [string]$SPDXPreferredLicense,
        [string]$APIKey
    )
    if ($RepositoryPath)        {[Environment]::SetEnvironmentVariable('factorio_repo_dir'           ,$RepositoryPath        ,'User')}
    if ($RepositorySubPath)     {[Environment]::SetEnvironmentVariable('factorio_repo_subdir'        ,$RepositorySubPath     ,'User')}
    if ($EXE)                   {[Environment]::SetEnvironmentVariable('factorio_exe'                ,$EXE                   ,'User')}
    if ($Author)                {[Environment]::SetEnvironmentVariable('factorio_mod_author'         ,$Author                ,'User')}
    if ($SPDXPreferredLicense)  {[Environment]::SetEnvironmentVariable('preferred_software_license'  ,$SPDXPreferredLicense  ,'User')}
    if ($APIKey)                {[Environment]::SetEnvironmentVariable('factorio_mod_APIKey'         ,$APIKey                ,'User')}
}