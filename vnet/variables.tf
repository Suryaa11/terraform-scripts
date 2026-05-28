variable "resource_group" {
  default = {
    name = "surya-rg"
    location = "Central India"
  }
}

variable "vnet" {
  default = {
    name = "surya-vnet"
    address_space = ["10.0.0.0/16"]
  }
}

variable "subnet" {
  default = {
    name = "surya-subnet"
    address_prefixes = ["10.0.1.0/24"]
  }
}

variable "publicip" {
  default = {
    name = "publicip"
    allocation_method = "Static"
    sku = "Standard"
  }
}

variable "nic" {
  default = {
    name = "nic"
    ip_configuration = "internal"
    private_ip_address_allocation = "Dynamic"
  }
}

variable "vm" {
  default = {
    name = "surya-vm"
    size = "Standard_D2s_v5"
    admin_username = "surya"
    admin_password = "Password@12345"
    disable_password_authentication = false
    os_disk = {
      caching = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }
    source_image_reference = {
    publisher = "Canonical"
    offer = "ubuntu-24_04-lts"
    sku = "server"
    version = "latest"
    }
  }
}

variable "nsg" {
  default = {
    name = "vm-nsg"
  }
}