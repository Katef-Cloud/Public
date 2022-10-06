customScriptUri="https://raw.githubusercontent.com/Katef-Cloud/Public/main/AzureDevops-Environment/Linux-VM-Registration.sh"
customScriptSettings='{"fileUris": ["'"$customScriptUri"'"],"commandToExecute": "./Linux-VM-Registration.sh --OrganizationUrl $(System.TeamFoundationCollectionUri) --Project $(System.TeamProject) --Environment $(environmentName) --Token $(token) --VM_OS_Admin $(adminName)"}'

echo $customScriptSettings > customScriptSettings.json
cat customScriptSettings.json

az vm extension set \
  --resource-group $(RGname) \
  --vm-name $(VMname) \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings @customScriptSettings.json