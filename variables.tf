variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
}
variable "subnets" {
  description = "The name of the subnet"
  type        = map(string)
}
variable "ami" {
  description = "The AMI ID to use for the instance"
  type        = string
  default = "ami-0fc5d935ebf8bc3bc"
}

variable "instance_type" {
  description = "Instance type for all instances"
  type        = string
  default = "t2.micro"
}
variable "instance" {
    description = "Data for the instances"
    type = map(string)
}