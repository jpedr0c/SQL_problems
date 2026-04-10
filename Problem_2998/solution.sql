WITH acumulado AS (
    SELECT
        c.id,
        c.name,
        c.investment,
        o.month,
        SUM(o.profit) OVER (PARTITION BY c.id ORDER BY o.month) AS total_acumulado
    FROM clients c
             JOIN operations o ON c.id = o.client_id
),
     payback AS (
         SELECT
             id,
             name,
             investment,
    month,
    total_acumulado,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY month) AS rn
FROM acumulado
WHERE total_acumulado >= investment
    )
SELECT
    name,
    investment,
    month AS payback_month,
    (total_acumulado - investment) AS return
FROM payback
WHERE rn = 1
ORDER BY return DESC;