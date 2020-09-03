CREATE TABLE brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL, 
    [brand_description] VARCHAR(50) NULL, 
    [test_column] VARCHAR(50) NULL, 
    [anotherColumn] NVARCHAR(50) NULL
);