provider "vsphere" {
	user = "${var.vsphere_user}"
	password = "${var.vsphere_password}"
	vsphere_server = "${var.vsphere_server}"
#if you have a self signed cert	
	allow_unverified_ssl = true
}

#eg: Create folder

resource "vsphere_folder" "TerraFormFrontEnd" {

	datacenter = "mllabd" #Datacenter_name
	path = "TerraFormFrontEnd"
  
}

#Create a virtual machine within the folder "TerraFormFrontEnd"

resource "vsphere_virtual_machine" "mydemo_1" {

	name = "mydemo_1_web"
	folder = "${vsphere_folder.TerraFormFrontEnd.path}"
	vcpu = 2
	memory = 4096
	datacenter = "mllabd"
	cluster = "Resources"
	network_interface {

		lable = "vRA-VLAN132"
	}

	disk {
		datastore = "AHC-Resources"
		template = "Templates/W2K12-puppet"
	}
}
