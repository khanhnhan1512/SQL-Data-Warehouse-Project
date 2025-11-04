CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_all DATETIME, @end_time_all DATETIME;
	BEGIN TRY
		PRINT '=================================================';
		PRINT 'Loading silver Layer';
		PRINT '=================================================';

		PRINT '-------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------------------------';
		SET @start_time = GETDATE();
		SET @start_time_all = GETDATE();
		TRUNCATE TABLE silver.crm_cust_info;

		INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_material_status, cst_gender, cst_create_date)
		SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS first_name,
		TRIM(cst_lastname) AS last_name,
		CASE UPPER(TRIM(cst_material_status)) 
				WHEN 'S' THEN 'Single' 
				WHEN 'M' THEN 'Married' 
				ELSE 'n/a' 
				END AS cst_material_status,
		CASE UPPER(TRIM(cst_gender)) 
				WHEN 'F' THEN 'Female' 
				WHEN 'M' THEN 'Male' 
				ELSE 'n/a' 
				END AS cst_gender,
		cst_create_date
		FROM (
			SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS latest_date
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		) t
		WHERE latest_date = 1;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.crm_prd_info;

		INSERT INTO silver.crm_prd_info (prd_id, cate_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_date, prd_end_date)
		SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cate_id,
		SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
		prd_nm,
		COALESCE(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line)) 
				WHEN 'R' THEN 'Road' 
				WHEN 'M' THEN 'Mountain' 
				WHEN 'S' THEN 'Other sales' 
				WHEN 'T' THEN 'Touring' 
				ELSE 'n/a' 
				END AS prd_line,
		CAST(prd_start_date AS DATE) AS prd_start_date,
		LEAD(prd_start_date) OVER(PARTITION BY prd_key ORDER BY prd_start_date) - 1 AS prd_end_date
		FROM bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.crm_sales_details;

		INSERT INTO silver.crm_sales_details(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
		SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE 
			WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE)
		END AS sls_order_dt,
		CASE 
			WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_ship_dt AS NVARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE 
			WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_due_dt AS NVARCHAR) AS DATE)
		END AS sls_due_dt,
		CASE 
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,
		sls_quantity,
		CASE 
			WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_price
		FROM bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		PRINT '-------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-------------------------------------------------';
		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_cust_az12;

		INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
		SELECT 
		CASE
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid) - 3)
			ELSE cid
		END AS cid,
		CASE 
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END AS bdate,
		CASE
			WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			ELSE 'n/a'
		END AS gen
		FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_loc_a101;

		INSERT INTO silver.erp_loc_a101 (cid, cntry)
		SELECT 
		REPLACE(cid, '-', '') AS cid,
		CASE
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
		END AS cntry
		FROM bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';
		
		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_px_cat_g1v2;

		INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
		SELECT 
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		SET @end_time_all = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		PRINT '>> TOTAL TIME: ' + CAST(DATEDIFF(second, @start_time_all, @end_time_all) AS NVARCHAR) + ' s';
	END TRY
	BEGIN CATCH
		PRINT '===========================================';
		PRINT 'ERROR OCCURED DURING LOADING silver LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE()
		PRINT '===========================================';
	END CATCH
END