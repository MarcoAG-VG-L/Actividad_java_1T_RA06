$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceFile = Join-Path $projectRoot "Factorial.java"
$htmlOutput = Join-Path $projectRoot "docs\javadoc"
$formatOutput = Join-Path $projectRoot "docs\formatos"

if (-not (Test-Path $sourceFile)) {
    throw "No se encuentra el código fuente: $sourceFile"
}

$javadocExe = $env:JAVADOC_EXE
if ([string]::IsNullOrWhiteSpace($javadocExe)) {
    $javadocCommand = Get-Command javadoc -ErrorAction SilentlyContinue
    if ($javadocCommand) {
        $javadocExe = $javadocCommand.Source
    }
    elseif (Test-Path "C:\Program Files\Java\jdk-27\bin\javadoc.exe") {
        $javadocExe = "C:\Program Files\Java\jdk-27\bin\javadoc.exe"
    }
}

if ([string]::IsNullOrWhiteSpace($javadocExe) -or -not (Test-Path $javadocExe)) {
    throw "No se encuentra javadoc. Instala un JDK o define JAVADOC_EXE."
}

New-Item -ItemType Directory -Force -Path $htmlOutput, $formatOutput | Out-Null
& $javadocExe -encoding UTF-8 -docencoding UTF-8 -charset UTF-8 -d $htmlOutput $sourceFile
if ($LASTEXITCODE -ne 0) {
    throw "Javadoc terminó con código $LASTEXITCODE."
}

$htmlFile = Join-Path $htmlOutput "Factorial.html"
if (-not (Test-Path $htmlFile)) {
    throw "Javadoc no ha generado el archivo esperado: $htmlFile"
}

$generatedHtml = [System.IO.File]::ReadAllText($htmlFile)
$requiredHtmlText = @(
    "Calcula el factorial de un número entero positivo.",
    "positivo del que se desea calcular el factorial",
    "entero de precisión arbitraria"
)
foreach ($text in $requiredHtmlText) {
    if (-not $generatedHtml.Contains($text)) {
        throw "La documentación HTML no contiene el texto esperado: $text"
    }
}

$description = "Calcula el factorial de un número entero positivo."
$parameter = "int number: entero positivo del que se desea calcular el factorial."
$returnValue = "BigInteger: factorial de number como un entero de precisión arbitraria."
$exception = "IllegalArgumentException: se lanza si number no es positivo."
$lines = @(
    "Javadoc: Factorial",
    "",
    $description,
    "",
    "Parámetro: $parameter",
    "Valor de retorno: $returnValue",
    "Excepción: $exception"
)

function ConvertTo-XmlText([string]$text) {
    return [System.Security.SecurityElement]::Escape($text)
}

function Add-ZipText($archive, [string]$entryName, [string]$content, $compressionLevel) {
    $entry = $archive.CreateEntry($entryName, $compressionLevel)
    $stream = $entry.Open()
    try {
        $writer = New-Object System.IO.StreamWriter($stream, (New-Object System.Text.UTF8Encoding($false)))
        try {
            $writer.Write($content)
        }
        finally {
            $writer.Dispose()
        }
    }
    finally {
        $stream.Dispose()
    }
}

