output "public_ip" {
  value = aws_instance.ec2["public_instance"].public_ip
}

output "private_ip" {
  value = aws_instance.ec2["private_instance"].private_ip
}

output "key_path" {
  value = local_file.private_key.filename
}
