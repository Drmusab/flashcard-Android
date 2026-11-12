. (Join-Path $PSScriptRoot 'codex04-private-android.ps1')
function Save-SyncLogicalState {
    param([int]$UserId,[string]$Directory,[string]$Tag)
    $users=Get-Content (Join-Path $SyncEvidence 'codex04-sync-users.json') -Raw | ConvertFrom-Json
    if ($UserId -notin @($users.sourceUser,$users.replicaUser) -or $UserId -eq 0) { throw 'Not a task-created sync user' }
    if (-not $Directory.StartsWith("/data/user/$UserId/com.ichi2.anki.debug/files/fsa00-sync-")) { throw 'Unexpected collection path' }
    if ($Tag -notmatch '^[a-zA-Z0-9_-]+$') { throw 'Invalid evidence tag' }
    Invoke-SyncAdb shell am force-stop --user $UserId com.ichi2.anki.debug | Out-Null
    $database="$Directory/collection.anki2"
    $counts=@("PRAGMA query_only=ON; SELECT count(*) FROM notes; SELECT count(*) FROM cards;" | & $Adb -s $SyncSerial shell -T sqlite3 $database)
    if ($LASTEXITCODE -ne 0 -or $counts.Count -ne 2 -or $counts[0] -ne '2' -or $counts[1] -ne '2') {
        throw 'Unexpected note/card counts; no collection contents exported'
    }
    $sql=@'
PRAGMA query_only=ON;
SELECT json_object(
  'notes',json((SELECT json_group_array(json_object('id',id,'guid',guid,'mid',mid,'fieldsHex',hex(flds),'tags',tags)) FROM (SELECT * FROM notes ORDER BY id))),
  'cards',json((SELECT json_group_array(json_object('id',id,'nid',nid,'did',did,'ord',ord,'type',type,'queue',queue,'due',due,'interval',ivl,'factor',factor,'repetitions',reps,'lapses',lapses,'remainingSteps',"left",'originalDue',odue,'originalDeck',odid,'flags',flags,'dataHex',hex(data))) FROM (SELECT * FROM cards ORDER BY id))),
  'reviews',json((SELECT json_group_array(json_object('id',id,'cardId',cid,'rating',ease,'interval',ivl,'previousInterval',lastIvl,'factor',factor,'timeMs',time,'type',type)) FROM (SELECT * FROM revlog ORDER BY id))),
  'decks',json((SELECT json_group_array(json_object('id',id,'name',name)) FROM (SELECT id,name COLLATE BINARY AS name FROM decks NOT INDEXED ORDER BY id))),
  'noteTypes',json((SELECT json_group_array(json_object('id',id,'name',name)) FROM (SELECT id,name COLLATE BINARY AS name FROM notetypes NOT INDEXED ORDER BY id)))
);
'@
    $raw=@($sql | & $Adb -s $SyncSerial shell -T sqlite3 $database)
    if ($LASTEXITCODE -ne 0) { throw 'Read-only native logical snapshot failed' }
    $state=($raw -join "`n") | ConvertFrom-Json -Depth 50
    foreach ($note in $state.notes) {
        $fields=[System.Text.Encoding]::UTF8.GetString([Convert]::FromHexString($note.fieldsHex)).Split([char]31)
        if ($fields[0] -notin @('SYNC_TEST_Q1','SYNC_TEST_Q2') -or $fields[1] -notin @('SYNC_TEST_A1','SYNC_TEST_A2')) {
            throw 'Unexpected note contents; no collection contents exported'
        }
        $note | Add-Member -NotePropertyName fields -NotePropertyValue @($fields)
        $note.PSObject.Properties.Remove('fieldsHex')
    }
    foreach ($card in $state.cards) {
        $text=[System.Text.Encoding]::UTF8.GetString([Convert]::FromHexString($card.dataHex))
        $decoded=if ($text) { $text | ConvertFrom-Json -Depth 40 } else { $null }
        $card | Add-Member -NotePropertyName nativeData -NotePropertyValue $decoded
        $card.PSObject.Properties.Remove('dataHex')
    }
    if ($state.reviews.Count -ne 2 -or (@($state.cards | Where-Object {$_.repetitions -ne 1})).Count) {
        throw 'Unexpected native review/repetition counts'
    }
    [pscustomobject]@{user=$UserId;collection=$Directory;appStoppedBeforeRead=$true;sqlQueryOnly=$true;capturedUtc=[DateTime]::UtcNow.ToString('o');logicalState=$state} |
        ConvertTo-Json -Depth 60 | Set-Content (Join-Path $SyncEvidence "codex04-state-$Tag.json")
    [pscustomobject]@{tag=$Tag;notes=$state.notes.Count;cards=$state.cards.Count;reviews=$state.reviews.Count;ratings=@($state.reviews.rating);repetitions=@($state.cards.repetitions)} | ConvertTo-Json -Compress
}
