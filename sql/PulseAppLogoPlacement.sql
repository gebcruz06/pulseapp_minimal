-- Create the table
CREATE TABLE PulseAppLogoPlacement (
    LogoPlacementID INT,
    LogoPlacementName VARCHAR(255) NOT NULL,
    Created DATETIME NOT NULL,
    CreatedBy VARCHAR(255) NOT NULL,
    Updated DATETIME NOT NULL,
    UpdatedBy VARCHAR(255) NOT NULL
);

-- Insert the data
INSERT INTO PulseAppLogoPlacement (LogoPlacementID, LogoPlacementName, Created, CreatedBy, Updated, UpdatedBy)
VALUES
    (1, 'Bottom, Right', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (2, 'Bottom, Center', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (3, 'Bottom, Left', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (4, 'Top, Right', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (5, 'Top, Center', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (6, 'Top, Left', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (7, 'Center, Right', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (8, 'Center', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App'),
    (9, 'Center, Left', '2024-07-22 10:59', 'Pulse App', '2024-07-22 10:59', 'Pulse App');

select * from PulseAppLogoPlacement