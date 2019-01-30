#!/bin/bash

DEPLOY_TEST=test
DEPLOY_PRODUCTION=production
RP_TRUE=true
RP_FALSE=false
DEPLOY_TYPE=$1
REQUIRE_PASSWORD=$2

display_usage() { 
    echo -e "\nUsage:

    ansible_deploy.sh <DEPLOY_TYPE ($DEPLOY_TEST | $DEPLOY_PRODUCTION)> <REQUIRE_PASSWORD ($RP_TRUE | $RP_FALSE)>
    "
} 

# if less than two arguments supplied, display usage 
if [  $# -le 1 ]
then 
    display_usage
    exit 1
fi 

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $@ == "--help" ) ||  ( $@ == "-h" ) ]] 
then 
    display_usage
    exit 0
fi 

# check whether user has a valid DEPLOY_TYPE
if [[ ( $DEPLOY_TYPE != "$DEPLOY_TEST" ) &&  ( $DEPLOY_TYPE != "$DEPLOY_PRODUCTION" ) ]]
then 
    display_usage
    echo !! DEPLOY_TYPE \"$DEPLOY_TYPE\" is not valid
    exit 2
fi 

# check whether user has a valid REQUIRE_PASSWORD
if [[ ( $REQUIRE_PASSWORD != "$RP_TRUE" ) &&  ( $REQUIRE_PASSWORD != "$RP_FALSE" ) ]]
then 
    display_usage
    echo !! REQUIRE_PASSWORD \"$REQUIRE_PASSWORD\" is not valid
    exit 2
fi 

ADMIN_EMAIL=admin@zap.me
CONTACT_EMAIL=contact@zap.me
VAGRANT=false
# set deploy variables for production
DEPLOY_HOST=zap.me
DEPLOY_USER=root
TESTNET=true
# set deploy variables for test
if [[ ( $DEPLOY_TYPE == "$DEPLOY_TEST" ) ]]
then 
    DEPLOY_HOST=test.zap.me
    DEPLOY_USER=root
    TESTNET=false
fi 

# print variables
echo ":: DEPLOYMENT DETAILS ::"
echo "   - ADMIN_EMAIL:      $ADMIN_EMAIL"
echo "   - CONTACT_EMAIL:    $CONTACT_EMAIL"
echo "   - DEPLOY_HOST:      $DEPLOY_HOST"
echo "   - DEPLOY_USER:      $DEPLOY_USER"
echo "   - REQUIRE_PASSWORD: $REQUIRE_PASSWORD"

# ask user to continue
read -p "Are you sure? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    echo ok lets go!!!
    ansible-playbook --inventory "$DEPLOY_HOST," --user "$DEPLOY_USER" -v \
        --extra-vars "ADMIN_EMAIL=$ADMIN_EMAIL CONTACT_EMAIL=$CONTACT_EMAIL DEPLOY_HOST=$DEPLOY_HOST VAGRANT=$VAGRANT TESTNET=$TESTNET REQUIRE_PASSWORD=$REQUIRE_PASSWORD" \
        ansible/deploy.yml
fi
