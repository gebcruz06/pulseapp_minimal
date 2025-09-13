CREATE TABLE apidev.dbo.PulseAppMarket (
    MarketID INT,
    MarketCountry NVARCHAR(100),
    MarketCountryISO2 CHAR(2)
);

INSERT INTO apidev.dbo.PulseAppMarket (MarketID, MarketCountry, MarketCountryISO2)
VALUES 
    (1, 'Australia', 'AU'),
    (2, 'Hong Kong', 'HK'),
    (3, 'Singapore', 'SG');
