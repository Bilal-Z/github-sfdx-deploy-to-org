#!/bin/sh -l

# https://developer.salesforce.com/blogs/2022/01/set-up-continuous-integration-for-your-salesforce-projects


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

~/sfdx/bin/sfdx force:source:manifest:create --sourcepath force-app --manifestname manifest/cicd-package