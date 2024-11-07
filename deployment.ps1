# =========================================== Generic
Logout-AzAccount
#BDI:
#GGW:
Connect-AzAccount -Subscription GGW-Platform-EU-01 -Tenant addb9eec-467b-4ead-b011-7808eb409b59 -UseDeviceAuthentication
Set-AzContext -Subscription cd8024cb-139a-4e54-a633-2fde436594dd
Get-AzContext | FL


https://github.com/vnikolov4/ggw-azcaf-amba.git

# =========================================== Perform alzArm.json deployment
# Configuring variables for deployment
# make the needed changes in patterns\alz\alzArm.param.json
$location = "westeurope"
$pseudoRootManagementGroup = "mg-ggw-azcaf"

# Deployment for main branch, update your repo first!!!
# $TemplateUri          = https://raw.githubusercontent.com/vnikolov4/bdi-azcaf-amba/main/patterns/alz/alzArm.json
# $TemplateParameterUri = https://raw.githubusercontent.com/vnikolov4/bdi-azcaf-amba/main/patterns/alz/alzArm.param.json
New-AzManagementGroupDeployment -Name "amba-GeneralDeployment" -ManagementGroupId $pseudoRootManagementGroup -Location $location -TemplateUri "https://raw.githubusercontent.com/vnikolov4/ggw-azcaf-amba/main/patterns/alz/alzArm.json" -TemplateParameterUri "https://raw.githubusercontent.com/vnikolov4/ggw-azcaf-amba/main/patterns/alz/alzArm.param.json"
# ===========================================

# =========================================== Perform Policy remediation
$pseudoRootManagementGroup = "mg-ggw-azcaf"
$identityManagementGroup = "The management group id for Identity"
$managementManagementGroup = "The management group id for Management"
$connectivityManagementGroup = "The management group id for Connectivity"
$LZManagementGroup="mg-ggw-azcaf"

#Run the following commands to initiate remediation
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $pseudoRootManagementGroup -policyName Notification-Assets
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $pseudoRootManagementGroup -policyName Alerting-ServiceHealth
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $connectivityManagementGroup -policyName Alerting-Connectivity
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $identityManagementGroup -policyName Alerting-Identity
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $managementManagementGroup -policyName Alerting-Management
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $LZManagementGroup -policyName Alerting-KeyManagement
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $LZManagementGroup -policyName Alerting-LoadBalancing
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $LZManagementGroup -policyName Alerting-NetworkChanges
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $LZManagementGroup -policyName Alerting-RecoveryServices
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $LZManagementGroup -policyName Alerting-HybridVM
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $LZManagementGroup -policyName Alerting-Storage
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $LZManagementGroup -policyName Alerting-VM
.\patterns\alz\scripts\Start-AMBARemediation.ps1 -managementGroupName $LZManagementGroup -policyName Alerting-Web
# ===========================================

# ============================================= Build policies.json file. Regardless you’re modifying existing policies or adding new ones, you need to update the policies.bicep file.
bicep build .\patterns\alz\templates\policies.bicep --outfile .\patterns\alz\policyDefinitions\policies.json  
# ===========================================

# ====================== AMBA Clean-up ======================
# Go to the C:\DevOps\amba\bdi-azcaf-amba\patterns\alz\scripts
$pseudoRootManagementGroup = "AzureCAF"
./Start-AMBACleanup.ps1 -pseudoRootManagementGroup $pseudoRootManagementGroup -WhatIf
./Start-AMBACleanup.ps1 -pseudoRootManagementGroup $pseudoRootManagementGroup