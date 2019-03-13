variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "ap-south-1"
}
variable "AMIS" {
  type = "map"
  default = {
    ap-south-1 = "ami-5b673c34"
    ap-south-1 = "ami-025d8258d76079367"
    ap-southeast-2 = "ami-0be98040774f0f51e"
  }
}
