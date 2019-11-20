# Core

**This repository is under construction.** It contains an unlocked package version of core functionalities for the Service package.

## Create and use a new package version

To create and install a new version of the package, execute the following command lines:

```
sfdx force:package:version:create --package 0Ho3X000000KyjVSAS --installationkey Core2019 --wait 10 --targetdevhubusername Service
sfdx force:package:install --wait 10 --publishwait 10 --package /*package version id*/ --installationkey Core2019 --noprompt --targetusername Service
sfdx force:package:install --wait 10 --publishwait 10 --package /*package version id*/ --installationkey Core2019 --noprompt --targetusername ServiceSO
```

Then change the Core package version in dependant packages in the following files:
- sfdx-project.json
- .travis.yml
- README.md