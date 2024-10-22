provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

# Private Subnets
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-subnet-2"
  }
}

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.26"
  vpc_id          = aws_vpc.main.id
  subnet_ids      = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.private1.id, aws_subnet.private2.id]
}

# EKS Node Group
resource "aws_eks_node_group" "example" {
  cluster_name    = module.eks.cluster_name  # Corrected output for cluster_name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [aws_subnet.public1.id, aws_subnet.public2.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.medium"]

  tags = {
    Name = "eks-node-group"
  }
}


# S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-unique-terraform-state-bucket-2024"

  tags = {
    Name = "terraform-state-bucket"
  }
}

# S3 bucket versioning (moved out to a separate resource)
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-locks"
  }
}

# IAM Role for EKS Node Group (Required for worker nodes)
resource "aws_iam_role" "node_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "node_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}
