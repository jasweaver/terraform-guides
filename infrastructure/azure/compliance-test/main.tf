# Test file for compliance checking
# This file intentionally has HIPAA compliance violations

# Non-compliant: Missing HTTPS-only, public access enabled, no required tags
resource "azurerm_storage_account" "noncompliant" {
  name                     = "noncompliantstorage"
  resource_group_name      = "test-rg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # VIOLATION: HTTPS not enforced
  enable_https_traffic_only = false

  # VIOLATION: Public access enabled
  public_network_access_enabled = true

  # VIOLATION: TLS version too low
  min_tls_version = "TLS1_0"

  # VIOLATION: Missing required tags (Environment, Owner, PHI_Data)
  tags = {
    Name = "test-storage"
  }
}

# Non-compliant: SQL server with public access
resource "azurerm_mssql_server" "noncompliant" {
  name                         = "noncompliant-sql"
  resource_group_name          = "test-rg"
  location                     = "eastus"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd123!"

  # VIOLATION: TLS version too low
  minimum_tls_version = "1.0"

  # VIOLATION: Public access enabled
  public_network_access_enabled = true

  # VIOLATION: Missing required tags
  tags = {
    Name = "test-sql"
  }
}

# Non-compliant: Database without proper tags
resource "azurerm_mssql_database" "noncompliant" {
  name      = "noncompliant-db"
  server_id = azurerm_mssql_server.noncompliant.id
  sku_name  = "S0"

  # VIOLATION: Missing required tags
  tags = {
    Name = "test-database"
  }
}

# Missing: No diagnostic settings (audit logging required for HIPAA)
# Missing: No Key Vault for encryption key management
