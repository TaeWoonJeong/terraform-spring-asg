output "output_lb_target_group_arn" {
  value = aws_lb_target_group.tw_target_group.arn
}

output "output_alb_arn_suffix" {
  value = aws_lb.tw_alb.arn_suffix
}

output "output_target_group_arn_suffix" {
  value = aws_lb_target_group.tw_target_group.arn_suffix
}