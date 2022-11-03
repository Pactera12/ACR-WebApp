  $User = "7da95c78-691c-4868-97d6-1a98c456c075"
    $PWord = ConvertTo-SecureString -String "qtb8Q~DwlRL34ckkZ6.I_mfsla6NHwEtOb1Oqa7Y" -AsPlainText -Force
    $tenant = "798b4769-c7e2-489c-98b8-362ceda12432"
    $Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User,$PWord
    # $Credential = Get-Credential
    Connect-AzAccount -Credential $Credential -Tenant $tenant -ServicePrincipal


#$resourceGroup=New-AzResourceGroup -Name demorg -Location "South Central US"  -Force

$resourceGroup = Set-AzResourceGroup -Name demoRG -Tag @{}
$resourceGroup.resourcegroupname

$containerRegistryName="demoapp18"


$registry = New-AzContainerRegistry `
-ResourceGroupName $resourceGroup.ResourceGroupName `
-Name $containerRegistryName `
-EnableAdminUser `
-Sku Basic


$creds = Get-AzContainerRegistryCredential -Registry $registry
$creds | fl *
$creds.Password | `
docker login $registry.LoginServer `
-u $creds.Username `
--password-stdin



$password = $creds.Password
$Username = $creds.Username
az acr import   --name $containerRegistryName  --source docker.io/pacteraedge12/demoblazorserverapp --image demoblazorserverapp:test  --username pacteraedge12  --password dckr_pat_qTJj9efHZbMHeVr9dDIzU0PsgNw

git clone https://github.com/ashish0998/Demobalzor.git
cd Demobalzor


az appservice plan create --name AppServiceDemoPlan18 --resource-group $resourceGroup.resourcegroupname --sku B1 --is-linux



az webapp create --resource-group  $resourceGroup.resourcegroupname --plan AppServiceDemoPlan18 --name AppServiceDemoMultiContainerApp18  --multicontainer-config-type compose --multicontainer-config-file docker-compose.yml -s demoapp123 -w CdWPwROxNfWQnTcIG=vH3zbVfq0HO6GJ 

#az webapp config container set --name AppServiceDemoMultiContainerApp18 --resource-group $resourceGroup.resourcegroupname --docker-registry-server-url https://demoapp123.azurecr.io -s demoapp123 -p CdWPwROxNfWQnTcIG=vH3zbVfq0HO6GJ

az webapp config container set --docker-registry-server-password CdWPwROxNfWQnTcIG=vH3zbVfq0HO6GJ --docker-registry-server-url https://demoapp123.azurecr.io --docker-registry-server-user demoapp123 --name AppServiceDemoMultiContainerApp18 --resource-group demoRG