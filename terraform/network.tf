#VPC============================================================================
module "ecs-vpc" {
  source               = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"
  name                 = "ecs-vpc"
  cidr                 = "10.0.0.0/16"
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets      = ["10.0.11.0/24", "10.0.22.0/24"]
  enable_dns_hostnames = "true"
  azs                  = ["eu-west-1a", "eu-west-1b"]
  enable_nat_gateway   = "true"
  igw_tags = {
    Name = "main"
  }
  tags = {
    Project = "ECS-X"
    Name    = "${var.name}-vpc"
  }
}
#Security Group=================================================================
module "ecs-sg" {
  source = "/home/vlad/Projects/Project_X_ECSF/modules/aws_security_group"
  ports  = ["80", "22", "3000"]
  name   = "ecs-sg"
  vpc_id = module.ecs-vpc.vpc_id
}
#Load Balancer==================================================================
resource "aws_lb" "ecs_lb" {
  name            = "ecs-lb"
  security_groups = [module.ecs-sg.sg_id]
  subnets         = [module.ecs-vpc.public_subnets[0], module.ecs-vpc.public_subnets[1]]

  tags = {
    Name    = "ecs-lb"
    Project = "ECS-X"
  }
}
#ALB Listener===================================================================
resource "aws_alb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}
#Target Group===================================================================
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.ecs-vpc.vpc_id
  tags = {
    Project = "ECS-X"
    Name    = "${var.name}-tg"
  }
}
