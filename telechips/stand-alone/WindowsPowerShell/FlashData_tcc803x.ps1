# Define the path to fwdn.exe
# When running the script,
# the fwdn executable must exist in the same path as the script.
$fwdnExecutable = ".\fwdn.exe"

# Define the directory path
$directoryPath = "Z:\work1\tcc803x\boot-firmware"

# Search for all files ending with fwdn.json and boot.json
$fwdnFiles = Get-ChildItem -Path $directoryPath -Filter "tcc803x_fwdn.json"
$bootFiles = Get-ChildItem -Path $directoryPath -Filter "tcc803x_boot.json"

# Execute fwdn.json files
foreach ($file in $fwdnFiles) {
    Write-Host "Executing file: $($file.FullName) (command: --fwdn)"
    & $fwdnExecutable --fwdn $file.FullName
}

# low-format
Write-Host "Executing low-format command: --low-format --storage emmc"
& $fwdnExecutable --low-format --storage emmc

# Execute boot.json files
foreach ($file in $bootFiles) {
    Write-Host "Executing file: $($file.FullName) (command: --write)"
    & $fwdnExecutable --write $file.FullName
}

# Execute additional command
$additionalFile = "Z:\work1\tcc803x\boot-firmware\SD_Data.fai"
$storageType = "emmc"
$storageArea = "user"

Write-Host "Executing additional command: $additionalFile (command: --write --storage $storageType --area $storageArea)"
& $fwdnExecutable --write $additionalFile --storage $storageType --area $storageArea
