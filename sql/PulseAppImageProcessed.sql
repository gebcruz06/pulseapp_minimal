drop table [apidev].[dbo].[PulseAppImageProcessed]

select *
into [apidev].[dbo].[PulseAppImageProcessed]
from(
SELECT [ImageID]
    ,4 as 'BrandID'
	,[ProductID]
	,1 as [LogoID]
	,1 as [LogoPlacementID]
	,2 as [MarketID]
	,[ProductImageNo]
    ,[ProcessedFlag]
    ,[ProductImageName]
	,concat('https://azaueausadevdpp02.blob.core.windows.net/product-images/02_Processed/Toyota/', [ImageName]) as LocationProcessed    
    ,1 as PartsLaneOwnedFlag
	,'PulseApp' as [ProcessedBy]
    ,[ProcessedDate]
FROM [apidev].[dbo].[ProductImageData]
where left([ImageName], 3) = 'TOY'

UNION ALL

SELECT [ImageID]
    ,1 as 'BrandID'
	,[ProductID]
	,1 as [LogoID]
	,1 as [LogoPlacementID]
	,1 as [MarketID]
	,[ProductImageNo]
    ,[ProcessedFlag]
    ,[ProductImageName]
	,concat('https://azaueausadevdpp02.blob.core.windows.net/product-images/02_Processed/Subaru/', [ImageName]) as LocationProcessed  
	,1 as PartsLaneOwnedFlag  
    ,'PulseApp' as [ProcessedBy]
    ,[ProcessedDate]
FROM [apidev].[dbo].[ProductImageData]
where left([ImageName], 3) = 'SUB'
) a

select * from [apidev].[dbo].[PulseAppImageProcessed]