# AnalystLab — Weeks 1 & 2: Data Cleaning, Exploratory Analysis & Visualization

## 📌 Project Overview
This repository contains end-to-end Python workflows covering data cleaning, exploratory data analysis (EDA), and data visualization executed inside Jupyter Notebooks across two primary datasets:
1. Online Retail Dataset (E-Commerce transactional performance)
2. Netflix Titles Dataset (Streaming catalog metadata & content distribution)

---

## 🛠️ Tools & Libraries Used
* Python (Pandas, NumPy): Data cleaning, schema transformation, and aggregations.
* Data Visualization (Matplotlib, Seaborn): Generating statistical charts, distributions, and trend visuals.
* Jupyter Notebooks: Interactive environment for data exploration and visual storytelling.
* Google Docs / Sheets: Executive summary drafting and insights reporting.

---

## 🔗 Dataset Access
Due to file size constraints on GitHub, the raw and cleaned datasets are hosted on Google Drive:
* 📂 [Access Project Datasets on Google Drive] https://drive.google.com/drive/folders/1ftfkG9HxSgcMgEGpxEiADaXthPxqTjCK?usp=sharing

---

## 🧹 Data Cleaning Highlights

### 1. Online Retail Dataset
* Data Integrity: Handled null customer IDs, imputed descriptions, and dropped duplicate transaction records.
* Business Logic Filters: Stripped out negative quantities (returns/cancellations) and zero-priced transactions.
* Parsing & Encoding: Resolved file encoding errors to ensure seamless DataFrame imports.

### 2. Netflix Titles Dataset
* Column Alignment: Corrected structural shifting errors where rating values leaked into duration fields.
* Categorical Handling: Imputed missing values for director, cast, and country metadata.
* Data Formatting: Parsed dates into standardized datetime structures and split duration fields into numeric runtime values (minutes/seasons).

---

## 📊 Exploratory Data Analysis & Visualizations

### 1. E-Commerce Insights
* Revenue Drivers: Analyzed seasonal purchasing trends to uncover peak revenue periods in Q4 (November demand spike).
* Geographic Distribution: Visualized country-by-country sales volume, highlighting high Average Order Value (AOV) opportunities in international markets like the Netherlands and Australia.

### 2. Netflix Catalog Trends
* Content Mix: Visualized the platform ratio between Movies (~70%) and TV Shows.
* Growth Trajectory: Analyzed historical release date distributions showing content expansion trends peaking around 2019.
* Geographic Production Hubs: Identified top content-producing countries led by the US, India, and the UK.

---

## 📁 Files in This Repository
* Netflix Dataset.ipynb - Jupyter notebook containing cleaning, EDA, and visualizations for the Netflix dataset.
* OnlineRetail.ipynb - Jupyter notebook containing cleaning, transactional analysis, and visualizations for the Online Retail dataset.

---

# AnalystLab — Week 3: SQL Analytics & Business Problem Solving

## 📌 Project Overview

This repository contains SQL scripts and documentation completed for Week 3. The project focuses on relational database management, advanced SQL querying, business problem-solving, and query optimization inside MySQL Workbench across the Chinook and Sales datasets.


## 🛠️ Tools Used

* SQL Database & Client: MySQL / MySQL Workbench
* Deliverables: SQL Script Files (.sql), Queries & Insights Documentation (.pdf)


## 🔗 Deliverables & Dataset Access

* 📁 [Access Project SQL Files & Reports in Repository](https://github.com/elizabethcomiwa123-del/AnalystLab_Internship_Tasks)


## 🧹 Task Breakdown & Implementation

### 1. Database Setup
* Schema & Constraints: Imported datasets into MySQL Workbench and evaluated schema relationships including primary keys, foreign keys, and table constraints.

### 2. Core SQL Queries
* Basic Data Selection & Filtering: Constructed foundational retrieval scripts using SELECT, WHERE, and ORDER BY.
* Aggregations & Grouping: Performed metric summaries using SUM(), AVG(), and COUNT() combined with GROUP BY and conditional HAVING filters.

### 3. Advanced SQL Concepts
* Relational Joins: Merged relational tables using INNER JOIN, LEFT JOIN, and RIGHT JOIN structures in MySQL.
* Subqueries & CTEs: Structured multi-level queries and Common Table Expressions to isolate complex data subsets.
* Window Functions: Applied ranking analytics using ROW_NUMBER(), RANK(), and DENSE_RANK() OVER (PARTITION BY...).

### 4. Business Problem Solving
* Top-Performing Entities: Identified top customers by lifetime value and best-selling product categories ($1M+ in sales).
* Revenue Trends: Tracked multi-year sales performance and annual billing trends.
* Purchasing Behavior & Supply Chain: Analyzed customer order volume distributions and order fulfillment statuses.

### 5. Query Optimization
* Performance Tuning: Applied database indexing strategies on primary/foreign key join paths to reduce latency.
* Clean Code Standards: Formatted clean, readable SQL scripts using standard uppercase syntax and logical layout structure.


## 📊 Key Insights & Business Findings

### 🎵 1. Chinook Music Store Dataset
* Catalog Dominance & Inventory Reliance: Genre ID 1 (Rock) heavily dominates the store catalog with 1,297 tracks, indicating high inventory reliance on rock music.
* Top Individual Composers: Steve Harris is the highest-volume individual composer with 80 tracks registered in the database.
* Album Length Leaders: Album ID 141 (Greatest Hits) stands out as the longest compilation, comprising 57 tracks and totaling 251.10 album minutes (over 4 hours of playtime).
* Geographic Revenue Drivers: The USA represents the primary market with 91 total invoices and 13 registered customers, followed by Canada (56 invoices) and France (35 invoices).
* Top Customer Lifetime Value: Customer ID #6 (Helena Holý) generated the highest overall spend across the platform.

#### 💡 Strategic Takeaways:
1. Catalog Diversification: While Rock provides a strong baseline, promotional campaigns should target secondary genres to balance single-genre reliance.
2. Featured Promotions: Highlight long-form compilations (*Greatest Hits*) and top composer catalogs in store features to boost engagement.
3. Market Expansion: Focus customer retention campaigns in primary geographic regions (USA, Canada, and France).

### 📦 2. Global Sales Dataset
* Million-Dollar Categories: Vehicle product lines drive core business revenue, led by Classic Cars and Vintage Cars, both surpassing $1,000,000+ in sales.
* High-Value US Orders: The single highest transaction retrieved for US customers was Order #10407 placed by The Sharp Gifts Warehouse, totaling $14,082.80.
* Supply Chain Operations: 286 orders were successfully shipped out of total order transactions.


## 📁 Files in This Repository
* `chinook_quering.sql` - MySQL query script for database setup, core queries, and joins on the Chinook database.
* `SALES DATA QUERYING.sql` - MySQL query script covering window functions, ranking, and business problem solving on the Sales dataset.
* `Week3_SQL_Queries_and_Insights.doc`- Technical document explaining query logic, optimization steps, and business takeaways.


---
