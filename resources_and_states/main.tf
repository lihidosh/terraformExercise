resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = { for vpce in var.azure_vm : vpce.virtual_network.name => vpce }
  name                = each.value.virtual_network.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = each.value.virtual_network.address_space
}

resource "azurerm_public_ip" "public_ip" {
  for_each            = { for vpce in var.azure_vm : vpce.public_ip.name => vpce }
  name                = each.value.public_ip.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = each.value.public_ip.allocation_method
}

resource "azurerm_subnet" "subnet" {
  for_each             = { for vpce in var.azure_vm : vpce.subnet.name => vpce }
  name                 = each.value.subnet.name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.virtual_network.name].name
  address_prefixes     = each.value.subnet.address_prefixes
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = { for vpce in var.azure_vm : vpce.network_security_group.name => vpce }
  name                = each.value.network_security_group.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = each.value.network_security_group.security_rule.name
    priority                   = each.value.network_security_group.security_rule.priority
    direction                  = each.value.network_security_group.security_rule.direction
    access                     = each.value.network_security_group.security_rule.access
    protocol                   = each.value.network_security_group.security_rule.protocol
    source_port_range          = each.value.network_security_group.security_rule.source_port_range
    destination_port_range     = each.value.network_security_group.security_rule.destination_port_range
    source_address_prefix      = each.value.network_security_group.security_rule.source_address_prefix
    destination_address_prefix = each.value.network_security_group.security_rule.destination_address_prefix
  }
}
resource "azurerm_network_interface" "ni" {
  for_each            = { for vpce in var.azure_vm : vpce.network_interface.name => vpce }
  name                = each.value.network_interface.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_configuration {
    name                          = each.value.network_interface.ip_configuration.name
    subnet_id                     = azurerm_subnet.subnet[each.value.subnet.name].id
    private_ip_address_allocation = each.value.network_interface.ip_configuration.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip[each.value.public_ip.name].id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  for_each                  = { for vpce in var.azure_vm : vpce.network_interface.name => vpce }
  network_interface_id      = azurerm_network_interface.ni[each.value.network_interface.name].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.network_security_group.name].id
}

resource "azurerm_virtual_machine" "vm" {
  for_each              = { for vpce in var.azure_vm : vpce.vm.name => vpce }
  name                  = each.value.vm.name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.ni[each.value.network_interface.name].id]
  vm_size               = each.value.vm.vm_size
  storage_image_reference {
    publisher = each.value.vm.storage_image_reference.publisher
    offer     = each.value.vm.storage_image_reference.offer
    sku       = each.value.vm.storage_image_reference.sku
    version   = each.value.vm.storage_image_reference.version
  }
  storage_os_disk {
    name              = each.value.vm.storage_os_disk.name
    caching           = each.value.vm.storage_os_disk.caching
    create_option     = each.value.vm.storage_os_disk.create_option
    managed_disk_type = each.value.vm.storage_os_disk.managed_disk_type
  }
  os_profile {
    computer_name  = each.value.vm.os_profile.computer_name
    admin_username = each.value.vm.os_profile.admin_username
    admin_password = each.value.vm.os_profile.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
