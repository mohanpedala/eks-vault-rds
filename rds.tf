resource "aws_db_subnet_group" "db_sub_group" {
  name       = "rds_subnet_group"
  subnet_ids = var.aws_subnet_group

  tags = merge(
    {
      Name        = "vault db subnet group",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

# Security group resources
resource "aws_security_group" "db_security_group" {
  vpc_id = var.vpc_id

  ingress {
    description = "tcp"
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "sgvaultdb",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}



# RDS resources
resource "aws_db_instance" "postgresql" {
  allocated_storage               = var.allocated_storage
  engine                          = "postgres"
  engine_version                  = var.postgress_engine_version
  # identifier                      = var.database_identifier
  # snapshot_identifier             = var.snapshot_identifier
  instance_class                  = var.instance_type
  storage_type                    = var.storage_type
  iops                            = var.iops
  name                            = var.database_name
  password                        = var.database_password
  username                        = var.database_username
  # backup_retention_period         = var.backup_retention_period
  # backup_window                   = var.backup_window
  # maintenance_window              = var.maintenance_window
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  # final_snapshot_identifier       = var.final_snapshot_identifier
  skip_final_snapshot             = var.skip_final_snapshot
  # copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  multi_az                        = var.multi_availability_zone
  port                            = var.database_port
  vpc_security_group_ids          = [aws_security_group.db_security_group.id]
  db_subnet_group_name            = aws_db_subnet_group.db_sub_group.id
  parameter_group_name            = var.parameter_group
  # storage_encrypted               = var.storage_encrypted
  # monitoring_interval             = var.monitoring_interval
  # monitoring_role_arn             = var.monitoring_interval > 0 ? aws_iam_role.enhanced_monitoring.arn : ""
  deletion_protection             = var.deletion_protection
  # enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports
  publicly_accessible = "true"

  tags = merge(
    {
      Name        = "vaultdb",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
  depends_on = [ aws_security_group.db_security_group, ]
}

#
# CloudWatch resources
#
# resource "aws_cloudwatch_metric_alarm" "database_cpu" {
#   alarm_name          = "alarm${var.environment}DatabaseServerCPUUtilization-${var.database_identifier}"
#   alarm_description   = "Database server CPU utilization"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/RDS"
#   period              = "300"
#   statistic           = "Average"
#   threshold           = var.alarm_cpu_threshold

#   dimensions = {
#     DBInstanceIdentifier = aws_db_instance.postgresql.id
#   }

#   alarm_actions             = var.alarm_actions
#   ok_actions                = var.ok_actions
#   insufficient_data_actions = var.insufficient_data_actions
# }

# resource "aws_cloudwatch_metric_alarm" "database_disk_queue" {
#   alarm_name          = "alarm${var.environment}DatabaseServerDiskQueueDepth-${var.database_identifier}"
#   alarm_description   = "Database server disk queue depth"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "DiskQueueDepth"
#   namespace           = "AWS/RDS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = var.alarm_disk_queue_threshold

#   dimensions = {
#     DBInstanceIdentifier = aws_db_instance.postgresql.id
#   }

#   alarm_actions             = var.alarm_actions
#   ok_actions                = var.ok_actions
#   insufficient_data_actions = var.insufficient_data_actions
# }

# resource "aws_cloudwatch_metric_alarm" "database_disk_free" {
#   alarm_name          = "alarm${var.environment}DatabaseServerFreeStorageSpace-${var.database_identifier}"
#   alarm_description   = "Database server free storage space"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "FreeStorageSpace"
#   namespace           = "AWS/RDS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = var.alarm_free_disk_threshold

#   dimensions = {
#     DBInstanceIdentifier = aws_db_instance.postgresql.id
#   }

#   alarm_actions             = var.alarm_actions
#   ok_actions                = var.ok_actions
#   insufficient_data_actions = var.insufficient_data_actions
# }

# resource "aws_cloudwatch_metric_alarm" "database_memory_free" {
#   alarm_name          = "alarm${var.environment}DatabaseServerFreeableMemory-${var.database_identifier}"
#   alarm_description   = "Database server freeable memory"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "FreeableMemory"
#   namespace           = "AWS/RDS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = var.alarm_free_memory_threshold

#   dimensions = {
#     DBInstanceIdentifier = aws_db_instance.postgresql.id
#   }

#   alarm_actions             = var.alarm_actions
#   ok_actions                = var.ok_actions
#   insufficient_data_actions = var.insufficient_data_actions
# }

# resource "aws_cloudwatch_metric_alarm" "database_cpu_credits" {
#   // This results in 1 if instance_type starts with "db.t", 0 otherwise.
#   count = substr(var.instance_type, 0, 3) == "db.t" ? 1 : 0

#   alarm_name          = "alarm${var.environment}DatabaseCPUCreditBalance-${var.database_identifier}"
#   alarm_description   = "Database CPU credit balance"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUCreditBalance"
#   namespace           = "AWS/RDS"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = var.alarm_cpu_credit_balance_threshold

#   dimensions = {
#     DBInstanceIdentifier = aws_db_instance.postgresql.id
#   }

#   alarm_actions             = var.alarm_actions
#   ok_actions                = var.ok_actions
#   insufficient_data_actions = var.insufficient_data_actions
# }
