# Tech Challange - Infraestrutura

### Descrição
Nesse repositório encontra toda a infraestrutura que será construída na AWS. Também encontrará 

Utilizei os seguintes serviços: AWS SQS, AWS KMS, AWS Secret Manager e AWS IAM

Nesse repositório além de construir cada serviço mencionado acima, também iremos anexar somente as políticas necessárias para que possamos utilizar os serviços **(mais informações no vídeo de apresentação da arquitetura do projeto)**

### Requisitos essenciais para rodar a infra
- AWS CLI
- Terraform
- Usuário na AWS Console com política de Administrador.
- Usuário na AWS sem nenhuma política anexada

### O que deve ser atualizado nos scripts terraform
Se você navegar por cada script verá esse **ADD_** isso significa que você deverá substituir pelos valores que estão de acordo com o seu ambiente AWS. Por exemplo, **ADD_REGIAO_AWS** que dizer que você deverá substituir pela região da AWS que você
costuma utilizar no seu ambiente AWS.

Após conferir que todas as informações foram atualizadas, podemos prosseguir para o próximo etapa.
 
### Inicio rápido

- Para construir a infra, verifique se as credenciais `aws_access_key_id` e `aws_secret_access_key` estejam atualizadas e utilizando as credenciais gerados quando criou o usuario administrador
- Entre dentro da pasta **gestao pagamentos** e execute os seguintes comandos: `terraform init` e `terraform apply`
- Entre dentro da pasta **KMS** e rode os seguintes comandos: `terraform init` e `terraform apply`
- Entre dentro da pasta **secrets** e rode os seguintes comandos: `terraform init` e `terraform apply`
- Após os comandos serem executados com sucesso, verifique se a fila SQS e DLQ foram criadas, se os secrets foram criados com os valores corretos e as chaves do KMS também foram criados
- Se tudo foi criado, vá até o usuário que você anexou a politica de administrador e **remova-o**.
- Agora crie credenciais de acesso ao segundo usuário que você criou no passo (requisitos essenciais para rodar a infra). Observe também que nesse segundo usuário haverá apenas as políticas que realmente utilizaremos na aplicação.

### Banco de dados 
Esse comando não é necessário para executar a infraestrtura, porém será necessário para rodar todos os microsserviços

`docker run --name ecommerce -p 5432:5432 -e POSTGRES_PASSWORD=12345678 -e POSTGRES_USER=techchallange postgres:latest`


### Pontos de aprendizados

1- Criptografia: Nos trabalhos anteriores do tech challange, eu estava implementando criptografia porém com as chaves armazenadas no própio código. Nesse ponto tech challange, a segurança é um dos pontos ensinado, passei a utilizar chaves de criptografia gerenciada pela própria AWS. Para fazer a criptografia e descriptografia, utilizei os recursos do AWS Spring Cloud. 

2- Variáveis de ambiente: Não estou utilizando o arquivo application.yml para guardar as minhas variáveis de ambiente, para isso estou armazenando cada uma delas no **AWS Secrets Manager**. Logo essas variáveis ficam armazenadas fora do ambiente da minha aplicação. Para integrar cada uma ao meu projeto, estou utilizando a lib [Spring Cloud AWS](https://github.com/awspring/spring-cloud-aws) no qual já temos uma implementação do KMS e então é apenas carregar e referenciar no arquivo `application.yml`

3- Concorrência: Em alguns tech challange não implementei nenhuma estratégia de concorrência, mas nesse projeto tive que implementar. A estratégia que utilizei foi os recursos do Executor Framework do Java. Ao utilizá-lo consigo enfileirar as requisições mais críticas do meu projeto, como por exemplo ao finalizar a compra. Veja como implementei [FinalizarCompras.java](https://github.com/JonasBarros1998/postech-gestao-de-produtos/blob/167688036fde03430adf62d7f319a3755d41db5b/src/main/java/com/fiap/postechgestaoprodutos/aplicacao/FinalizarCompras.java#L43) 

### Políticas de acesso
Observe a image abaixo de como deverá ficar o seu usuário para que a aplicação possa rodar corretamente

![politicas de acesso](https://firebasestorage.googleapis.com/v0/b/app-english-class.appspot.com/o/Screenshot%20from%202024-03-24%2023-28-38.png?alt=media&token=d1a5e0ca-8a28-49ea-bc17-545069e22381)

- gestao_pagamentos_sqs_policy: Criado automaticamente pela infra no terraform
  
- ROSAKMSProviderPolicy: Pode anexar essa política criada pela própria AWS. Esse política tem todas as actions necessárias para criptografia e descriptografia logo não precisamos criar uma outra política.
  
- techchallange_microsservicos: Nós temos que criar essa política de forma personalizada. Veja como ficou o json da política abaixo:
  
``` json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ADD_NOME_PERSONALIZADO",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret"
            ],
            "Resource": "*"
        }
    ]
}
```

Veja que todas as políticas foram criadas utulizando apenas os recursos que iremos precisar. 

### Recursos criados na AWS ao executar esse script terraform
- 3 variáveis de ambiente
- 1 Chave de criptografia KMS
- 1 Fila AWS SQS
- 1 Fila AWS DLQ 


### Estrura de tabelas
Segue abaixo, como as tabelas ficaram estruturadas. Você verá detalhes de cada tabela e o motivo que utilizamos esse estrutura no vídeo de apresentação da arquitetura na plataform da FIAP

![diagrama de tabela](https://firebasestorage.googleapis.com/v0/b/app-english-class.appspot.com/o/Fase-5-tabelas.drawio.png?alt=media&token=8bd71988-7233-4b20-a9d6-88e9e2582fd6)


### Diagrama de arquitetura
Segue abaixo, como as tabelas ficaram estruturadas. Você verá detalhes de cada serviço e o motivo que utilizamos esse estrutura no vídeo de apresentação da arquitetura na plataforma da FIAP

![diagrama de arquitetura](https://firebasestorage.googleapis.com/v0/b/app-english-class.appspot.com/o/Fase-5-Diagrama-de-Arquitetura.drawio.png?alt=media&token=16d3247c-58d4-4411-aeda-65bbe68975fc)

### Collections do postman
[collections postmam](https://github.com/JonasBarros1998/ecommerce-infra/blob/main/collections-postman.json)



