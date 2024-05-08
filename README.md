# Working With Objects in Powershell

What a life! You sent the cost estimates to your investors, and they were not very happy about the numbers. Investors are planning for the application growth; with more users, you will need more VMs, and with more VMs, the cost of one VM will make a bigger impact on the total bill for the cloud infrastructure. They said to you that they invest in your startup if you find a way to cut costs twice for a single VM. After some research, you found this [new ARM-based VM size famiily](https://learn.microsoft.com/en-us/azure/virtual-machines/bpsv2-arm), which might do the trick, but it is not available in all regions yet. 

For this task, you need to write a script that will help you find regions where the VM size you need is available.

## Prerequisites

Before completing any task in the module, make sure that you followed all the steps described in the **Environment Setup** topic, in particular: 

1. Ensure you have an [Azure](https://azure.microsoft.com/en-us/free/) account and subscription.

2. Install [PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4) on your computer. All tasks in this module use Powershell 7. To run it in the terminal, execute the following command: 
    ```
    pwsh
    ```

3. Install [Azure module for PowerShell 7](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-11.3.0): 
    ```
    Install-Module -Name Az -Repository PSGallery -Force
    ```
If you are a Windows user, before running this command, please also run the following: 
    ```
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

4. Log in to your Azure account using PowerShell:
    ```
    Connect-AzAccount -TenantId <your Microsoft Entra ID tenant id>
    ```

## Requirements

In this task, you will need to write a Powershell script, which looks for regions where particular VM size (`Standard_B2pts_v2`) is available for use: 

- Write a Powershell script, which implements task requirements in this repo's file `task.ps1`.  

- Folder `data` in this repository contains a set of JSON files. Each file is named after the Azure region and contains a list of VM sizes available in the region. 

- Script should loop through the files. In each file, the script should convert data from JSON to a list of objects and search for the object that represents VM size `Standard_B2pts_v2`. If such object was found — the region name should be added to the result list of regions. 

- Result list of regions should be exported by script in JSON format to file `result.json` in this repository. Here how the file should look like:
    ```
        [
            "australiaeast",
            "canadacentral",
            ...
            "westus3"
        ]
    ```

After testing the script locally, make sure that the `result.json` is not committed to the repository (**otherwise validation will fail**), and submit the solution for review.  

## Hints 

- Use `Get-ChildItem` to get a list of files in the `data` directory. Feel free to explore the properties of the returned objects - they have separate properties for the full file path (suitable for the `Get-Content` command) and for the file name (handy if you need the file name). 

- You can get a region name by cutting a suffix '.json' from the file name. In Powershell, you can cut a substring from a string just by using the 'Replace()' method of the string variable or property:
  
    ```
        $stringVariable = "filename.json"
        $stringVariable = $stringVariable.Replace('.json', '')
        Write-Host $stringVariable
    ```
