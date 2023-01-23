#!/bin/sh -l

# https://linuxhint.com/set-command-bash/
set -e
set -u

LOGIN_URL="${1}"
CERT_PATH="${2}"
DECRYPT_KEY="${3}"
DECRYPT_IV="${4}"
CONSUMER_KEY="${5}"
USERNAME="${6}"
TEST_LEVEL="${7}"
TESTS_TO_RUN="${8}"
DEPLOY_WAIT="${9}"
SRC_PATH="${10}"

# https://developer.salesforce.com/blogs/2022/01/set-up-continuous-integration-for-your-salesforce-projects

echo ":: Install sfdx cli"
# Download the Salesforce CLI installer
wget https://developer.salesforce.com/media/salesforce-cli/sfdx/channels/stable/sfdx-linux-x64.tar.xz

# Create the install directory
mkdir ~/sfdx

# Extract the installer archive without the top-level directory
tar xJf sfdx-linux-x64.tar.xz -C ~/sfdx --strip-components 1

# Add the sfdx command to the path (this is a GitHub-specific example)
echo "$HOME/sfdx/bin" >> $GITHUB_PATH

# Run 'sfdx version' to test the installation
# and keep a trace of the version in the logs for debugging purposes
~/sfdx/bin/sfdx version

echo ":: Decrypt Certificate"

openssl enc -nosalt -aes-256-cbc -d -in "$CERT_PATH" -out server.key -base64 -K "$DECRYPT_KEY" -iv "$DECRYPT_IV"

echo ":: Authenticating into org"
~/sfdx/bin/sfdx force:auth:jwt:grant --instanceurl "$LOGIN_URL" --clientid "$CONSUMER_KEY" --jwtkeyfile server.key --username "$USERNAME" --setalias sfdc

echo ":: Deploy to org"
~/sfdx/bin/sfdx force:source:deploy --wait "$DEPLOY_WAIT" --sourcepath "$SRC_PATH" --testlevel "$TEST_LEVEL" --targetusername sfdc