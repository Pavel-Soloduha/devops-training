resource "aws_cloudwatch_metric_alarm" "cpu_util" {
  alarm_name          = "cpu_util"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  threshold           = "1"
  metric_name         = "CPUUtilization"
  statistic           = "Maximum"
  period              = "60"
  namespace           = "AWS/EC2"
  alarm_actions       = [data.aws_sns_topic.smtp_topic.arn]
  ok_actions          = [data.aws_sns_topic.smtp_topic.arn]
}

data "aws_sns_topic" "smtp_topic" {
  name = "personal_smtp_topic"
}