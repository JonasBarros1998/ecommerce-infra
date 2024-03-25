terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ADD_REGIAO"
}

data "aws_iam_policy_document" "gestao_de_pagamentos_policy_data" {
  statement {
    actions   = [
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:Createqueue",
      "sqs:Deletemessage"
    ]
    resources = [aws_sqs_queue.gestao_de_pagamentos.arn]
    effect = "Allow"
  }

}

resource "aws_iam_policy" "gestao_de_pagamentos_policy" {
  name = "gestao_pagamentos_sqs_policy"
  description = "Politica especifica para as filas para os servicos de pagamentos utilizam"
  policy = data.aws_iam_policy_document.gestao_de_pagamentos_policy_data.json
}

resource "aws_iam_user_policy_attachment" "gestao_de_pagamentos_attachament" {
  user       = "ADD_NOME_DO_USUARIO"
  policy_arn = aws_iam_policy.gestao_de_pagamentos_policy.arn
}

resource "aws_sqs_queue" "gestao_de_pagamentos" {
  name                      = "gestao_de_pagamentos"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 120
  receive_wait_time_seconds = 20
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.gestao_de_pagamentos_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Environment = "postech"
  }
}


resource "aws_sqs_queue" "gestao_de_pagamentos_dlq" {
  name = "gestao_de_pagamentos_dlq"
}


resource "aws_sqs_queue_redrive_allow_policy" "sqs_gestao_de_pagamentos_redrive_allow_policy" {
  queue_url = aws_sqs_queue.gestao_de_pagamentos_dlq.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.gestao_de_pagamentos.arn]
  })
}