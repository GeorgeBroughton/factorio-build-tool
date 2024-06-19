@{
    RootModule = 'factorio-mod-buildtool.psm1'
    ModuleVersion = '1.2.2'
    CompatiblePSEditions = 'Core', 'Desktop'
    GUID = 'f673e147-bb5f-44fd-9706-ba17cd966b5f'
    Author = 'Mr. George Daniel Broughton TMIET'
    CompanyName = 'Not Applicable'
    Copyright = '2024 George Daniel Broughton TMIET (MIT-License)'
    Description = 'Provides tools for modding a video game called Factorio'
    PowerShellVersion = '7.4.2'
    FunctionsToExport = 'Set-FactorioModBuildToolSettings','New-FactorioMod','Build-FactorioMod','Remove-FactorioModBuildToolSettings','Push-FactorioMod'
    CmdletsToExport = '*'
    VariablesToExport = '*'
    AliasesToExport = 'Set-FBTSettings','New-FBTMod','Build-FBTMod','Remove-FBTSettings','Push-FBTMod'
    PrivateData = @{
        PSData = @{
            Tags = 'Factorio (Game)', 'Modding Tool'
            LicenseUri = 'https://en.wikipedia.org/wiki/MIT_License'
            ProjectUri = 'https://github.com/GeorgeBroughton/factorio-build-tool'
            ReleaseNotes = ''
        } 
    } 
}