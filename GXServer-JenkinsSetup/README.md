
# Jenkins setup
This directory contains a set of scripts that will help you install and configure a Jenkins instance, and integrate it with an existent GeneXus Server installation.

## Requirements
- No Jenkins local installations 
- Port 8080 available
- Windows Management Framework 5.1
- GeneXus Server instance (v17 or upper).

## Setup steps

### 1. Checkout repo
First of all, you need to get these scripts: go to the root of this repository and use the "Code" button to get them.
1. If you have some Git basics, you can do the clone of the repo with the given URL or
2. you just simply can download a zip.

### 2. Configure required information
Locate the file [``./conf/Jconfig.json``](./conf/Jconfig.json) and complete the required information:

- `Jenkins`
  - `path`: Jenkins installation path (_optional_).
  - `url` and `exists` : this values *must not be modified*.

- `LocalKBPath`: path for Jenkins checkout/build all the KB projects.
  - `path` : path and folder in which the KBs obtained from GXserver will be created. For example: "C:\\LocalKBs".

- `GXAccount` : GeneXus Account used to deploy to cloud.
  - `id` : *must not be modified*.
  - `GXuser` and `GXpass` : valid GeneXus Account credentials that will be used to perform the DeployToCloud from the KB.

- `SQLCredentials`: collection of SQL Server credentials to log in with SQL Authentication.
  - `id` : alias to refer to these credentials in Jenkins. For example, "SQLServerLogin".
  - `user` and `pass` : credentials that Jenkins will use when communicating with SQL Server (if SQL Server Authentication method is used) to create the KB obtained from GXserver.|
  
- `GXServerCredentials`: collection of GeneXus Server credentials.
  - `id` : alias to refer to these credentials in Jenkins. For example, "GXserverLogin".
  - `user` and `pass` : credentials that Jenkins will use to obtain KBs, check for changes, and update (a valid GXserver user). Remember to include the type of access in the username. For example, "local\\admin" or "GeneXus Account\\mary".
  
- `GeneXus`: collection of GeneXus installations.
  - `name` : alias to refer to GeneXus installation in Jenkins. For example, "GeneXus V17".
  - `path` : path and folder where GeneXus is installed. For example, "C:\\Program Files (x86)\\GeneXus\\GeneXus17".
  
An example with the required information is provided at [``./Jconfig-sample.json``](./Jconfig-sample.json).
  
### 3. Install
You are ready to execute the installation script. Powershell is need to execute it.
1. Open "Windows Powershell" command-line.
2. Go to the directory where you have your scripts; For reference, lets say the scripts are located at `c:\GXJenkinsXIntegration`.

 e.g.:
```
PS C:\Users\me> cd c:\GXJenkinsXIntegration\GXServer-JenkinsSetup
```

3. Execute
```
PS C:\GXJenkinsXIntegration\GXServer-JenkinsSetup> .\JenkinsSetup.ps1
```
The first run only installs Jenkins. Then, it automatically starts your Jenkins web and a list of steps to configure manually.

4. Follow the steps (if file doesn't open please locate it in ``.\resources\Readme.txt``)
5. When your Jenkins is ready, execute JenkinsSetup.ps1 again to configure with your Jconfig.json information
```
PS C:\GXJenkinsXIntegration\GXServer-JenkinsSetup> .\JenkinsSetup.ps1
```

6. Last, a file will be opened with the available information to configure your GXserver provider.

If you have any problem first look at the following section [Common Issues](#common-issues) for a list of known errors; if the problem persist please, contact gxserveronline@genexus.com attaching the file `` .\jenkins.log`` 

## Advanced

### Create new user
Optionally, you can create a new user or continue using the default admin user. In both cases you need to create a token manually from <jenkinsUrl>\user\<username>\configure >> Add new Token.
The new user token must be set in ``.\core\services\Jusers.json``.

### Maintenance
The script setup ``.\JenkinsSetup.ps1`` can be run as many times as needed. In each execution, the script will update dependencies, plugins, pipelines and also all the data configured in the Jconfig.json. 
Also, you may execute one thing at a time using Advanced options.
<br>

### Options
Try executing ``.\JenkinsSetup.ps1 /h``. This will show a list of available commands to re-install, re-configure some parameters or uninstall it.
| COMMAND | DESCRIPTION |
| :---: | --- |
| **updateJenkinsCore** | Update the script setup version |
| **updateTokens** | Update credentials from Jconfig in Jenkins installation |
| **updateGeneXus** | Update all GeneXus installations from Jconfig in Jenkins installation|
| **updatePipelines** | Update available GeneXus pipelines |
| **clean** | Use .json default configuration |
| **uninstall** | Uninstall Jenkins and do **clean** |

## Common Issues
***
``1.`` ***.\JenkinsSetup.ps1 : File .\JenkinsSetup.ps1 cannot be loaded. The file***<br>
***.\JenkinsSetup.ps1 is not digitally signed. You cannot run this script on the current system.***<br>

Use Get-ExecutionPolicy in powershell to read ExecutionPolicy type, then change to bypass with the command:<br>  
**Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass**<br>
***
``2.``***ConvertFrom-Json : Unrecognized escape sequence. (64): {***<br>
    ***"LocalKBPath":  {***<br>
                        ***"path":  "C:\knowledgebases"***<br>
Like the Jsonfig-sample.json, the json file needs double slash character, for example:
**"LocalKBPath": { "path":___"C:\\knowledgebases"___ }**
***
``3.``***ERROR Could not use Chocolatey yet***<br>
For chocolatey first install, you must close and re-open the powershell console.
***
