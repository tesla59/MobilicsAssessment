import boto3

def create_cloudwatch_alarm(instance_id):
    cloudwatch = boto3.client('cloudwatch')
    
    alarm_name = 'CPUUsageAlarm'
    alarm_description = 'Sample Alarm'
    metric_name = 'CPUUtilization'
    namespace = 'AWS/EC2'
    threshold = 80
    evaluation_periods = 5
    period = 60
    comparison_operator = 'GreaterThanThreshold'
    statistic = 'Average'
    
    response = cloudwatch.put_metric_alarm(
        AlarmName=alarm_name,
        AlarmDescription=alarm_description,
        ActionsEnabled=True,
        AlarmActions=[],
        MetricName=metric_name,
        Namespace=namespace,
        Statistic=statistic,
        Dimensions=[
            {
                'Name': 'Test Server',
                'Value': instance_id
            },
        ],
        Period=period,
        EvaluationPeriods=evaluation_periods,
        Threshold=threshold,
        ComparisonOperator=comparison_operator
    )
    
    print(f'CloudWatch alarm {alarm_name} created successfully.')

# Replace 'instance_id' with the actual EC2 instance ID
instance_id = 'your_instance_id'
create_cloudwatch_alarm(instance_id)
