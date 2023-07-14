# Hardcoded variables for the shares/departments, permissions, and roles needed in the environment
$shares = "CONSULTING","GACACCT","IT","LEADS","LEGAL","MARKETING","RECRUITING","SALES","SURVEY","TM","WDSK"
$perms = "MOD", "READ", "WRITE"
$roles = "MANAGER","STAFF","READONLY"
$adroles0var = @()
$adroles1var = @()
$adroles2var = @()

# Generate $acls and $adroles 
$adAcls = foreach ($share in $shares) {
    foreach ($perm in $perms) {
        -join("ACL_FILESHARE_","$share","_","$perm") 
    }
}
$adRoles = foreach ($share in $shares) {
    foreach ($role in $roles) {
        -join("ROLE_","$share","_","$role")
    }
}

switch -wildcard ($adRoles) {
    "*$($roles[0])" { $adroles0var += $_ }
    "*$($roles[1])" { $adroles1var += $_ }
    "*$($roles[2])" { $adroles2var += $_ }
    Default {Write-Host "$_ is not valid!"}
}

switch -wildcard ($adacls) {
    {$_ -Like "*Manager*"} {Write-Host "Adding $adacl"}
}

function Set-ACLGroups {
    $adAclGroupPath = (Get-ADGroup $testAclGroup | Select-Object -ExpandProperty DistinguishedName).split(",",2)[1]
    foreach ($acl in $adAcls) {New-ADGroup -Name $acl -GroupScope DomainLocal -Path $adAclGroupPath}
}

function Set-RoleGroups {
    $adRoleGroupPath = (Get-ADGroup $testRoleGroup | Select-Object -ExpandProperty DistinguishedName).split(",",2)[1]

    foreach ($adRole in $adRoles) {New-ADGroup -Name $adRole -GroupScope Global -Path $adRoleGroupPath}   
}

function Set-ACLRoles {
    foreach ($adacl in $adacls) {
        if ($adacl -Like "*MOD*"){
            foreach ($adrole in $adroles) {
                if($adacl.split("_")[2] -Like $adrole.split("_")[1]){
                    Write-Host "$adacl gets $adrole"
                }
            }
        }
    }
}