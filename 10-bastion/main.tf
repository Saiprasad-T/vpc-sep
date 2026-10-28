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
---------------------------------------
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