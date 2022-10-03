#!/bin/bash


##### define Usage and die funtion ######################
programname=$0
function usage {
    echo ""
    echo "Deploys an ECR image to Atlas using GitOps and ArgoCD."
    echo ""
    echo "usage: $programname --OrganizationUrl string --Project string --Environment string --Token string "
    echo ""
    echo "  --OrganizationUrl string   URL OF Organization"
    echo "                             (example: https://dev.azure.com/Organization/)"
    echo "  --Project string           Project name"
    echo "                             (example: 'Lab')"
    echo "  --Environment string       Environment name"
    echo "                             (example: 'Terraform')"
    echo "  --Token string             Personal Access Token"
    echo "                             (example: y6msazjdb2hncvuk2lb4j22wj4csoejdx2bvgl7nnoopolertdvo3etpa)"
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
elif [[ -z $Project ]]; then
    usage
    die "Missing parameter --Project"
elif [[ -z $Environment ]]; then
    usage
    die "Missing parameter --Environment"
elif [[ -z $Token ]]; then
    usage
    die "Missing parameter --Token"
fi


############## Install Agent ########################################

mkdir azagent;
cd azagent;
curl -fkSL -o vstsagent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.210.1/vsts-agent-linux-x64-2.210.1.tar.gz;
tar -zxvf vstsagent.tar.gz;

if [ -x "$(command -v systemctl)" ]; 
then 
    ./config.sh --environment \
    --environmentname $Environment \
    --acceptteeeula \
    --agent $HOSTNAME \
    --url $OrganizationUrl \
    --work _work \
    --projectname $Project \
    --auth PAT \
    --token $Token \
    --runasservice; 
    sudo ./svc.sh install;
    sudo ./svc.sh start;
else 
    ./config.sh --environment \
    --environmentname $Environment \
    --acceptteeeula \
    --agent $HOSTNAME \
    --url $OrganizationUrl \
    --work _work \
    --projectname $Project \
    --auth PAT \
    --token $Token;
    ./run.sh; 
fi