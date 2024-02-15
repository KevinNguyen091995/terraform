output "main_vpc_id" {
    value = aws_vpc.main.id
}

output "public_us_east_2a_id" {
    value = aws_subnet.public_us_east_2a.id
}

output "public_us_east_2b_id" {
    value = aws_subnet.public_us_east_2b.id
}