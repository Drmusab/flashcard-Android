$Adb = 'D:\AnkiStudioRecovery-01a1cc75\android-sdk\platform-tools\adb.exe'
$SyncSerial = 'emulator-5582'
$SyncEvidence = Join-Path $PSScriptRoot 'evidence'
function Invoke-SyncAdb {
    $arguments = @($args)
    $output = & $Adb -s $SyncSerial @arguments 2>&1
    $code = $LASTEXITCODE
    [pscustomobject]@{utc=[DateTime]::UtcNow.ToString('o');operation=$arguments[0];argumentCount=$arguments.Count;exit=$code} |
        ConvertTo-Json -Compress | Add-Content (Join-Path $SyncEvidence 'codex04-sync-commands.jsonl')
    if ($code -ne 0) { throw "ADB operation failed with exit $code; response not logged" }
    $output
}
function Get-SyncUi {
    param([string]$Tag)
    $activity = (Invoke-SyncAdb shell dumpsys activity activities | Select-String 'topResumedActivity' | Out-String)
    if ($activity -match 'AccountActivity') { throw 'Account/login UI capture is prohibited' }
    if ($activity -notmatch 'com.ichi2.anki.debug|com.android.launcher3|android/.+Resolver') { throw 'Unexpected UI; no capture performed' }
    Invoke-SyncAdb shell uiautomator dump /data/local/tmp/codex04-window.xml | Out-Null
    $raw = Invoke-SyncAdb shell cat /data/local/tmp/codex04-window.xml
    Invoke-SyncAdb shell rm -f /data/local/tmp/codex04-window.xml | Out-Null
    [xml]$doc = $raw -join "`n"
    if ($doc.SelectNodes('//node') | Where-Object {$_.'resource-id' -match 'id/(username|password)' -or $_.'password' -eq 'true'}) {
        $raw=$null; $doc=$null; throw 'Sensitive fields detected; no UI evidence saved'
    }
    foreach ($node in $doc.SelectNodes('//node')) {
        foreach ($attribute in @('text','content-desc')) {
            $value=$node.GetAttribute($attribute)
            $value=[regex]::Replace($value,'(?i)[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}','[REDACTED_EMAIL]')
            $value=[regex]::Replace($value,'(?i)\b[a-f0-9]{32,}\b','[REDACTED_TOKEN]')
            $node.SetAttribute($attribute,$value)
        }
    }
    $doc.Save((Join-Path $SyncEvidence "codex04-ui-$Tag.xml"))
    $doc
}
function Show-SyncUi {
    param([string]$Tag)
    $doc=Get-SyncUi $Tag
    $doc.SelectNodes('//node') | Where-Object {$_.'text' -or $_.'content-desc'} |
        ForEach-Object {[pscustomobject]@{text=$_.'text';id=$_.'resource-id';description=$_.'content-desc';bounds=$_.'bounds'}} |
        Format-Table -AutoSize | Out-String -Width 200
}
function Tap-SyncNode {
    param([string]$Tag,[string]$Attribute,[string]$Value)
    for ($trial=1; $trial -le 8; $trial++) {
        $doc=Get-SyncUi "$Tag-attempt$trial"
        $nodes=@($doc.SelectNodes('//node') | Where-Object {$_.GetAttribute($Attribute) -eq $Value -and $_.'enabled' -eq 'true'})
        if ($nodes.Count -gt 1) { throw 'Ambiguous UI target; no action performed' }
        if ($nodes.Count -eq 1) {
            $c=@([regex]::Matches($nodes[0].'bounds','\d+') | ForEach-Object {[int]$_.Value})
            Invoke-SyncAdb shell input tap ([int](($c[0]+$c[2])/2)) ([int](($c[1]+$c[3])/2)) | Out-Null
            return
        }
        Start-Sleep -Milliseconds 250
    }
    throw 'Expected enabled UI target did not appear within bounded wait'
}
