#ECS CLUSTER====================================================================
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
  tags = {
    Name    = "ecs-cluster"
    Project = "ECS-X"
  }
}
#TASK DEFINITION================================================================
resource "aws_ecs_task_definition" "ecs-task" {
  family                   = "ecs-task"
  cpu                      = 512
  memory                   = 3072
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  container_definitions    = file("task_definition.json")
}
#SERVICE========================================================================
resource "aws_ecs_service" "ecs_service" {
  platform_version = "1.4.0"
  name             = "ecs-service"
  cluster          = aws_ecs_cluster.ecs_cluster.id
  task_definition  = aws_ecs_task_definition.ecs-task.arn
  launch_type      = "FARGATE"
  desired_count    = 2
  depends_on       = [aws_lb.ecs_lb, aws_alb_listener.ecs_listener, aws_lb_target_group.ecs_tg]

  network_configuration {
    subnets          = [module.ecs-vpc.private_subnets[0], module.ecs-vpc.private_subnets[1]]
    assign_public_ip = true
    security_groups  = [module.ecs-sg.sg_id]
  }

  load_balancer {
    container_name   = "nginx"
    container_port   = 80
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
  tags = {
    Project = "ECS-X"
    Name    = "ecs-service"
  }
}
