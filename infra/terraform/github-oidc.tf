resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

resource "aws_iam_role" "github_deploy" {
  name = "devops-lab-github-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:AlphaKoder7@128501272/Devops-Lab@1360529244:ref:refs/heads/main"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_deploy" {
  name = "devops-lab-github-deploy"
  role = aws_iam_role.github_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:SendCommand"
        ]

        Resource = [
          "arn:aws:ssm:ap-south-1::document/AWS-RunShellScript",
          aws_instance.platform.arn
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "ssm:GetCommandInvocation"
        ]

        Resource = "*"
      }
    ]
  })
}

output "github_deploy_role_arn" {
  value = aws_iam_role.github_deploy.arn
}
