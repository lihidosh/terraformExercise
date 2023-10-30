azure_vm = [{
  virtual_network = {
    name          = "v_net_3"
    address_space = ["10.0.0.0/16"]
  }
  subnet = {
    name             = "subnet_3"
    address_prefixes = ["10.0.1.0/24"]
  }
  public_ip = {
    name              = "public_ip_3"
    allocation_method = "Dynamic"
  }
  network_security_group = {
    name = "nsg3"
    security_rule = {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "22"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  network_interface = {
    name = "network_interface_3"
    ip_configuration = {
      name                          = "ip_configuration_1"
      private_ip_address_allocation = "Dynamic"
    }
  }
  vm = {
    name    = "vm_3"
    vm_size = "Standard_DS1_v2"
    storage_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts"
      version   = "latest"
    }
    storage_os_disk = {
      name              = "myosdisk3"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
    os_profile = {
      computer_name  = "hostname"
      admin_username = "admin_vm_3"
      admin_password = "Password1234!"
    }
  }
}]
