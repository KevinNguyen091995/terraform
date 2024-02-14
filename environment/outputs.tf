output "main_vpc_id" {
    value = aws_vpc.main.id
}

output "private_us_east_2a" {
    value = aws_subnet.private_us_east_2a.id
}

output "private_us_east_2b" {
    value = aws_subnet.private_us_east_2b.id
}

output "public_us_east_2a" {
    value = aws_subnet.public_us_east_2a.id
}

output "public_us_east_2b" {
    value = aws_subnet.public_us_east_2b.id
}