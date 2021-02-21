provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAW5VPYQDQIFUIXE4P"
  secret_key = "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"
}

resource "aws_vpc" "vpc-ajay" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"
}

resource "aws_subnet" "subnet-public" {
    vpc_id = "${aws_vpc.vpc-ajay.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
}

resource "aws_internet_gateway" "first-igw" {
    vpc_id = "${aws_vpc.vpc-ajay.id}"
}

resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.vpc-ajay.id}"
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.first-igw.id}" 
    }
}

resource "aws_route_table_association" "public-crt-public-subnet"{
    subnet_id = "${aws_subnet.subnet-public.id}"
    route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_security_group" "my-sg" {
    vpc_id = "${aws_vpc.vpc-ajay.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web1" {
    ami = "ami-08e0ca9924195beba"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.subnet-public.id}"
    vpc_security_group_ids = ["${aws_security_group.my-sg.id}"]
    key_name = "mykey"
    # nginx installation
 #   provisioner "file" {
  #      source = "nginx.sh"
   #     destination = "/tmp/nginx.sh"
    #}
    #provisioner "remote-exec" {
     #   inline = [
      #       "chmod +x /tmp/nginx.sh",
       #      "sudo /tmp/nginx.sh"
        #]
    #}  
    tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}
