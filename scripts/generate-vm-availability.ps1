# This script generates the data with the size availability for the Azure regions in the 'data' folder. Please use this 
# script only for personal needs - for the purposes of the task valication, some of the files in the 'data' folder 
# were updated manually after the generation, and if solution would be submitted without those manuall changes to the 
# source data - some of the tests will fail.    

$dataFolderPath = "$PWD/data"

$locations = Get-AzLocation 
foreach ($location in $locations) { 
    $sizes = Get-AzVMSize -Location $location.DisplayName -ErrorAction SilentlyContinue 
    if ($sizes) { 
        $sizes | ConvertTo-Json | Out-File "$dataFolderPath/$($location.Location).json"
    }
}
