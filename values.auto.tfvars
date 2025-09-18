cidr_block = "10.0.0.0/16"
subnets = { 
    public = "10.0.0.0/24"
    private = "10.0.1.0/24"
}
instance = {
  public_instance = ""
  private_instance =<<-EOF
      #!/bin/bash
      apt update -y
      apt install -y nginx
      systemctl start nginx
      systemctl enable nginx
      echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html
      EOF
}