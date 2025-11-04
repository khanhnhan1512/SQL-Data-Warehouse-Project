CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_all DATETIME, @end_time_all DATETIME;
	BEGIN TRY
		PRINT '=================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=================================================';

		PRINT '-------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------------------------';
		SET @start_time = GETDATE();
		SET @start_time_all = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		BULK INSERT bronze.crm_cust_info
		FROM 'E:\My Document\Data_Engineer_Projects\SQL-Data-Warehouse-Project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;

		BULK INSERT bronze.crm_prd_info
		FROM 'E:\My Document\Data_Engineer_Projects\SQL-Data-Warehouse-Project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details
		FROM 'E:\My Document\Data_Engineer_Projects\SQL-Data-Warehouse-Project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		PRINT '-------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-------------------------------------------------';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;

		BULK INSERT bronze.erp_cust_az12
		FROM 'E:\My Document\Data_Engineer_Projects\SQL-Data-Warehouse-Project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101;

		BULK INSERT bronze.erp_loc_a101
		FROM 'E:\My Document\Data_Engineer_Projects\SQL-Data-Warehouse-Project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';
		
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'E:\My Document\Data_Engineer_Projects\SQL-Data-Warehouse-Project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		SET @end_time_all = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------------------------------------------------';

		PRINT '>> TOTAL TIME: ' + CAST(DATEDIFF(second, @start_time_all, @end_time_all) AS NVARCHAR) + ' s';
	END TRY
	BEGIN CATCH
		PRINT '===========================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE()
		PRINT '===========================================';
	END CATCH
END