SELECT
    d.nome AS departamento,
    div.nome AS divisao,
    ROUND(COALESCE(AVG(sal.salario_liquido), 0), 2) AS media,
    ROUND(COALESCE(MAX(sal.salario_liquido), 0), 2) AS maior
FROM departamento d
         JOIN divisao div ON div.cod_dep = d.cod_dep
         JOIN (
    SELECT 
        e.matr,
        e.lotacao_div,
        COALESCE(venc.total_venc, 0) - COALESCE(desc_.total_desc, 0) AS salario_liquido
    FROM empregado e
             LEFT JOIN (
        SELECT ev.matr, SUM(v.valor) AS total_venc
        FROM emp_venc ev
                 JOIN vencimento v ON v.cod_venc = ev.cod_venc
        GROUP BY ev.matr
    ) venc ON venc.matr = e.matr
             LEFT JOIN (
        SELECT ed.matr, SUM(dc.valor) AS total_desc
        FROM emp_desc ed
                 JOIN desconto dc ON dc.cod_desc = ed.cod_desc
        WHERE dc.valor IS NOT NULL
        GROUP BY ed.matr
    ) desc_ ON desc_.matr = e.matr
) sal ON sal.lotacao_div = div.cod_divisao
GROUP BY d.nome, div.nome
ORDER BY media DESC;