resource "aws_autoscaling_group" "tw_autoscaling_group" {
  name                = var.autoscaling_group_name
  vpc_zone_identifier = var.aws_subnet_ids
  launch_template {
    id      = var.aws_launch_template_id
    version = "$Latest"
  }
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  target_group_arns         = [var.aws_alb_target_group_arn]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  tag {
    key                 = "Name"
    value               = var.ec2_name_tag_value
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "tw_scale_out_policy" {
  name                   = var.aws_autoscaling_scale_out_policy_name
  autoscaling_group_name = aws_autoscaling_group.tw_autoscaling_group.name
  policy_type            = "SimpleScaling"
  cooldown               = 120
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
}

resource "aws_autoscaling_policy" "tw_scale_in_policy" {
  name                   = var.aws_autoscaling_scale_in_policy_name
  autoscaling_group_name = aws_autoscaling_group.tw_autoscaling_group.name
  policy_type            = "SimpleScaling"
  cooldown               = 120
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
}

# cloudwatch경보의 조건 변경 불가능해서, 단순조정으로 바꾸고 경보 생성하기
# resource "aws_autoscaling_policy" "tw_autoscaling_policy" {
#   name                   = var.aws_autoscaling_policy_name
#   autoscaling_group_name = aws_autoscaling_group.tw_autoscaling_group.name
#   policy_type            = "TargetTrackingScaling"
#   target_tracking_configuration {
#     target_value = 100
#     predefined_metric_specification {
#       predefined_metric_type = "ALBRequestCountPerTarget"
#       resource_label         = "${var.aws_split_alb}/targetgroup/${var.aws_split_target_group}"
#     }
#   }
# }