provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-022e1a32d3f742bd8"
    instance_type = "t2.micro"
    key_name = "devopskey"
    //security_groups = [ "demo-sg" ]
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.balli-public-subnet-01.id
}
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow ssh inbound traffic"
  vpc_id = aws_vpc.balli-vpc.id


  ingress {
    description      = "SSh from outside"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSh-allow"
  }
}

resource "aws_vpc" "balli-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
      Name= "balli-vpc"
    }  
}

resource "aws_subnet" "balli-public-subnet-01" {
    vpc_id = aws_vpc.balli-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name= "balli-public-subnet-01"
    }
     
}


resource "aws_subnet" "balli-public-subnet-02" {
    vpc_id = aws_vpc.balli-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
      Name= "balli-public-subnet-02"
    }
     
}

resource "aws_internet_gateway" "balli-igw" {
    vpc_id = aws_vpc.balli-vpc.id
    tags = {
        Name = "balli-igw"

    }
      
    }


resource "aws_route_table" "balli-public-rt" {
    vpc_id= aws_vpc.balli-vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.balli-igw.id

    }
}      

resource "aws_route_table_association" "balli-rta-public-subnet-01" {
    subnet_id = aws_subnet.balli-public-subnet-01.id
    route_table_id = aws_route_table.balli-public-rt.id

  
}


resource "aws_route_table_association" "balli-rta-public-subnet-02" {
    subnet_id = aws_subnet.balli-public-subnet-02.id
    route_table_id = aws_route_table.balli-public-rt.id
    
  
}


