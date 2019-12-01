$rg = az group list --query "[?ends_with( name, 'mcdemo')].{name:name}" -o tsv
az group delete -g $rg -y --no-wait