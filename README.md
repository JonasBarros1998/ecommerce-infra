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
Se você navegar por cada script verá esse ADD_ isso significa que você deverá substituir pelos valores que estão de acordo com o seu ambiente AWS. Por exemplo, ADD_REGIAO_AWS que dizer que você deverá substituir pela região da AWS que você
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



