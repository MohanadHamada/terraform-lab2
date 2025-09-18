resource "aws_instance" "ec2" {
  for_each = var.instance

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = each.key == "public_instance" ? aws_subnet.subnet["public"].id : aws_subnet.subnet["private"].id
  key_name      = aws_key_pair.generated.key_name
  vpc_security_group_ids = [aws_security_group.sec_group.id]
  user_data     = each.value
  tags = { Name = each.key }
}