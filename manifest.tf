# Configure the AWS provider
provider "aws" {
  region = "us-west-2" # Change this to your desired region
}

# Create an instance
resource "aws_instance" "grafana" {
  ami           = "ami-0c55b159cbfafe1f0" # Change this to your desired AMI
  instance_type = "t2.micro" # Change this to your desired instance type
  key_name      = "my-key" # Change this to your key pair name
  vpc_security_group_ids = ["sg-0123456789abcdef"] # Change this to your security group ID
  tags = {
    Name = "Grafana Instance"
  }
}

# Install Grafana from Docker Hub
resource "null_resource" "grafana_installation" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https",
      "sudo apt-get install -y software-properties-common",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo docker pull grafana/loki",
      "sudo docker run -d --name grafana -p 3000:3000 grafana/loki"
    ]
    connection {
      type        = "ssh"
      host        = aws_instance.grafana.public_ip
      user        = "ubuntu"
      private_key = file("path/to/private/key") # Change this to your private key file path
    }
  }
}
