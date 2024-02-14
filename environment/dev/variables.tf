variable "ami" {
    type = map
    default = {
        "linux-east" = "ami-0b59bfac6be064b78"
    }
}

variable "instance_type" {
    type = map
    default = {
        "micro-east" = "t2.micro"
    }
}