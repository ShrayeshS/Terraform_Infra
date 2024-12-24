# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false  
}

#data "azurerm_key_vault_secret" "my_secret" {  
  #name         = "ServiceprincipalId"
  #key_vault_id = "/subscriptions/31e272d2-b2af-4c96-afd0-0d74f6b780b4/resourceGroups/DSOKITTest/providers/Microsoft.KeyVault/vaults/DXOKeyVault"
#}

/*data "azurerm_key_vault_secret" "my_secret" {
  name         = "ServiceprincipalId"
  key_vault_id = "/subscriptions/subscription-id/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myKeyVault"
}*/

 

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "${var.resource_group_name}-cluster"           
  kubernetes_version    =  data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"
  
  default_node_pool {
    name       = "linuxpool"
    vm_size    = "Standard_DS2_v2"
    zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
     } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
   } 
  }

  service_principal  {
    client_id = var.client_id
    #client_id = data.azurerm_key_vault_secret.my_secret.value
    client_secret = var.client_secret
  }



  /* linux_profile {
    admin_username = "ubuntu"
    ssh_key {
        key_data = file(var.ssh_public_key)
    }
  } */

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }

    
}

