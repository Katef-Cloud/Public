#!/bin/bash


##### define Usage and die funtion ######################
programname=$0
function usage {
    echo ""
    echo "Register Linux VM to Azure Devops Environment."
    echo ""
    echo "usage: $programname --OrganizationUrl string --pool string --Token string --VM_OS_Admin string"
    echo ""
    echo "  --OrganizationUrl string   URL OF Organization"
    echo "                             (example: https://dev.azure.com/Organization/)"
    echo "  --pool string              Agent Pool name  (Hint: Need to be created first)"
    echo "                             (example: 'Terraform')"
    echo "  --Token string             Personal Access Token"
    echo "                             (example: y6msazjdb2hncvuk2lb4j22wj4csoejdx2bvgl7nnoopolertdvo3etpa)"
    echo "  --VM_OS_Admin string       Admin Username configured on Virtual Machine (Don't Use root)"
    echo ""
}

function die {
    printf "Script failed: %s\n\n" "$1"
    exit 1
}



##### declare each passed parameter ##################################

while [ $# -gt 0 ]; do
    if [[ $1 == "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done


########## validate passed parameter #################################

if [[ -z $OrganizationUrl ]]; then
    usage
    die "Missing parameter --OrganizationUrl"
elif [[ -z $pool ]]; then
    usage
    die "Missing parameter --pool"
elif [[ -z $Token ]]; then
    usage
    die "Missing parameter --Token"
elif [[ -z $VM_OS_Admin ]]; then
    usage
    die "Missing parameter --VM_OS_Admin"
elif [[ $VM_OS_Admin == "root" ]]; then
    usage
    die "Don't use root. Please use any other Account with an admin privilege"
fi

############## Install Dependencies required for for .NET Core 3.1 ##################################

curl -fkSL -o installdependencies.sh https://raw.githubusercontent.com/Katef-Cloud/Public/main/AzureDevops-Environment/installdependencies.sh
sudo chmod a+x installdependencies.sh
sudo ./installdependencies.sh


############## Install Agent ########################################

####### The script will run using admin user rather than root as per prerequisites to run script successfully

sudo -i -u $VM_OS_Admin bash << EOF

mkdir azagent;
cd azagent;
curl -fkSL -o vstsagent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.210.1/vsts-agent-linux-x64-2.210.1.tar.gz;
tar -zxvf vstsagent.tar.gz;

if [ -x "$(command -v systemctl)" ]; 
then 
    ./config.sh --unattended --replace \
    --acceptteeeula \
    --pool $pool \
    --agent $HOSTNAME \
    --url $OrganizationUrl \
    --work _work \
    --auth PAT \
    --token $Token \
    --runasservice &&
    sudo ./svc.sh install &&
    sudo ./svc.sh start;
else 
    ./config.sh --unattended --replace \
    --acceptteeeula \
    --pool $pool \
    --agent $HOSTNAME \
    --url $OrganizationUrl \
    --work _work \
    --auth PAT \
    --token $Token &&
    ./run.sh; 
fi

EOF