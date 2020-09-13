﻿CREATE TABLE brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL, 
    [brand_description] VARCHAR(50) NULL, 
    [test_column] VARCHAR(50) NULL, 
    [anotherColumn] VARCHAR(50) NULL, 
    [date_created] DATETIME NULL, 
    [testColumn] VARCHAR(50) NULL,
    [testAnotherColumn] VARCHAR(50) NULL
);
