variable "resourceGroupName" {
  description = "The name of resource group "
  default="kubernetes"
}
variable "location" { 
  description = "Location "
  default="eastus"
}
variable "vnet-kube"{
  description="vent for kubernetes"
  default="kubernetes-vnet"
}

