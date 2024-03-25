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



/*
 *
 *  Variaveis de ambientes para o banco de dados
 *
*/

resource "aws_secretsmanager_secret" "chave_de_seguranca_banco_de_dados" {
  name = "/secrets/base_de_dados_ecommerce_v2"
  description = "Senha da base de dados utilizada pelas aplicações de armazenamento de produtos e usurios"
}

variable "base_de_dados_segredos" {
  default = {
    senha = "12345678"
    nome_do_usuario = "techchallange"
  }

  type = map(string)
}

resource "aws_secretsmanager_secret_version" "base_de_dados" {
  secret_id     = aws_secretsmanager_secret.chave_de_seguranca_banco_de_dados.id
  secret_string = jsonencode(var.base_de_dados_segredos)
}



/*
 *
 *  Variaveis de ambientes para gestao de acessos
 *
*/

resource "aws_secretsmanager_secret" "chave_de_seguranca_gestao_de_acessos" {
  name = "/secrets/chaves_de_seguranca_v2"
  description = "secrets especificos para login com google"
}

variable "credenciais_login_google" {
  default = {
    id_cliente = "ADD_CLIENT_ID_GOOGLE"
    segredo_cliente = "ADD_SECRET_ID_GOOGLE"
  }

  type = map(string)
}

resource "aws_secretsmanager_secret_version" "gestao_de_usuarios" {
  secret_id     = aws_secretsmanager_secret.chave_de_seguranca_gestao_de_acessos.id
  secret_string = jsonencode(var.credenciais_login_google)
}



/*
 *
 *  Variaveis de ambientes para armazenar o ID do KMS
 *
*/

resource "aws_secretsmanager_secret" "chave_de_seguranca_kms" {
  name = "/secrets/kms_id_v2"
  description = "secrets para armazenar o ID do AWS KMS para criptografia dos dados do banco"
}

variable "credenciais_kms" {
  default = {
    kms_id = "ADD_KMS_ID"
  }

  type = map(string)
}

resource "aws_secretsmanager_secret_version" "secrets_kms" {
  secret_id     = aws_secretsmanager_secret.chave_de_seguranca_kms.id
  secret_string = jsonencode(var.credenciais_kms)
}
