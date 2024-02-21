# Desafio Técnico - Cientista de Dados Júnior

Para este desafio será necessário ter acesso ao Google Cloud Platform (GCP) para utilizar o BigQuery, onde serão visualizados e consultados os dados disponíveis no projeto `datario`.

## Conjunto de Dados

Os conjuntos de dados que serão utilizados neste desafio são:

- **Chamados do 1746:** Dados relacionados a chamados de serviços públicos na cidade do Rio de Janeiro. O caminho da tabela é: `datario.administracao_servicos_publicos.chamado_1746`
- **Bairros do Rio de Janeiro:** Dados sobre os bairros da cidade do Rio de Janeiro. O caminho da tabela é: `datario.dados_mestres.bairro`
- **Ocupação Hoteleira em Grandes Eventos no Rio**: Dados contendo o período de duração de alguns grandes eventos que ocorreram no Rio de Janeiro em 2022 e 2023 e a taxa de ocupação hoteleira da cidade nesses períodos. O caminho da tabela é: `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos`


## Análise SQL

1. Ir até o [GCP Console](https://console.cloud.google.com/) e criar uma conta Google ou utilizar a sua conta existente para realizar login
2. Criar ou selecionar um projeto existente com a opção *Sem organização*
3. Na barra de pesquisas ou no menu lateral procurar pelo *BigQuery*, que é onde iremos acessar os dados
4. Após entrar no console do *BigQuery*, iremos adicionar um novo projeto clicando em "+ Adicionar Dados" na barra Explorer.
5. Em seguida, clique em "Fixar projeto por nome" e procure pelo projeto **datario**.
6. Agora o projeto datario já está disponível na nossa barra explorer e podemos realizar nossas consultas.
7. Clicando no botão *New Query* é possível adicionar uma consulta SQL. As consultas deste projeto estão na página [analise_sql](https://github.com/gabryellesoares/emd-desafio-junior-data-scientist/analises/analise_sql.sql). Para visualizar, copie o trecho de uma das consultas, cole na caixa de texto e clique em **Run**/**Executar**.


Para mais detalhes, verifique o tutorial a seguir: [Como acessar dados no BigQuery](https://docs.dados.rio/tutoriais/como-acessar-dados/#como-criar-uma-conta-na-gcp)


## Análise Python
1. Clone o repositório utilizando o seguinte código no terminal: 
   ```
   git clone https://github.com/gabryellesoares/emd-desafio-junior-data-scientist/
   ```
2. Em seguida, navegue até a pasta do repositório e crie um ambiente virtual para instalar as bibliotecas necessárias inserindo o código `python -m venv venv` no terminal
3. Ative o ambiente utilizando `source venv/bin/activate`
4. Instale as dependências com `pip install -r requirements.txt`
5. Para baixar os dados utilizando a biblioteca **basedosdados** será necessário utilizar o ID do projeto criado anteriormente no GCP. Para isso, clique no nome do projeto ou em "Selecionar um projeto" no Console do GCP e copie o **ID** do projeto.
6. Abra o arquivo `config.json`, que está no repositório clonado, e insira o ID copiado anteriormente como valor da chave do arquivo (entre aspas). O resultado final deve ficar como o exemplo a seguir:
   ```
   {
    "billing_project_id": "id_copiado"
   }
   ```
   Esse ID do projeto será utilizado no notebook `analise_python.ipynb`.
7. Agora é possível executar todas as células presentes no notebook.


## Visualizações de Dados

Nesta etapa do desafio foi utilizada a ferramenta [LookerStudio](https://lookerstudio.google.com/). Para acessar a página de visualizações: [Desafio - Prefeitura Rio](https://lookerstudio.google.com/reporting/22c63905-7d09-49bb-b232-c0296f995ff9)
  

---
**Gabryelle Soares**