# Project
project = "vault"

environment = "dev"

# Network
vpc_id = "vpc-c80c16ac"

db_subnet_group = ["subnet-83bae0f5", "subnet-7031925b"]

## DB

database_name = "vaultdb"

database_username = "mohan"

database_password = "Welcome1"

database_port = "5432"

parameter_group = "default.postgres11"

allocated_storage = "32"

postgress_engine_version = "11.5"

instance_type = "db.t2.micro"

storage_type = "gp2"

iops = "0"

# database_identifier = ""

# snapshot_identifier = ""

# backup_retention_period = "30"

# backup_window = "04:00-04:30"

# maintenance_window = ""

auto_minor_version_upgrade = "true"

# final_snapshot_identifier = ""

# final_snapshot_identifier

skip_final_snapshot = "true"

# copy_tags_to_snapshot = "default"

multi_availability_zone = "false"

# storage_encrypted

# monitoring_interval

deletion_protection = "false"