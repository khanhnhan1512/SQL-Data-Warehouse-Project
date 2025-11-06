# Data Warehouse and Analytics Project

This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](images/architecture.svg)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **EDA (Exploratory Data Analysis)**: Conducting EDA to uncover insights and trends in sales data.
---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.

### Exploratory Data Analysis (Data Analytics)
#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- `Customer Behavior`
- `Product Performance`
- `Sales Trends`

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

## 📂 Repository Structure
```
├── 📁 datasets                         # Raw datasets used for the project
│   ├── 📁 source_crm
│   │   ├── 📄 cust_info.csv
│   │   ├── 📄 prd_info.csv
│   │   └── 📄 sales_details.csv
│   └── 📁 source_erp
│       ├── 📄 CUST_AZ12.csv
│       ├── 📄 LOC_A101.csv
│       └── 📄 PX_CAT_G1V2.csv
├── 📁 docs                             # Project documentation files
│   └── 📝 data_catalog_gold.md
├── 📁 images                           # Diagrams and Architecture
│   ├── 📄 architecture.drawio
│   ├── 🖼️ architecture.svg
│   ├── 📄 data_flow.drawio
│   ├── 🖼️ data_flow.svg
│   ├── 📄 relation_tables.drawio
│   ├── 🖼️ relation_tables.svg
│   ├── 📄 start_schema.drawio
│   └── 🖼️ start_schema.svg
├── 📁 scripts                          # SQL scripts for ETL and transformations
│   ├── 📁 bronze                       # Scripts for extracting and loading raw data
│   │   ├── 📄 create_tables.sql
│   │   └── 📄 load_bronze_proc.sql
│   ├── 📁 gold                         # Scripts for creating analytical models
│   │   └── 📄 create_dim_fact_tables.sql
│   ├── 📁 silver                       # Scripts for cleaning and transforming data
│   │   ├── 📄 create_tables.sql
│   │   └── 📄 load_silver_proc.sql
│   ├── 📄 init_database.sql
│   └── 📄 run_proc.sql
├── 📁 tests                            # Data quality and validation scripts    
│   ├── 📄 check_quality_gold.sql
│   └── 📄 check_quality_silver.sql
└── 📝 README.md
```
## 🌟 About Me
Feel free to connect with me on the following platforms:

[![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/nguyen.khanh.nhan.905779)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/nhan-nguyen-b22023260/)