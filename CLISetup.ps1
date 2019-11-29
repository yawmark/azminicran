# Don't forget to az login
# Also will need a deployment user set

$RESOURCE_GROUP = "trg-azminicran"

$appname = (az webapp list -g $RESOURCE_GROUP --query '[].{Name:name}' -o tsv)
$GIT_URL = az webapp deployment list-publishing-credentials -n $appname -g $RESOURCE_GROUP --query scmUri -o tsv
$REMOTE_NAME = "azure"
$gitcmd = If (git remote | Select-String $REMOTE_NAME) { "set-url" } Else { "add" }
git remote $gitcmd $REMOTE_NAME $GIT_URL 