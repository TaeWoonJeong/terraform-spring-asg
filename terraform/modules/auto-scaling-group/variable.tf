variable "autoscaling_group_name" {
  description = "ASG 이름입니다."
  default     = "tw-asg"
}

variable "aws_autoscaling_scale_out_policy_name" {
  description = "ASG의 scale_out 정책 이름입니다."
  default     = "tw-scale-out-policy"
}

variable "aws_autoscaling_scale_in_policy_name" {
  description = "ASG의 scale_in 정책 이름입니다."
  default     = "tw-scale-in-policy"
}

variable "ec2_name_tag_value" {
  description = "ec2 name tag value 입니다."
  default     = "my-ASG-EC2"
}