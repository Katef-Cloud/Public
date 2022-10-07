customScriptUri="https://raw.githubusercontent.com/Katef-Cloud/Public/main/AzureDevops-Self-Hosted-Agent/Linux-VM-Install_Self_hosted_Agent.sh"
customScriptSettings='{"fileUris": ["'"$customScriptUri"'"],"commandToExecute": "./Linux-VM-Install_Self_hosted_Agent.sh --OrganizationUrl $(System.TeamFoundationCollectionUri) --pool $(poolname) --Token $(token) --VM_OS_Admin $(adminName)"}'

echo $customScriptSettings > customScriptSettings.json
cat customScriptSettings.json

az vm extension set \
  --resource-group $(RGname) \
  --vm-name $(VMname) \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings @customScriptSettings.json