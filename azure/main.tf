provider "azurerm" {
   features {}
}
resource "azurerm_resource_group" "example" {
  name     = "ea2-resources-group"
  location = "Southeast Asia"
}

resource "azurerm_network_security_group" "example" {
  name                = "ea2-security-group1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

   security_rule {
    name                       = "AllowAnyHTTPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }



  tags = {
    ea2 = "Demo"
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "ea2-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "private1"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.example.id
  }

  subnet {
    name           = "private2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.example.id
  }
}


resource "azurerm_application_insights" "example" {
  name                = "ea2-test-appinsights"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

output "instrumentation_key" {
  value = azurerm_application_insights.example.instrumentation_key
  sensitive = true
}

output "app_id" {
  value = azurerm_application_insights.example.app_id
}


resource "azurerm_kubernetes_cluster" "default" {
  name                = "ea2-aks"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "ea2-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
    enable_auto_scaling = true
    min_count = 2
    max_count = 4
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  auto_scaler_profile { 
    max_node_provisioning_time       = "15m"
    max_unready_nodes                = 3
    max_unready_percentage           = 45
  }


  

  tags = {
    environment = "Demo"
  }
}