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

data "aws_iam_policy_document" "kms_policy_data" {
  statement {
    sid = "Usuario root com acesso total para a chave"
    actions   = ["kms:*"]
    resources = ["*"]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::ADD_USUARIO_ID_AWS:root"]
    }
  }

  statement {
    sid = "Usuarios com acessos para criptografar e descriptografar utilizando essa chave"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::ADD_ID_USUARIO_AWS:user/ADD_NOME_DO_USUARIO"]
    }
  }

}

resource "aws_kms_key" "chaves_kms" {
  key_usage = "ENCRYPT_DECRYPT"
  description             = "KMS_terraform"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  policy = data.aws_iam_policy_document.kms_policy_data.json
}

resource "aws_kms_alias" "chaves_kms_alias" {
  name          = "alias/kms_test_terraform"
  target_key_id = aws_kms_key.chaves_kms.key_id
}