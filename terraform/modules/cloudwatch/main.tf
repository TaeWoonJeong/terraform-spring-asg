resource "aws_cloudwatch_metric_alarm" "tw_cloudwatch_metric_scale_out_alarm" {
  alarm_name          = "tw-ELB-request-scale_out_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 1000
  alarm_description   = "ELB request scale out alarm"

  metric_name = "RequestCount"
  namespace   = "AWS/ApplicationELB"
  period      = 60
  statistic   = "Sum"
  dimensions = {
    LoadBalancer = var.aws_alb_arn_suffix
    TargetGroup  = var.aws_target_group_arn_suffix
  }
  alarm_actions = [var.aws_scale_out_policy_arn]
}

resource "aws_cloudwatch_metric_alarm" "tw_cloudwatch_metric_scale_in_alarm" {
  alarm_name          = "tw-ELB-request-scale_in_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 1000
  alarm_description   = "ELB request scale in alarm"

  metric_name = "RequestCount"
  namespace   = "AWS/ApplicationELB"
  period      = 60
  statistic   = "Sum"
  dimensions = {
    LoadBalancer = var.aws_alb_arn_suffix
    TargetGroup  = var.aws_target_group_arn_suffix
  }
  alarm_actions = [var.aws_scale_in_policy_arn]
}