function New-Docx([string]$path, [string[]]$paragraphs) {
    $body = foreach ($line in $paragraphs) {
        if ([string]::IsNullOrEmpty($line)) {
            "<w:p/>"
        }
        else {
            "<w:p><w:r><w:t xml:space=`"preserve`">$(ConvertTo-XmlText $line)</w:t></w:r></w:p>"
        }
    }
    $documentXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
        '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">' +
        '<w:body>' + ($body -join "") +
        '<w:sectPr><w:pgSz w:w="12240" w:h="15840"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/></w:sectPr>' +
        '</w:body></w:document>'
    $contentTypes = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">' +
        '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>' +
        '<Default Extension="xml" ContentType="application/xml"/>' +
        '<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>' +
        '</Types>'
    $relationships = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">' +
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>' +
        '</Relationships>'

    $fileStream = [System.IO.File]::Open($path, [System.IO.FileMode]::Create)
    $archive = New-Object System.IO.Compression.ZipArchive($fileStream, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        Add-ZipText $archive "[Content_Types].xml" $contentTypes ([System.IO.Compression.CompressionLevel]::Optimal)
        Add-ZipText $archive "_rels/.rels" $relationships ([System.IO.Compression.CompressionLevel]::Optimal)
        Add-ZipText $archive "word/document.xml" $documentXml ([System.IO.Compression.CompressionLevel]::Optimal)
    }
    finally {
        $archive.Dispose()
        $fileStream.Dispose()
    }
}

function New-Odt([string]$path, [string[]]$paragraphs) {
    $body = foreach ($line in $paragraphs) {
        "<text:p>$(ConvertTo-XmlText $line)</text:p>"
    }
    $contentXml = '<?xml version="1.0" encoding="UTF-8"?>' +
        '<office:document-content xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" ' +
        'xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" office:version="1.2">' +
        '<office:body><office:text>' + ($body -join "") + '</office:text></office:body></office:document-content>'
    $manifest = '<?xml version="1.0" encoding="UTF-8"?>' +
        '<manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" manifest:version="1.2">' +
        '<manifest:file-entry manifest:full-path="/" manifest:media-type="application/vnd.oasis.opendocument.text"/>' +
        '<manifest:file-entry manifest:full-path="content.xml" manifest:media-type="text/xml"/>' +
        '</manifest:manifest>'

    $fileStream = [System.IO.File]::Open($path, [System.IO.FileMode]::Create)
    $archive = New-Object System.IO.Compression.ZipArchive($fileStream, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        Add-ZipText $archive "mimetype" "application/vnd.oasis.opendocument.text" ([System.IO.Compression.CompressionLevel]::NoCompression)
        Add-ZipText $archive "content.xml" $contentXml ([System.IO.Compression.CompressionLevel]::Optimal)
        Add-ZipText $archive "META-INF/manifest.xml" $manifest ([System.IO.Compression.CompressionLevel]::Optimal)
    }
    finally {
        $archive.Dispose()
        $fileStream.Dispose()
    }
}

Add-Type -AssemblyName System.IO.Compression
$docxPath = Join-Path $formatOutput "Factorial.docx"
$odtPath = Join-Path $formatOutput "Factorial.odt"
$xmlPath = Join-Path $formatOutput "Factorial.xml"
$pdfPath = Join-Path $formatOutput "Factorial.pdf"
New-Docx $docxPath $lines
New-Odt $odtPath $lines

$xml = '<?xml version="1.0" encoding="UTF-8"?>' +
    '<documentation><title>Javadoc: Factorial</title>' +
    "<description>$(ConvertTo-XmlText $description)</description>" +
    '<parameter name="number" type="int">número entero positivo</parameter>' +
    '<returns type="java.math.BigInteger">factorial de number</returns>' +
    '<throws type="java.lang.IllegalArgumentException">el número no es positivo</throws>' +
    '</documentation>'
[System.IO.File]::WriteAllText($xmlPath, $xml, (New-Object System.Text.UTF8Encoding($false)))

$edgeExe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgeExe)) {
    $edgeExe = "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
}
if (-not (Test-Path $edgeExe)) {
    throw "No se encuentra Microsoft Edge para generar el PDF desde el HTML."
}
$profilePath = Join-Path $env:TEMP ("ra06-edge-" + [guid]::NewGuid().ToString("N"))
$htmlUri = ([System.Uri]$htmlFile).AbsoluteUri
$edgeArguments = "--headless --disable-gpu --no-first-run --disable-extensions --user-data-dir=`"$profilePath`" --print-to-pdf=`"$pdfPath`" `"$htmlUri`""
$edgeProcess = Start-Process -FilePath $edgeExe -ArgumentList $edgeArguments -Wait -PassThru
if ($edgeProcess.ExitCode -ne 0 -or -not (Test-Path $pdfPath)) {
    throw "Microsoft Edge no pudo generar el PDF desde el HTML (código $($edgeProcess.ExitCode))."
}
if (Test-Path $profilePath) {
    Remove-Item -LiteralPath $profilePath -Recurse -Force
}

Write-Host "Documentación generada en $htmlOutput y $formatOutput"
