resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = "tera-key"
  public_key = tls_private_key.keypair.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.keypair.private_key_pem
  filename = "${path.module}/tera-key.pem"
}
resource "local_file" "public_key" {
  content  = tls_private_key.keypair.public_key_openssh
  filename = "${path.module}/tera-key.pub"
}