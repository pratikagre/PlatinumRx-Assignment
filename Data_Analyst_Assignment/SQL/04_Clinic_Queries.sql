-- 1. Find the revenue we got from each sales channel in a given year
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

-- 2. Find top 10 the most valuable customers for a given year
SELECT 
    c.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY c.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year
WITH MonthlyRevenue AS (
    SELECT 
        MONTH(datetime) as month_num,
        SUM(amount) as revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
MonthlyExpense AS (
    SELECT 
        MONTH(datetime) as month_num,
        SUM(amount) as expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT 
    COALESCE(r.month_num, e.month_num) AS month_num,
    COALESCE(r.revenue, 0) AS revenue,
    COALESCE(e.expense, 0) AS expense,
    (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)) AS profit,
    CASE 
        WHEN (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)) > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM MonthlyRevenue r
LEFT JOIN MonthlyExpense e ON r.month_num = e.month_num
UNION
SELECT 
    e.month_num,
    COALESCE(r.revenue, 0) AS revenue,
    COALESCE(e.expense, 0) AS expense,
    (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)) AS profit,
    CASE 
        WHEN (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)) > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM MonthlyExpense e
LEFT JOIN MonthlyRevenue r ON e.month_num = r.month_num;

-- 4. For each city find the most profitable clinic for a given month (e.g., September)
WITH ClinicProfits AS (
    SELECT 
        c.city,
        c.cid,
        c.clinic_name,
        COALESCE((SELECT SUM(amount) FROM clinic_sales cs WHERE cs.cid = c.cid AND MONTH(cs.datetime) = 9 AND YEAR(cs.datetime) = 2021), 0) -
        COALESCE((SELECT SUM(amount) FROM expenses e WHERE e.cid = c.cid AND MONTH(e.datetime) = 9 AND YEAR(e.datetime) = 2021), 0) AS profit
    FROM clinics c
),
RankedProfits AS (
    SELECT 
        city,
        cid,
        clinic_name,
        profit,
        RANK() OVER(PARTITION BY city ORDER BY profit DESC) as rnk
    FROM ClinicProfits
)
SELECT city, cid, clinic_name, profit
FROM RankedProfits
WHERE rnk = 1;

-- 5. For each state find the second least profitable clinic for a given month (e.g., September)
WITH ClinicProfits AS (
    SELECT 
        c.state,
        c.cid,
        c.clinic_name,
        COALESCE((SELECT SUM(amount) FROM clinic_sales cs WHERE cs.cid = c.cid AND MONTH(cs.datetime) = 9 AND YEAR(cs.datetime) = 2021), 0) -
        COALESCE((SELECT SUM(amount) FROM expenses e WHERE e.cid = c.cid AND MONTH(e.datetime) = 9 AND YEAR(e.datetime) = 2021), 0) AS profit
    FROM clinics c
),
RankedProfits AS (
    SELECT 
        state,
        cid,
        clinic_name,
        profit,
        RANK() OVER(PARTITION BY state ORDER BY profit ASC) as rnk
    FROM ClinicProfits
)
SELECT state, cid, clinic_name, profit
FROM RankedProfits
WHERE rnk = 2;
