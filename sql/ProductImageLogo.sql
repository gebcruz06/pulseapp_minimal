CREATE TABLE apidev.dbo.PulseAppImageLogo (
    LogoID INT,
    LogoName NVARCHAR(100),
    LogoDescription NVARCHAR(255),
    LogoLocation NVARCHAR(255),
    Created DATETIME,
    Createdby NVARCHAR(100),
    Updated DATETIME,
    UpdatedBy NVARCHAR(100)
);


INSERT INTO apidev.dbo.PulseAppImageLogo (
    LogoID, 
    LogoName, 
    LogoDescription, 
    LogoLocation, 
    Created, 
    Createdby, 
    Updated, 
    UpdatedBy
)
VALUES 
    (0, 'No logo', 'No logo', NULL, '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (1, 'ImageEditBG.png', 'Parts Lane transparent background', 'https://azaueausadevdpp02.blob.core.windows.net/product-images/PulseAppImageWindowBG/ImageEditBG.png', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App');

select * from
apidev.dbo.PulseAppImageLogo