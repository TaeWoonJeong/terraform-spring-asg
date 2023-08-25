output "output_ec2_name_tag_value" {
  value = var.ec2_name_tag_value
}

output "output_scale_out_policy_arn" {
  value = aws_autoscaling_policy.tw_scale_out_policy.arn
}

output "output_scale_in_policy_arn" {
  value = aws_autoscaling_policy.tw_scale_in_policy.arn
}