###############################################
#               VARIABLES                    #   
##############################################

variable "aws_access_key" {
  
}
variable "aws_secret_key" {
  
}
variable "key_name" {
  default = "DemoKeys"
}

##############################################
#               PROVIDERS                    #   
##############################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "ap-south-1"  #https://cloud-images.ubuntu.com/locator/
}

##############################################
#               RESOURCES                    #   
##############################################

resource "aws_instance" "nginx" {

    ami             = "ami-5b673c34"
    instance_type   = "t2.micro"
    key_name        = "${var.key_name}" #i have prvt key aws have pub key

#connection {

#    user            = "ec2-user"
#    private_key     = "${file(var.private_key_path)}"
#}    
provisioner "remote-exec"  {
    inline = [

        "sudo yum install nginx -y",
        "sudo service nginx start"

    ]
}
}

##############################################
#               OUTPUT                       #   
##############################################


output "aws_instance_public_dns" {
  value = "${aws_instance.nginx.public_dns}"
}
