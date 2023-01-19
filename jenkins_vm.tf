// Generates a private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Create the key pair
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins_vm_key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

// Save file private key
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.jenkins_key.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

// Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create EC2 Instance
resource "aws_instance" "jenkins_vm" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.public.id
  availability_zone           = "ap-south-1a"
  vpc_security_group_ids      = [aws_security_group.jenkins_vm_sg.id]
  source_dest_check           = false
  key_name                    = aws_key_pair.jenkins_key.key_name
  associate_public_ip_address = true

  user_data = file("jenkins_config.sh")

  # root disk
  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }

  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = 100
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "jenkins_vm"
  }
}

// Elastic IP for jenkins vm
resource "aws_eip" "jenkins_vm_eip" {
  instance = aws_instance.jenkins_vm.id
  vpc      = true

  tags = {
    Name = "jenkins_vm_eip"
  }
}