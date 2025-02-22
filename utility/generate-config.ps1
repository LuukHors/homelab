$repoPath = "/home/luukh/code/homelab"
$kubernetesVersion = "1.31.3"

if(-not (Get-Module powershell-yaml -ListAvailable)) {
    Install-Module powershell-yaml -Scope CurrentUser -Force
}

$nodeIps = Get-Content ../talos/generic/node-ips.yaml | ConvertFrom-Yaml

Get-ChildItem ../talos/machines/workers | Foreach-Object {
    talosctl gen config lhhl https://$($nodeIps.workers[$_.BaseName]):6443 `
        --output=$repoPath/talos/output/$($_.Name) `
        --output-types=worker `
        --with-docs=false `
        --with-examples=false `
        --with-secrets=$repoPath/talos/secrets.yaml `
        --config-patch=@$repoPath/talos/generic/cluster.yaml `
        --config-patch=@$repoPath/talos/generic/machine.yaml `
        --config-patch-worker=@$($_.FullName) `
        --kubernetes-version=$kubernetesVersion `
        --force
}

Get-ChildItem ../talos/machines/control-planes | Foreach-Object {
    talosctl gen config lhhl https://$($nodeIps["control-planes"][$_.BaseName]):6443 `
        --output=$repoPath/talos/output/$($_.Name) `
        --output-types=controlplane `
        --with-docs=false `
        --with-examples=false `
        --with-secrets=$repoPath/talos/secrets.yaml `
        --config-patch=@$repoPath/talos/generic/cluster.yaml `
        --config-patch=@$repoPath/talos/generic/machine.yaml `
        --config-patch-control-plane=@$($_.FullName) `
        --kubernetes-version=$kubernetesVersion `
        --force
}
