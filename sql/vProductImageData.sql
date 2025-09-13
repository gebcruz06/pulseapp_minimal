USE [apidev]
GO

/****** Object:  View [dbo].[vPulseAppProductImageData]    Script Date: 19/08/2024 8:46:05 am ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vPulseAppProductImageData] as 
SELECT
	pir.[ImageID]
	,pir.[ImageIdentifier]
	,pir.[ImageName]
	,pir.[ImageType]
	,pir.[FileSize]
	,pir.[Width]
	,pir.[Height]
	,pir.[LocationRaw]
	,pir.[CreatedBy]
	,pir.[CreatedDate]
	,pip.[BrandID]
	,mb.[BrandName]
	,mb.[Tag]
	,pip.[ProductID]
	,pip.[LogoID]
	,l.[LogoName]
	,l.[LogoLocation]
	,pip.[LogoPlacementID]
	,lp.[LogoPlacementName]
	,pip.[MarketID]
	,mb.[CountryISO2] as [MarketName]
	,mb.[CatalogName]
	,pip.[ProductImageNo]
	,pip.[ProcessedFlag]
	,pip.[ProductImageName]
	,pip.[LocationProcessed]
	,pip.[PartsLaneOwnedFlag]
	,pip.[ProcessedBy]
	,pip.[ProcessedDate]
FROM [apidev].[dbo].[PulseAppImageRaw] as pir
  
left join [apidev].[dbo].[PulseAppImageProcessed] as pip
on pir.ImageID = pip.ImageID
  
left join [apidev].[dbo].[PulseAppLogo] as l
on pip.LogoID = l.LogoID
  
left join [apidev].[dbo].[PulseAppLogoPlacement] as lp
on pip.LogoPlacementID = lp.LogoPlacementID

left join [apidev].[dbo].[vPulseAppMarketBrand] mb
on pip.BrandID = mb.BrandID
and pip.MarketID = mb.MarketID
GO


