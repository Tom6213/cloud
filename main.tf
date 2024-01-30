resource "azurerm_resource_group" "rg_demo" {
  name     = "vallartiut"
  location = "West Europe"
}

resource "azurerm_storage_account" "my_front_app" {
  name                     = "storagevallartiut"
  resource_group_name      = azurerm_resource_group.rg_demo.name
  location                 = azurerm_resource_group.rg_demo.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }
  tags = {
    environment = "student_demo"
  }
}

resource "azurerm_service_plan" "my_back_server" {
  name                = "servicevallartiut"
  resource_group_name = azurerm_resource_group.rg_demo.name
  location            = azurerm_resource_group.rg_demo.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "my_back_api" {
  name                = "webvallartiut"
  resource_group_name = azurerm_resource_group.rg_demo.name
  location            = azurerm_resource_group.rg_demo.location
  service_plan_id     = azurerm_service_plan.my_back_server.id
  https_only          = true
  app_settings = {
    "My_First_App_Setting" = "My_first_Value"
  }

  site_config {
    always_on               = true
    minimum_tls_version     = "1.2"
    scm_minimum_tls_version = "1.2"
    application_stack {
      dotnet_version = "6.0"
    }
  }
  tags = {
    environment = "student_demo"
  }
}

resource "azurerm_mssql_server" "my_database_server" {
  name                         = "bddvallariut"
  resource_group_name          = azurerm_resource_group.rg_demo.name
  location                     = azurerm_resource_group.rg_demo.location
  version                      = "12.0"
  minimum_tls_version          = "1.2"
  administrator_login          = "mySuperUserTF"
  administrator_login_password = "My_Pa$$w0rd"

  azuread_administrator {
    login_username = "tom.vallart13_gmail.com#EXT#@tomvallart13gmail.onmicrosoft.com"
    object_id      = "d0c40fdc-f336-45b9-a2fc-a4bc39698063"
  }
  tags = {
    environment = "student_demo"
  }
}

resource "azurerm_mssql_database" "my_database" {
  name           = "my-first-db-01"
  server_id      = azurerm_mssql_server.my_database_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
  # enclave_type   = "VBS"

  tags = {
    environment = "student_demo"
  }

  # prevent the possibility of accidental data loss
  # lifecycle {
  #   prevent_destroy = true
  # }
}

data "azurerm_client_config" "example" {
}
# Droit pour déposer des fichiers sur Azure storage account. Un peu trop elever pour de la prod.
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_resource_group.rg_demo.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.example.object_id # ATTENTION ICI C'EST L'OBJECTID de l'enterprise application !!!!
  principal_type       = "ServicePrincipal"
}