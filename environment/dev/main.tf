### EC2
resource "aws_instance" "web_server" {
    ami = var.ami["linux-east"]
    instance_type = var.instance_type["micro-east"]
    subnet_id = module.network.private_us_east_2a
    vpc_security_group_ids = ["${aws_security_group.web_server_sg.id}"]
    security_groups = [ aws_security_group.web_server_sg.id ]

    user_data = file("${path.module}/hello_webserver.sh")

    tags = {
        Name = "web_server"
    }
}

resource "aws_instance" "web_server2" {
    ami = "ami-0b59bfac6be064b78"
    instance_type = "t2.micro"
    subnet_id = module.network.private_us_east_2b
    vpc_security_group_ids = ["${aws_security_group.web_server_sg.id}"]
    security_groups = [ aws_security_group.web_server_sg.id ]

    user_data = file("${path.module}/hello_webserver.sh")

    tags = {
        Name = "web_server"
    }
}


### ALB
resource "aws_lb" "web_server_alb" {
    name = "web-server-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = ["${aws_security_group.web_server_alb_sg.id}"]
    subnets = [
        module.network.private_us_east_2a,
        module.network.private_us_east_2b,
    ]
}

resource "aws_lb_target_group" "web_server_target_group" {
  name     = "web-server-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.main_vpc_id

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "alb_web_server_listener" {
    load_balancer_arn = aws_lb.web_server_alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.web_server_target_group.arn
    }
}

resource "aws_lb_target_group_attachment" "web_server_attachment" {
  target_group_arn = aws_lb_target_group.web_server_target_group.arn
  target_id        = aws_instance.web_server.id

}

resource "aws_lb_target_group_attachment" "web_server2_attachment" {
  target_group_arn = aws_lb_target_group.web_server_target_group.arn
  target_id        = aws_instance.web_server2.id

}


resource "aws_security_group" "web_server_alb_sg" {
    name = "web-server-alb-sg"
    vpc_id = module.network.main_vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_server_sg" {
    name = "web-server-sg"
    vpc_id = module.network.main_vpc_id

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.web_server_alb_sg.id}"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP traffic from any source
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}