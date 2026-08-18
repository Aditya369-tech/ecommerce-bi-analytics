use ecommerce_project;
-- View 1 Customer RMF Segmentation

CREATE OR REPLACE VIEW vw_customer_rfm_segments AS
WITH customer_base_metrics AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(revenue), 2) AS total_spend,
        ROUND(AVG(customer_rating), 2) AS avg_rating
    FROM ecommerce_sales
    GROUP BY customer_id
),
rfm_raw AS (
    SELECT 
        customer_id,
        DATEDIFF((SELECT MAX(order_date) FROM ecommerce_sales), last_order_date) AS recency_days,
        total_orders AS frequency,
        total_spend AS monetary,
        avg_rating
    FROM customer_base_metrics
),
rfm_scores AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary,
        avg_rating,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_raw
)
SELECT 
    customer_id,
    recency_days,
    frequency,
    monetary,
    avg_rating,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) AS rfm_combined_score,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Recent New Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk / Need Attention'
        WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2 THEN 'Lost Customers'
        ELSE 'Potential Loyalists'
    END AS customer_segment
FROM rfm_scores;

-- View 2 Monthly Sales and MOM Growth

CREATE OR REPLACE VIEW vw_monthly_sales_growth AS
WITH monthly_aggregation AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m-01') AS sales_month,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS total_active_customers,
        SUM(quantity) AS total_units_sold,
        ROUND(SUM(revenue), 2) AS monthly_revenue,
        ROUND(AVG(revenue), 2) AS average_order_value
    FROM ecommerce_sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
)
SELECT 
    sales_month,
    total_orders,
    total_active_customers,
    total_units_sold,
    monthly_revenue,
    average_order_value,
    LAG(monthly_revenue, 1) OVER (ORDER BY sales_month ASC) AS prev_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY sales_month ASC)) 
        / LAG(monthly_revenue, 1) OVER (ORDER BY sales_month ASC) * 100, 
        2
    ) AS mom_growth_pct
FROM monthly_aggregation;

-- View 3 Logistics and Customer Satisfaction

CREATE OR REPLACE VIEW vw_logistics_and_satisfaction AS
SELECT 
    region,
    product_category,
    payment_method,
    CASE 
        WHEN delivery_days <= 2 THEN 'Express (0-2 days)'
        WHEN delivery_days BETWEEN 3 AND 5 THEN 'Standard (3-5 days)'
        ELSE 'Delayed (> 5 days)'
    END AS delivery_speed_tier,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(delivery_days), 1) AS avg_delivery_days,
    ROUND(AVG(customer_rating), 2) AS avg_rating,
    ROUND(AVG(discount * 100), 1) AS avg_discount_pct,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ecommerce_sales
GROUP BY 
    region,
    product_category,
    payment_method,
    CASE 
        WHEN delivery_days <= 2 THEN 'Express (0-2 days)'
        WHEN delivery_days BETWEEN 3 AND 5 THEN 'Standard (3-5 days)'
        ELSE 'Delayed (> 5 days)'
    END;
    