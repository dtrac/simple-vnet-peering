data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "net-dev" {
  name     = "net-dev-uks-rg-01"
  location = "uksouth"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "dtracstorageuks001"
  resource_group_name      = azurerm_resource_group.net-dev.name
  location                 = azurerm_resource_group.net-dev.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "development"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

resource "azurerm_key_vault" "ado" {
  name                        = "dtrackeyvaultuks001"
  location                    = azurerm_resource_group.net-dev.location
  resource_group_name         = azurerm_resource_group.net-dev.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

}