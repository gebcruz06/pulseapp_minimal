SELECT distinct
	pid.[ImageID]
	,pid.[ImageIdentifier]
	,pid.[ImageName]
	,pid.[ImageType]
	,pid.[FileSize]
	,pid.[Width]
	,pid.[Height]
	,pid.[LocationRaw]
	,pid.[CreatedBy] as ImageCreatedBy
	,pid.[CreatedDate] as ImageCreatedDate
	,pid.[BrandID]
	,pid.[BrandName]
	,pid.[Tag]
	,pid.[ProductID]
	,pid.[LogoID]
	,pid.[LogoName]
	,pid.[LogoLocation]
	,pid.[LogoPlacementID]
	,pid.[LogoPlacementName]
	,pid.[MarketID]
	,pid.[MarketName]
	,pid.[CatalogName]
	,pid.[ProductImageNo]
	,pid.[ProcessedFlag]
	,pid.[ProductImageName]
	,pid.[LocationProcessed]
	,(case when pid.[LogoID] = 1 then 1
	else 0
	end) as PartsLaneOwnedFlag
	,(case when pc.[PartNo] is not null then 1
	else 0
	end) as ProductionApprovedFlag
	,pid.[ProcessedBy] as ImageProcessedBy
	,pid.[ProcessedDate] as ImageProcessedDate
	,(case when css.CCV2PartNo is not null then 1
	else 0
	end) as CCV2StagedS2
	,css.[creationtime] as CCV2StagedS2Date
	,(case when cps.CCV2PartNo is not null then 1
	else 0
	end) as CCV2OnlineS2
	,cps.[creationtime] as CCV2OnlineS2Date

	,(case when cs.CCV2PartNo is not null then 1
	else 0
	end) as CCV2StagedP1
	,cs.[creationtime] as CCV2StagedP1Date
	,(case when cp.CCV2PartNo is not null then 1
	else 0
	end) as CCV2OnlineP1
	,cp.[creationtime] as CCV2OnlineP1Date
	,'PulseApp Pipeline' as Createdby
	,getdate() as CreatedDate
	,'PulseApp Pipeline' as Updatedby
	,getdate() as UpdatedDate

into prod.dbo.[ProductImage]
FROM [apidev].[dbo].[vPulseAppProductImageData] as pid
	
	left join [auto].[dbo].[vCCV2MediaContainerStagedP1] as cs
	on concat(pid.Tag, pid.ProductID) = cs.CCV2PartNo
	and pid.CatalogName = cs.catalogversion
	and pid.ProductImageNo = cs.ProductImageNo

	left join [auto].[dbo].[vCCV2MediaContainerProductionP1] as cp
	on concat(pid.Tag, pid.ProductID) = cp.CCV2PartNo
	and pid.CatalogName = cp.catalogversion
	and pid.ProductImageNo = cp.ProductImageNo

	left join [auto].[dbo].[vCCV2MediaContainerStagedS2] as css
	on concat(pid.Tag, pid.ProductID) = css.CCV2PartNo
	and pid.CatalogName = css.catalogversion
	and pid.ProductImageNo = css.ProductImageNo

	left join [auto].[dbo].[vCCV2MediaContainerProductionS2] as cps
	on concat(pid.Tag, pid.ProductID) = cps.CCV2PartNo
	and pid.CatalogName = cps.catalogversion
	and pid.ProductImageNo = cps.ProductImageNo

	left JOIN (
			select distinct
				p.productno as PartNo
			FROM 
				[prod].[dbo].[Product] p
				left join [prod].[dbo].[ProductCountry] pc
				on p.productid = pc.ProductID
			where
				pc.productionapproved = 1
			) pc
		on pid.ProductID = pc.PartNo

order by imageid asc


--select * from [apidev].[dbo].[vPulseAppProductImageData]