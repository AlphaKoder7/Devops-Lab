data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_role" "ec2" {
  name = "devops-lab-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "devops-lab-ec2-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_security_group" "platform" {
  name        = "devops-lab-platform"
  description = "Security group for the DevOps Lab platform node"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP for Kubernetes ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-lab-platform"
  }
}

resource "aws_instance" "platform" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.platform.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  tags = {
    Name = "devops-lab-platform"
  }
}
