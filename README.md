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
