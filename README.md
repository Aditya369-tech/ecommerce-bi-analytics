# ecommerce-bi-analytics
End-to-End E-Commerce Analytics Dashboard using MySQL and Power BI
# 📊 E-Commerce Performance & Customer Analytics Dashboard

An end-to-end business intelligence project modeling transactional retail data in MySQL and visualizing key operations across a 3-page interactive Power BI dashboard.

---

## 🛠️ Architecture & Tech Stack
* **Database**: MySQL (Star Schema, Analytical Views)
* **BI Tool**: Microsoft Power BI Desktop
* **Analytical Modeling**: RFM Customer Segmentation, Sales Growth Velocity, Logistics Latency

---

## 📑 Dashboard Breakdown

### 1. Executive Revenue & Performance Overview
![Executive Overview](images/page1_overview.png)
* Top-line metrics: Revenue, Total Orders, Average Order Value (AOV), Customer Count, and Delivery Days.
* Monthly revenue velocity trends, category-level revenue contribution, payment method mix, and regional order volume.

### 2. Customer RFM Analysis
![Customer RFM Analysis](images/page2_rfm.png)
* Customer segmentation across Recency, Frequency, and Monetary value.
* Identifies revenue concentration among Champions/Loyal segments vs. At-Risk and Lost accounts.
* Scatter plot tracking engagement frequency against lifetime monetary spend.

### 3. Logistics & Customer Satisfaction
![Logistics and Satisfaction](images/page3_logistics.png)
* Correlation analysis between fulfillment speed tiers and customer review scores.
* Regional delivery volume mapped against transit duration.
* Baseline latency evaluation across payment methods and category-specific logistics tracking.

---

## 📂 Repository Contents
* `*.pbix` — Interactive Power BI Desktop report.
* `*.pdf` — Multi-page executive summary document.
* `*.sql` — Database schema creation and analytical view definitions.
