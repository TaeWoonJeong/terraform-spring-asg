terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  backend "s3" {
    bucket = "tw-spring-asg-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "subnet" {
  source     = "./modules/subnet"
  aws_vpc_id = module.vpc.output_vpc_id
}

module "igw" {
  source     = "./modules/igw"
  aws_vpc_id = module.vpc.output_vpc_id
}

module "key-pair" {
  source = "./modules/key-pair"
}

module "sg" {
  source     = "./modules/sg"
  aws_vpc_id = module.vpc.output_vpc_id
}

module "role" {
  source = "./modules/role"
}

module "public-rt-table" {
  source                     = "./modules/public-rt-table"
  aws_vpc_id                 = module.vpc.output_vpc_id
  aws_default_route_table_id = module.vpc.output_default_route_table_id
  aws_subnet_ids             = module.subnet.output_subnet_ids
  aws_igw_id                 = module.igw.output_igw_id
}

module "codedeploy-group" {
  source                          = "./modules/codedeploy-group"
  aws_ec2_name                    = module.auto-scaling-group.output_ec2_name_tag_value
  aws_codedeploy_service_role_arn = module.role.output_codedeploy_service_role_arn
}

module "alb" {
  source         = "./modules/alb"
  aws_sg_id      = module.sg.output_default_sg_id
  aws_vpc_id     = module.vpc.output_vpc_id
  aws_subnet_ids = module.subnet.output_subnet_ids
}

module "launch-template" {
  source                                   = "./modules/launch-template"
  aws_subnet_id                            = module.subnet.output_subnet_ids[0]
  aws_key_name                             = module.key-pair.output_key_name
  aws_sg_id                                = module.sg.output_default_sg_id
  aws_ec2_codedeploy_instance_profile_name = module.role.output_ec2_codedeploy_instance_profile_name
}

module "auto-scaling-group" {
  source                   = "./modules/auto-scaling-group"
  aws_launch_template_id   = module.launch-template.output_launch_template_id
  aws_alb_target_group_arn = module.alb.output_lb_target_group_arn
  aws_subnet_ids           = module.subnet.output_subnet_ids
}

module "cloudwatch" {
  source                      = "./modules/cloudwatch"
  aws_alb_arn_suffix          = module.alb.output_alb_arn_suffix
  aws_target_group_arn_suffix = module.alb.output_target_group_arn_suffix
  aws_scale_out_policy_arn    = module.auto-scaling-group.output_scale_out_policy_arn
  aws_scale_in_policy_arn     = module.auto-scaling-group.output_scale_in_policy_arn
}