# Define required providers and version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.13.4"
}

# Configure the AWS provider for LocalStack
provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_force_path_style         = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    # Adjust endpoints for services used in LocalStack
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

# Define the EC2 instance resource
resource "aws_instance" "myserver" {
  ami           = "test" # This value is not used by LocalStack, can be any string
  instance_type = "t2.micro"
  count         = 20

  tags = {
    Name = "Server${count.index + 1}"
  }
}

# Define Variables
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "http_ingress_from_port" {
  default = 80
}

variable "http_ingress_to_port" {
  default = 80
}

variable "ssh_ingress_from_port" {
  default = 22
}

variable "ssh_ingress_to_port" {
  default = 22
}

variable "ni_private_ip" {
  default = "10.0.1.50"
}

# Create VPC and Subnet
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
}

# Create Internet Gateway and associate it with VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create Route Table and associate it with Subnet
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "route_to_internet" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create Network Interface with private IP
resource "aws_network_interface" "my_ni" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = [var.ni_private_ip]
}

# Create Elastic IP (LocalStack simulates this)
resource "aws_eip" "my_eip" {}

resource "aws_dynamodb_table" "Tousif" {
  name           = "Tousif"
  billing_mode   = "PROVISIONED" # or "PAY_PER_REQUEST" for on-demand
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S" # String attribute type
  }
}
