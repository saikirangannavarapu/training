# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "ap-south-1"
  access_key = ""
  secret_key = ""
}
# create a vpc
resource "aws_vpc" "pavan" {
  cidr_block       = "10.20.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags = {
    Name = "day-2"
    terraform ="true"
    created ="1"
  }
}

#creeate a public subnet 1

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = "${aws_vpc.pavan.id}"
  availability_zone ="ap-south-1a"
  map_public_ip_on_launch = true
  cidr_block = "10.20.1.0/24"


  tags = {
    Name = "public-subnet-1"
  }
}

#creeate a public subnet 2

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = "${aws_vpc.pavan.id}"
  availability_zone ="ap-south-1b"
  map_public_ip_on_launch = true
  cidr_block = "10.20.2.0/24"


  tags = {
    Name = "public-subnet-2"
  }
}

#create a internet gateway

resource "aws_internet_gateway" "main-igw" {
  vpc_id = "${aws_vpc.pavan.id}"

  tags = {
    Name = "main internet gateway"
  }
}

#creating a route table

resource "aws_route_table" "main-route-table" {
  vpc_id = "${aws_vpc.pavan.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-igw.id}"
  }

 
  tags = {
    Name = "main route table"
  }
}

# making route-table-association for subnets and routes

resource "aws_route_table_association" "for-subnet-1-a" {
  subnet_id      = "${aws_subnet.public-subnet-1.id}"
  route_table_id = "${aws_route_table.main-route-table.id}"
}
resource "aws_route_table_association" "for-subnet-2" {
  subnet_id      = "${aws_subnet.public-subnet-2.id}"
  route_table_id ="${aws_route_table.main-route-table.id}"
}
resource "aws_route_table_association" "for-subnets" {
  gateway_id     = "${aws_internet_gateway.main-igw.id}"
  route_table_id = "${aws_route_table.main-route-table.id}"
}


#creating a key-pair
 resource "aws_key_pair" "demovm"{
   key_name ="demovm"
   public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChdQ1hhWG+ifzzFF5FU+nMrkubjnALd2383/jWwBFNR1lEo0GIaQ+MRmnyCqWTOz/PdMVEEw+VnxXky5xxRjH9j6KW1OXfmfEp+pnbalNtocpaB8iwcbBA9DVgRChzNwlUcgNKzzcy98ldpSZ8KWfHH3x1eSwE/iW7KWK4CUQ27u85aLmx5yKI+cYTDMFCzdHtGPAOeMnkqcqeRKlAyZilj0iX9ZlwTi6crltHbkextHAtMqcCWnnnH6xyrH1QimDzOImQ7hMbtiVVRQ9jfctdtWflbInziPOAPioIacAXd1jNF0ymqFzkqyT37Zcj0KsIHFXdOYpRiAlG0n1gylLv medipudi durgaprasad@DESKTOP-4R16I7U"
  }

#instance configuration

resource "aws_instance" "vpc_by_terraform" {
  ami           = "ami-0123b531fc646552f"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  subnet_id ="${aws_subnet.public-subnet-1.id}"
   tags = {
    Name = "terraform_instance"
  }
  key_name ="demovm"

}
