function New-FactorioMod {
    param(
        [string]$Title = "Factorio-Mod-$("{0:X6}" -f $(Get-Random -Minimum 0x100000 -Maximum 0xFFFFFF))",
        [string]$Description = "GenericDescription",
        [string]$Version = '1.0.0',
        [string]$FactorioVersion = '1.1',
        [string]$Author = $env:factorio_mod_author,
        [string]$Contact,
        [string]$Homepage,
        [string]$SPDXLicenseID = 'MIT',
        [string[]]$Dependencies = @("base >= 1.1"),
        [string]$Name = $($Title.ToLower() -Replace ' ','-'),
        [switch]$NoCD,
        [switch]$Git
    )

    $ModInfo = [PSCustomObject]@{
        name                = $Name
        version             = $Version
        title               = $Title
        author              = $Author
        contact             = $Contact
        homepage            = $Homepage
        factorio_version    = $FactorioVersion
        description         = $Description
        dependencies        = $Dependencies
    }

    [string[]]$Locales          = @('ab','aa','af','ak','sq','am','ar','an','hy','as','av','ae','ay','az','bm','ba','eu','be','bn','bi','bs','br','bg','my','ca','ch','ce','ny','zh','cu','cv','kw','co','cr','hr','cs','da','dv','nl','dz','en','eo','et','ee','fo','fj','fi','fr','fy','ff','gd','gl','lg','ka','de','el','kl','gn','gu','ht','ha','he','hz','hi','ho','hu','is','io','ig','id','ia','ie','iu','ik','ga','it','ja','jv','kn','kr','ks','kk','km','ki','rw','ky','kv','kg','ko','kj','ku','lo','la','lv','li','ln','lt','lu','lb','mk','mg','ms','ml','mt','gv','mi','mr','mh','mn','na','nv','nd','nr','ng','ne','no','nb','nn','ii','oc','oj','or','om','os','pi','ps','fa','pl','pt','pa','qu','ro','rm','rn','ru','se','sm','sg','sa','sc','sr','sn','sd','si','sk','sl','so','st','es','su','sw','ss','sv','tl','ty','tg','ta','tt','te','th','bo','ti','to','ts','tn','tr','tk','tw','ug','uk','ur','uz','ve','vi','vo','wa','cy','wo','xh','yi','yo','za','zu')
    [string[]]$LocaleSections   = @('achievement-description','achievement-name','ammo-category-name','autoplace-control-names','controls','damage-type-name','decorative-name','entity-description','entity-name','equipment-name','fluid-name','fuel-category-name','item-description','item-group-name','item-limitation','item-name','map-gen-preset-description','map-gen-preset-name','mod-description','mod-name','modifier-description','programmable-speaker-instrument','programmable-speaker-note','recipe-name','shortcut','story','string-mod-setting','technology-description','technology-name','tile-name','tips-and-tricks-item-description','tips-and-tricks-item-name','virtual-signal-description','virtual-signal-name')

    $sb = [System.Text.StringBuilder]::new()
    forEach ($LocaleSection in $LocaleSections) {
        [void]$sb.AppendLine("[$LocaleSection]")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("")
    }
    [string]$LocaleFileContent = $sb.ToString()

    $ModDirectory = "$env:factorio_repo_dir\$Name\$env:factorio_repo_subdir"
    $GitDirectory = "$env:factorio_repo_dir\$Name"

    Write-Host "Getting the license"
        $License = Invoke-RESTMethod -uri "https://spdx.org/licenses/${SPDXLicenseID}.txt" -Replace '<year>',"$((get-Date).Year)" -Replace '<copyright holders>',"$Author"
    Write-Host "Creating mod folder"
        New-Item -Path $env:factorio_repo_dir -Name $Name -ItemType Directory
    Write-Host "Writing license file to main folder"
        $License | Out-File -FilePath "$GitDirectory\LICENSE"
    Write-Host "Creating mod subdirectory"
        New-Item -Path $GitDirectory -Name $env:factorio_repo_subdir -ItemType Directory
    Write-Host "Creating mod license file"
        $License | Out-File -FilePath "$ModDirectory\LICENSE"
    Write-Host "Info.json contents generated:"
        $ModInfo
        $ModInfo | ConvertTo-JSON -Depth 100 | Out-File -FilePath "$ModDirectory\info.json"
    Write-Host "Creating build file"
        [PSCustomObject]@{ BuildNo = 0 } | ConvertTo-JSON -Depth 100 | Out-File -FilePath "$GitDirectory\Build.json"

    Write-Host "Creating mod files"
        Write-Host "Creating locale files"
        New-Item -Path "$ModDirectory" -Name "locale" -ItemType Directory
        foreach ($locale in $Locales) {
            New-Item -Path "$ModDirectory\locale"         -Name "$locale"     -ItemType Directory
            New-Item -Path "$ModDirectory\locale\$Locale" -Name "strings.cfg" -ItemType File
            $LocaleFileContent | Out-File -FilePath "$ModDirectory\locale\$Locale\strings.cfg"
        }

        New-Item -Path "$ModDirectory"              -Name "graphics"        -ItemType Directory
        New-Item -Path "$ModDirectory"              -Name "prototypes"      -ItemType Directory
        New-Item -Path "$ModDirectory\prototypes"   -Name "tech.lua"        -ItemType File
        New-Item -Path "$ModDirectory\prototypes"   -Name "mod_object.lua"  -ItemType File
        New-Item -Path "$ModDirectory"              -Name "data.lua"        -ItemType File
        New-Item -Path "$ModDirectory"              -Name "settings.lua"    -ItemType File

    Push-Location -Path $GitDirectory

    if ($Git) {
        git init -b main
        git add .
        git commit -m "Initial commit"
    }

    if ($NoCD) {
        Pop-Location
    }
}
