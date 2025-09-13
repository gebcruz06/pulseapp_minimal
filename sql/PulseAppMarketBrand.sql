drop table if exists apidev.dbo.PulseAppMarketBrand

CREATE TABLE apidev.dbo.PulseAppMarketBrand (
    MarketID INT,
	CountryID INT,
    BrandID INT,
	CatalogName nvarchar(50)
);

INSERT INTO apidev.dbo.PulseAppMarketBrand (MarketID, CountryID, BrandID, CatalogName)
VALUES 
    (1, 254, 1, 'masterProductCatalog'),
    (2, 333, 4, 'hkProductCatalog'),
    (3, 434, 4, 'sgProductCatalog'),
	(4, 254, 11,'masterProductCatalog');
