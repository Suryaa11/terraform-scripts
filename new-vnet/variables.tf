variable "rg" {
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

variable "public_subnet" {
  default = {
    name = "public-subnet"
    address_prefixes = ["10.0.1.0/24"]
  }
}

variable "public_ip" {
  default = {
    name = "public_ip-1"
    allocation_method = "Static"
    sku = "Standard"
  }
}

variable "public_nic" {
  default = {
    name = "public_nic"
    ip_configuration = {
        name = "ip-config"
        private_ip_address_allocation = "Dynamic" 
    }
  }
}

variable "public_vm" {
  default = {
    name = "public-vm"
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

variable "public_nsg" {
  default = {
    name = "public-nsg"
    security_rule = {
        name = "SSH"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    security_rule_1 = {
        name = "HTTP"
        priority = 110
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    security_rule_2 = {
        name = "HTTPS"
        priority = 120
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "443"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
  }
}

variable "private_subnet" {
  default = {
    name = "private-subnet"
    address_prefixes = ["10.0.2.0/24"]
  }
}

variable "private_nic" {
  default = {
    name = "private-nic"
    ip_configuration = {
        name = "private-ip-config"
        private_ip_address_allocation = "Dynamic"

    }
  }
}

variable "nat_public_ip" {
  default = {
    name = "nat-public-ip"
    allocation_method = "Static"
    sku = "Standard"
  }
}

variable "nat_gateway" {
  default = {
    name = "nat-gateway"
    sku_name = "Standard"
  }
}

variable "private_vm" {
  default = {
    name = "private-vm"
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

variable "private_nsg" {
  default = {
    name = "private-nsg"
    security_rule = {
        name = "Application"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "5656"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

  }
}

variable "lb_ip" {
  default = {
    name = "lb-ip"
    allocation_method = "Static"
    sku = "Standard"
  }
}

variable "lb" {
  default = {
    name = "lb"
    sku = "Standard"
    frontend_ip_configuration = {
      name = "public-ip-lb"  
    }
  }
}

variable "backend_pool" {
  default = {
    name = "backend_pool"
  }
}

variable "backend_address" {
  default = {
    name = "backend_address"
  }
}

variable "lb_rule" {
  default = {
    name = "lb-rule"
    protocol = "Tcp"
    frontend_port = "80"
    backend_port = "5656"
  }
}

variable "lb_probe" {
  default = {
    name = "lb-probe"
    port = "5656"
  }
}