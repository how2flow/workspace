# Define the path to fwdn.exe
$fwdnExecutable = ".\fwdn.exe"

# Define the directory path
$directoryPath = "Z:\work1\tcn100x\boot-firmware"

# Search for all files ending with fwdn.json and boot.json
$fwdnFiles = Get-ChildItem -Path $directoryPath -Filter "*fwdn.json"
$bootFiles = Get-ChildItem -Path $directoryPath -Filter "*boot.json"

# Add the new command to write the tcn100x_snor.rom file
$snorFile = "$directoryPath\prebuilt\tcn100x_snor.rom"
$snorStorageType = "snor"
$snorArea = "die1"

# Execute fwdn.json files
foreach ($file in $fwdnFiles) {
    Write-Host "Executing file: $($file.FullName) (command: --fwdn)"
    & $fwdnExecutable --fwdn $file.FullName
}

# low-format
Write-Host "Executing low-format command: --low-format --storage emmc"
& $fwdnExecutable --low-format --storage emmc
Write-Host "Executing low-format command: --low-format --storage snor"
& $fwdnExecutable --low-format --storage snor

# Download snor rom file
Write-Host "Executing additional command: $snorFile (command: --write --storage $snorStorageType --area $snorArea)"
& $fwdnExecutable --write $snorFile --storage $snorStorageType --area $snorArea

# Execute boot.json files
foreach ($file in $bootFiles) {
    Write-Host "Executing file: $($file.FullName) (command: --write)"
    & $fwdnExecutable --write $file.FullName
}

# Execute additional command
$additionalFile = "Z:\work1\tcn100x\boot-firmware\SD_Data.fai"
$storageType = "emmc"
$storageArea = "user"

Write-Host "Executing additional command: $additionalFile (command: --write --storage $storageType --area $storageArea)"
& $fwdnExecutable --write $additionalFile --storage $storageType --area $storageArea
