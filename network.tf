resource "aws_internet_gateway" "first-igw" {
    vpc_id = "${aws_vpc.vpc-ajay.id}"
    tags {
        Name = "first-igw"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.vpc-ajay.id}"
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.first-igw.id}" 
    }
    tags {
        Name = "public-rt"
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
    tags {
        Name = "ssh-sg"
    }
}