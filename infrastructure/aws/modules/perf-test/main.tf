# Test module for performance optimization detection

variable "instance_names" {
  type    = list(string)
  default = ["web-1", "web-2", "web-3"]
}

variable "environment" {
  type    = string
  default = "dev"
}

# Using count with length() - should suggest for_each
resource "aws_instance" "servers" {
  count         = length(var.instance_names)
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_names[count.index]
  }
}

# Explicit depends_on - should flag as potentially limiting parallelism
resource "aws_security_group" "app" {
  name        = "${var.environment}-app-sg"
  description = "Security group for app servers"

  depends_on = [aws_instance.servers]

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# External data source - runs on every plan
data "external" "config" {
  program = ["python3", "${path.module}/get_config.py"]
}

# HTTP data source - network call on every plan
data "http" "api_config" {
  url = "https://api.example.com/config"
}

# Multiple data sources of same type
data "aws_ami" "ubuntu_1" {
  most_recent = true
  owners      = ["099720109477"]
}

data "aws_ami" "ubuntu_2" {
  most_recent = true
  owners      = ["099720109477"]
}

data "aws_ami" "ubuntu_3" {
  most_recent = true
  owners      = ["099720109477"]
}

data "aws_ami" "ubuntu_4" {
  most_recent = true
  owners      = ["099720109477"]
}

output "instance_ids" {
  value = aws_instance.servers[*].id
}
