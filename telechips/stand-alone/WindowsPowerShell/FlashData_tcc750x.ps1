param(
    [Parameter(Mandatory=$true)]
    [string]$port
)

# Define the path to fwdn_nd.exe
# When running the script,
# the fwdn executable must exist in the same path as the script.
$fwdnExecutable = ".\fwdn_nd.exe"

# Define the directory path
$directoryPath = "Z:\work1\tcc750x\boot-firmware"

# Search for all files ending with fwdn.json and boot.json
$fwdnFiles = Get-ChildItem -Path $directoryPath -Filter "tcc750x_fwdn.json"
$bootFiles = Get-ChildItem -Path $directoryPath -Filter "tcc750x_boot.json"
$snor1 = Get-ChildItem -Path $directoryPath -Filter "prebuilt\tcc750x_ap_snor.rom"
$snor2 = Get-ChildItem -Path $directoryPath -Filter "prebuilt\tcc750x_sic_snor.rom"

# Execute additional command
$additionalFile = "Z:\work1\tcc750x\boot-firmware\SD_Data.fai"
$storageType = "emmc"

# Find fwdn.json files
foreach ($file in $fwdnFiles) {
    $fwdn = $file.FullName
}

# Find boot.json files
foreach ($file in $bootFiles) {
    $boot = $file.FullName
}

# Find snor file
foreach ($file in $snor1) {
    $ap_snor = $file.FullName
}

# Find snor file
foreach ($file in $snor2) {
    $sic_snor = $file.FullName
}

# low-format emmc
Write-Host "Executing low-format command: --low-format --storage emmc"
& $fwdnExecutable --fwdn $fwdn --low-format --storage emmc --port $port

Write-Host "Download boot firmware"
& $fwdnExecutable --fwdn $fwdn --write $boot --port $port

Write-Host "Download FAI"
& $fwdnExecutable --fwdn $fwdn --write $additionalFile --storage $storageType --area user --port $port

Write-Host "Download SIC SNOR"
& $fwdnExecutable --fwdn $fwdn --write $sic_snor --storage snor --area die2 --port $port

Write-Host "Download AP SNOR"
& $fwdnExecutable --fwdn $fwdn --write $ap_snor --storage snor --area die1 --port $port
