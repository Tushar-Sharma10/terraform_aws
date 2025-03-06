resource "aws_eks_cluster" "eks_cluster" {
  name     = "EKS-Cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.public_subnet1.id,
      aws_subnet.public_subnet2.id,
      aws_subnet.private_subnet1.id,
    aws_subnet.private_subnet2.id]
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Name = "eks-cluster"
  }
}
resource "aws_security_group" "eks_sg" {
  name        = "eks-sg"
  description = "EKS Security Group"
  vpc_id      = aws_vpc.main.id

}
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4         = var.internet_traffic
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4         = var.internet_traffic
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4         = var.internet_traffic
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

data "aws_ami" "latest_eks_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amazon-eks-node-*-x86_64-*"]
  }
}
resource "aws_launch_template" "eks_worker_launch_template" {
  name                 = "eks-worker-launch-template"
  image_id             = data.aws_ami.latest_eks_ami.id
  instance_type        = "t2.micro"
  security_group_names = [ aws_security_group.eks_sg.id ]
   iam_instance_profile {
    name = aws_iam_instance_profile.eks_worker_profile.name
  }
  user_data            = file("userdata.sh")
}

resource "aws_iam_instance_profile" "eks_worker_profile" {
  name = "eks-worker-profile"
  role = aws_iam_role.eks_worker_role.name
}

resource "aws_autoscaling_group" "eks_worker_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
    launch_template {
    id      = aws_launch_template.eks_worker_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "eks-worker-node"
    propagate_at_launch = true
  }
}
