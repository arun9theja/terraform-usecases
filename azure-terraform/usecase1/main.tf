resource "azurerm_resource_group" "cnl_test" {
  name     = "cnl_test"
  location = "West Europe"
}

resource "azurerm_virtual_network" "cnl_vnet" {
  name                = "cnl_vnet"
  location            = azurerm_resource_group.cnl_test.location
  resource_group_name = azurerm_resource_group.cnl_test.name
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "cnl_subnet" {
  name                 = "cnl_subnet"
  resource_group_name  = azurerm_resource_group.cnl_test.name
  virtual_network_name = azurerm_virtual_network.cnl_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "cnl_nsg" {
  name                = "cnl_nsg"
  location            = azurerm_resource_group.cnl_test.location
  resource_group_name = azurerm_resource_group.cnl_test.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "testing"
  }
}

resource "azurerm_subnet_network_security_group_association" "cnl_nsg_assoc" {
  subnet_id                 = azurerm_subnet.cnl_subnet.id
  network_security_group_id = azurerm_network_security_group.cnl_nsg.id
}

resource "azurerm_public_ip" "cnl_public_ip" {
  name                = "cnl_public_ip"
  resource_group_name = azurerm_resource_group.cnl_test.name
  location            = azurerm_resource_group.cnl_test.location
  allocation_method   = "Static"

  tags = {
    environment = "testing"
  }
}

resource "azurerm_network_interface" "cnl_nic" {
  name                = "cnl_nic"
  location            = azurerm_resource_group.cnl_test.location
  resource_group_name = azurerm_resource_group.cnl_test.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cnl_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cnl_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "cnl-vm" {
  name                = "cnl-vm"
  resource_group_name = azurerm_resource_group.cnl_test.name
  location            = azurerm_resource_group.cnl_test.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.cnl_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")  # Make sure you have a public key generated and kept in this path
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

