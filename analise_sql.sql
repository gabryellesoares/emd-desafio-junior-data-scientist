-- 1. Quantos chamados foram abertos no dia 01/04/2023?

SELECT COUNT(*)
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE DATE('2023-04-01') = DATE(data_inicio);


-- 2. Qual o tipo de chamado que teve mais reclamações no dia 01/04/2023?

SELECT tipo
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE DATE('2023-04-01') = DATE(data_inicio)
GROUP BY tipo
ORDER BY COUNT(*) DESC
LIMIT 1;


-- 3. Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?

SELECT nome AS bairro
FROM `datario.dados_mestres.bairro`
WHERE id_bairro IN (
  SELECT id_bairro
  FROM `datario.administracao_servicos_publicos.chamado_1746`
  WHERE DATE('2023-04-01') = DATE(data_inicio)
  GROUP BY id_bairro
  ORDER BY COUNT(*) DESC
  LIMIT 3
);


-- 4. Qual o nome da subprefeitura com mais chamados abertos nesse dia?
-- mais chamados que foram abertos ou mais chamados que foram abertos e ainda nao foram fechados?
SELECT subprefeitura
FROM `datario.dados_mestres.bairro`
WHERE id_bairro IN (
  SELECT id_bairro
  FROM `datario.administracao_servicos_publicos.chamado_1746`
  WHERE DATE('2023-04-01') = DATE(data_inicio)
  GROUP BY id_bairro
  ORDER BY COUNT(*) DESC
  LIMIT 1
);


-- 5. Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?

SELECT id_chamado
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE DATE(data_inicio) = DATE('2023-04-01')
AND id_bairro IS NULL;


-- 6. Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)?

SELECT COUNT(*)
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE subtipo = 'Perturbação do sossego'
AND DATE(data_inicio) BETWEEN DATE('2022-01-01') AND DATE('2023-12-31');


-- 7. Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).

SELECT c.id_chamado, r.evento
FROM `datario.administracao_servicos_publicos.chamado_1746` c
INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` r
ON c.data_inicio BETWEEN r.data_inicial AND r.data_final
WHERE subtipo = 'Perturbação do sossego'
AND r.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio');


-- 8. Quantos chamados desse subtipo foram abertos em cada evento?

SELECT r.evento, COUNT(c.id_chamado) AS qtd_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746` c
INNER JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` r
ON c.data_inicio BETWEEN r.data_inicial AND r.data_final
WHERE subtipo = 'Perturbação do sossego'
AND r.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
GROUP BY r.evento;


-- 9. Qual evento teve a maior média diária de chamados abertos desse subtipo?

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

-- rock in rio 119.14 carnaval 60.25 reveillon 45.67
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


-- 63.2
SELECT ROUND(AVG(qtd_chamados), 2) AS media_diaria_periodo
FROM (
  SELECT COUNT(*) AS qtd_chamados
  FROM `datario.administracao_servicos_publicos.chamado_1746`
  WHERE subtipo = 'Perturbação do sossego'
    AND DATE(data_inicio) BETWEEN DATE('2022-01-01') AND DATE('2023-12-31')
  GROUP BY DATE(data_inicio)
)
ORDER BY media_diaria_periodo DESC;
