variable "aws_launch_template_id" {
  type = string
}

variable "aws_alb_target_group_arn" {
  type = string
}

variable "aws_subnet_ids" {
  type = list(string)
}