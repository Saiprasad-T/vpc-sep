resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = local.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion-${var.project}-${var.environment}"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "${var.project}-${var.environment}-bastion-sg"
  description = "Allow SSH access from my IP"
  vpc_id      = local.vpc_id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
}


resource "aws_instance" "private_ec2" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = local.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.private_ec2_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
  EOF

  tags = {
    Name        = "${var.project}-${var.environment}-private-ec2"
    Environment = var.environment
  }
}

resource "aws_security_group" "private_ec2_sg" {
  name        = "${var.project}-${var.environment}-private-ec2-sg"
  description = "Allow SSH from Bastion only"
  vpc_id      = local.vpc_id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
}


resource "aws_vpc_security_group_egress_rule" "bastion_ssh_to_private" {
  security_group_id            = aws_security_group.bastion_sg.id
  referenced_security_group_id = aws_security_group.private_ec2_sg.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  description = "SSH to private EC2"
}

resource "aws_vpc_security_group_egress_rule" "private_https" {
  security_group_id = aws_security_group.private_ec2_sg.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ipv4   = "0.0.0.0/0"

  description = "HTTPS for package downloads"
}

resource "aws_vpc_security_group_egress_rule" "private_http" {
  security_group_id = aws_security_group.private_ec2_sg.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"

  description = "HTTP for package downloads"
}
