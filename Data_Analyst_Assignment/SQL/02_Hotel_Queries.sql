-- 1. For every user in the system, get the user_id and last booked room_no
WITH RankedBookings AS (
    SELECT 
        user_id, 
        room_no,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY booking_date DESC) as rn
    FROM bookings
)
SELECT u.user_id, rb.room_no
FROM users u
LEFT JOIN RankedBookings rb ON u.user_id = rb.user_id AND rb.rn = 1;

-- 2. Get booking_id and total billing amount of every booking created in November, 2021
SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01' AND b.booking_date < '2021-12-01'
GROUP BY b.booking_id;

-- 3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01' AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- 4. Determine the most ordered and least ordered item of each month of year 2021
WITH ItemQuantities AS (
    SELECT 
        MONTH(bc.bill_date) AS bill_month,
        bc.item_id,
        SUM(bc.item_quantity) AS total_quantity
    FROM booking_commercials bc
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), bc.item_id
),
RankedItems AS (
    SELECT 
        bill_month,
        item_id,
        total_quantity,
        RANK() OVER(PARTITION BY bill_month ORDER BY total_quantity DESC) as rnk_desc,
        RANK() OVER(PARTITION BY bill_month ORDER BY total_quantity ASC) as rnk_asc
    FROM ItemQuantities
)
SELECT 
    bill_month,
    MAX(CASE WHEN rnk_desc = 1 THEN item_id END) AS most_ordered_item_id,
    MAX(CASE WHEN rnk_asc = 1 THEN item_id END) AS least_ordered_item_id
FROM RankedItems
GROUP BY bill_month;

-- 5. Find the customers with the second highest bill value of each month of year 2021
WITH BillTotals AS (
    SELECT 
        MONTH(bc.bill_date) AS bill_month,
        b.user_id,
        bc.bill_id,
        SUM(bc.item_quantity * i.item_rate) AS total_bill_amount
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id, bc.bill_id
),
RankedBills AS (
    SELECT 
        bill_month,
        user_id,
        total_bill_amount,
        DENSE_RANK() OVER(PARTITION BY bill_month ORDER BY total_bill_amount DESC) as rnk
    FROM BillTotals
)
SELECT bill_month, user_id, total_bill_amount
FROM RankedBills
WHERE rnk = 2;
