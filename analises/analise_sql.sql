-- 1. Quantos chamados foram abertos no dia 01/04/2023?
-- Foram abertos 73 chamados neste dia

SELECT COUNT(*) AS qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE DATE(data_inicio) = DATE('2023-04-01')
  AND data_particao = DATE('2023-04-01');


-- 2. Qual o tipo de chamado que teve mais reclamações no dia 01/04/2023?
-- Poluição sonora

SELECT tipo
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE DATE(data_inicio) = DATE('2023-04-01')
  AND data_particao = DATE('2023-04-01')
GROUP BY tipo
ORDER BY COUNT(*) DESC
LIMIT 1;


-- 3. Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
-- Leblon, Engenho de Dentro e Campo Grande

SELECT nome AS bairro
FROM `datario.dados_mestres.bairro`
WHERE id_bairro IN (
  SELECT id_bairro
  FROM `datario.administracao_servicos_publicos.chamado_1746`
  WHERE DATE(data_inicio) = DATE('2023-04-01')
    AND data_particao = DATE('2023-04-01')
  GROUP BY id_bairro
  ORDER BY COUNT(*) DESC
  LIMIT 3
);


-- 4. Qual o nome da subprefeitura com mais chamados abertos nesse dia?
-- Zona Norte
SELECT subprefeitura
FROM `datario.dados_mestres.bairro`
WHERE id_bairro IN (
  SELECT id_bairro
  FROM `datario.administracao_servicos_publicos.chamado_1746`
  WHERE DATE(data_inicio) = DATE('2023-04-01')
    AND data_particao = DATE('2023-04-01')
  GROUP BY id_bairro
  ORDER BY COUNT(*) DESC
  LIMIT 1
);


-- 5. Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
-- Sim. O chamado em questão possui o id "18516246", com "tipo "Ônibus" e subtipo "Verificação de ar condicionado inoperante no ônibus", 
-- que é um chamado que não se encaixaria em algum bairro específico.
-- Como a associação entre as duas tabelas é feita através do campo id_bairro, não é necessário verificar as duas tabelas em relação à subprefeitura.

SELECT *
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE DATE(data_inicio) = DATE('2023-04-01')
  AND data_particao = DATE('2023-04-01')
  AND id_bairro IS NULL;


-- 6. Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)?
-- 42408 chamados

SELECT COUNT(*) AS qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE subtipo = 'Perturbação do sossego'
  AND data_particao BETWEEN DATE('2022-01-01') AND DATE('2023-12-31');


-- 7. Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).

SELECT r.evento, c.id_chamado
FROM `datario.administracao_servicos_publicos.chamado_1746` c
INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` r
ON DATE(c.data_inicio) BETWEEN r.data_inicial AND r.data_final
WHERE subtipo = 'Perturbação do sossego'
  AND r.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio');


-- 8. Quantos chamados desse subtipo foram abertos em cada evento?
-- Temos 834 chamados abertos durante o Rock in Rio, 241 durante o Carnaval e 137 durante o Reveillon.

SELECT r.evento, COUNT(c.id_chamado) AS qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` c
INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` r
ON DATE(c.data_inicio) BETWEEN r.data_inicial AND r.data_final
WHERE subtipo = 'Perturbação do sossego'
  AND r.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
GROUP BY r.evento;


-- 9. Qual evento teve a maior média diária de chamados abertos desse subtipo?
-- Rock in Rio, com uma média diária de aproximadamente 119.14 chamados abertos

SELECT evento, ROUND(AVG(qtd_chamados), 2) AS media_diaria
FROM (
  SELECT r.evento, DATE(c.data_inicio) AS data_chamado, COUNT(*) AS qtd_chamados
  FROM `datario.administracao_servicos_publicos.chamado_1746` c
  INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` r
  ON DATE(c.data_inicio) BETWEEN r.data_inicial AND r.data_final
  WHERE subtipo = 'Perturbação do sossego'
    AND r.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
  GROUP BY r.evento, DATE(c.data_inicio)
)
GROUP BY evento
ORDER BY media_diaria DESC
LIMIT 1;


-- 10. Compare as médias diárias de chamados abertos desse subtipo durante os eventos específicos (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos desse subtipo considerando todo o período de 01/01/2022 até 31/12/2023.
-- Temos uma média diária de aproximadamente 119.14, 60.25 e 45.67, respectivamente, para os eventos de Rock in Rio, Carnaval e Reveillon.
-- Já a média diária para os chamados abertos durante o período de 01/01/2022 até 31/12/2023 foi de 63.2

-- Rock in Rio: 119.14
-- Carnaval: 60.25
-- Reveillon 45.67

-- Selecionando chamados abertos durante os eventos:
SELECT evento, ROUND(AVG(qtd_chamados), 2) AS media_diaria
FROM (
  SELECT r.evento, COUNT(*) AS qtd_chamados
  FROM `datario.administracao_servicos_publicos.chamado_1746` c
  INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` r
  ON DATE(c.data_inicio) BETWEEN r.data_inicial AND r.data_final
  WHERE subtipo = 'Perturbação do sossego'
    AND r.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
  GROUP BY r.evento, DATE(c.data_inicio)
)
GROUP BY evento
ORDER BY media_diaria DESC;


-- Média Diária: 63.2

-- Selecionando os chamados abertos considerando o período de 01/01/2022 até 31/12/2023
SELECT ROUND(AVG(qtd_chamados), 2) AS media_diaria_periodo
FROM (
  SELECT COUNT(*) AS qtd_chamados
  FROM `datario.administracao_servicos_publicos.chamado_1746`
  WHERE subtipo = 'Perturbação do sossego'
    AND data_particao BETWEEN DATE('2022-01-01') AND DATE('2023-12-31')
  GROUP BY DATE(data_inicio)
);
