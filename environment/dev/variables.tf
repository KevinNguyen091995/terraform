variable "ami" {
    type = map
    default = {
        "linux-east" = "ami-0c20d88b0021158c6"
    }
}

variable "instance_type" {
    type = map
    default = {
        "micro-east" = "t2.micro"
    }
}