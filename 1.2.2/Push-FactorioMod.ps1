# https://wiki.factorio.com/Mod_upload_API

function Push-FactorioMod {
    param (
        [Parameter(Mandatory=$true)][string]$APIKey = $env:factorio_mod_APIKey,
        [Parameter(Mandatory=$true)][string]$Name
    )
    
    $Path = [System.IO.FileInfo]"$env:AppData\Factorio\mods\${Name}_$((Get-Content -Path "$env:factorio_repo_dir\$Name\$env:factorio_repo_subdir\info.json" | ConvertFrom-JSON -Depth 100).version).zip"

    try {
        $init_upload_response = Invoke-RestMethod -Uri "https://mods.factorio.com/api/v2/mods/releases/init_upload" -Method POST -Body @{ mod = $Name } -Headers @{ Authorization = "Bearer $APIKey" }
    } catch {
        return $_
    }

    try {
        return [System.Net.Http.HttpClient]::new().PostAsync($init_upload_response.upload_url,([System.Net.Http.MultipartFormDataContent]::new()).Add(([System.Net.Http.StreamContent]::new(([System.IO.MemoryStream]::new(@([System.IO.File]::ReadAllBytes($Path.FullName)))))),"file",$Path.Name)).Result
    }
    catch {
        return $_
    }
}
