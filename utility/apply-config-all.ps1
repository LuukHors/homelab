$repoPath = "/home/luukh/code/homelab"
$dryrun = $false

if(-not (Get-Module powershell-yaml -ListAvailable)) {
    Install-Module powershell-yaml -Scope CurrentUser -Force
}

$nodeIps = Get-Content ../talos/generic/node-ips.yaml | ConvertFrom-Yaml

if(-not $dryrun) {    
    Get-ChildItem ../talos/machines/control-planes | Foreach-Object {
        talosctl apply-config -n $nodeIps["control-planes"][$_.BaseName] -f "../talos/output/$($_.Name)" --insecure --talosconfig ./talosconfig
    }

    Get-ChildItem ../talos/machines/workers | Foreach-Object {
        talosctl apply-config -n $nodeIps["workers"][$_.BaseName] -f "../talos/output/$($_.Name)" --insecure --talosconfig ./talosconfig
    }
}