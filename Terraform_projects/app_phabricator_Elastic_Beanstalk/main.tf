provider "aws" {
  region = var.region
}

resource "aws_elastic_beanstalk_application" "tftest" {
  name        = var.name
  description = var.name
}

resource "aws_s3_bucket" "default" {
  bucket = var.name
  force_destroy = true
}

//resource "aws_s3_bucket_object" "default" {
//  bucket = aws_s3_bucket.default.id
//  key    = "beanstalk/go-v1.zip"
//  source = "go-v1.zip"
//}

//resource "aws_elastic_beanstalk_application" "default" {
//  name        = "tf-test-name"
//  description = "tf-test-desc"
//}

//resource "aws_elastic_beanstalk_application_version" "default" {
//  name        = "tf-test-version-label"
//  application = "tf-test-name"
//  description = "application version created by terraform"
//  bucket      = aws_s3_bucket.default.id
//  key         = aws_s3_bucket_object.default.id
//}

resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = var.name
  application         = aws_elastic_beanstalk_application.tftest.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.11 running PHP 5.5"
//  launch_configurations = aws_launch_configuration.as_conf.arn
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.instance_type
    resource  = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "db_endpoint"
    value     = aws_db_instance.db.endpoint
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "db_user"
    value     = var.db_settings.db_user
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "db_password"
    value     = var.db_settings.db_password
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.autoscale_min
    resource  = ""
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.autoscale_max
    resource  = ""
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2.name
    resource  = ""
  }
}


resource "aws_iam_instance_profile" "ec2" {
  name = "eb-ec2"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role" "ec2" {
  name               = "eb-ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
//  tags               = module.this.tags
}

data "aws_iam_policy_document" "ec2" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = 5
  engine               = "MariaDB"
  engine_version       = "10.4.13"
  instance_class       = "db.t2.micro"
  name                 = "dimabeanstalkenv"
  username             = var.db_settings.db_user
  password             = var.db_settings.db_password
//  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_launch_configuration" "as_conf" {
  name          = var.name
  image_id      = "ami-09fa8b7e08953d968"
  instance_type = var.instance_type
}



//  + resource "aws_elastic_beanstalk_environment" "tfenvtest" {
//      + all_settings           = (known after apply)
//      + application            = "dima-beanstalk-env"
//      + arn                    = (known after apply)
//      + autoscaling_groups     = (known after apply)
//      + cname                  = (known after apply)
//      + cname_prefix           = (known after apply)
//      + endpoint_url           = (known after apply)
//      + id                     = (known after apply)
//      + instances              = (known after apply)
//      + launch_configurations  = (known after apply)
//      + load_balancers         = (known after apply)
//      + name                   = "dima-beanstalk-env"
//      + platform_arn           = (known after apply)
//      + queues                 = (known after apply)
//      + solution_stack_name    = "64bit Amazon Linux 2018.03 v2.9.11 running PHP 5.5"
//      + tags_all               = (known after apply)
//      + tier                   = "WebServer"
//      + triggers               = (known after apply)
//      + version_label          = (known after apply)
//      + wait_for_ready_timeout = "20m"
//    }