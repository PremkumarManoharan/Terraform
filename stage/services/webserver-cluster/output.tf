output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "The is the DNS name for the load balancer"
}