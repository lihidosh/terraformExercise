variable "resource_group_name" {
  type        = string
  description = "lihi-resource-group"
}
variable "location" {
  type        = string
  default     = "West Europe"
  description = "West Europe"
}

variable "azure_vm" {
  type = list(object({
    virtual_network = object({
      name          = string
      address_space = list(string)
    })
    subnet = object({
      name             = string
      address_prefixes = list(string)
    })
    public_ip = object({
      name              = string
      allocation_method = string
    })
    network_security_group = object({
      name = string
      security_rule = object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
      })
    })
    network_interface = object({
      name = string
      ip_configuration = object({
        name                          = string
        private_ip_address_allocation = string
      })
    })
    vm = object({
      name    = string
      vm_size = string
      storage_image_reference = object({
        publisher = string
        offer     = string
        sku       = string
        version   = string
      })
      storage_os_disk = object({
        name              = string
        caching           = string
        create_option     = string
        managed_disk_type = string
      })
      os_profile = object({
        computer_name  = string
        admin_username = string
        admin_password = string
      })
    })
  }))
}


