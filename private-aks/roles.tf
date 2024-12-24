data "azurerm_resource_group" "infra" {
  name = "Infra"
}
 resource "azurerm_role_assignment" "Network_Contributor_subnet" {
   scope                = data.azurerm_subnet.appgw-subnet.id
   role_definition_name = "Network Contributor"
   principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
   lifecycle {
    ignore_changes = [
      role_definition_name,
      principal_id,
    ]
  }
 }

 resource "azurerm_role_assignment" "rg_reader" {
   scope                = data.azurerm_resource_group.infra.id
   role_definition_name = "Reader"
   principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
   lifecycle {
    ignore_changes = [
      role_definition_name,
      principal_id,
    ]
  }
 }

 resource "azurerm_role_assignment" "app-gw-contributor" {
   scope                = data.azurerm_application_gateway.appgateway.id
   role_definition_name = "Contributor"
   principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
   lifecycle {
    ignore_changes = [
      role_definition_name,
      principal_id,
    ]
  }
 }
