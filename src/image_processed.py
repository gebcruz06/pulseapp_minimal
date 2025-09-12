from datetime import datetime

def get_market_info(cursor, market_id):
    query = """
        SELECT
            a.[MarketID],
            a.[CountryID],
            c.ISO2 as CountryName,
            a.[BrandID],
            b.Tag,
            b.BrandName,
            a.[CatalogName]
        FROM [apidev].[dbo].[PulseAppMarketBrand] a
        LEFT JOIN prod.dbo.Country c ON a.CountryID = c.CountryID
        LEFT JOIN prod.dbo.Brand b   ON a.BrandID = b.BrandID
        WHERE a.MarketID = ?
    """
    cursor.execute(query, (market_id,))
    row = cursor.fetchone()
    if row:
        market_id, country_id, countryname, brandid, tag, brandname, catalogname = row
        return {
            "MarketID": market_id,
            "CountryID": country_id,
            "CountryName": countryname,
            "BrandID": brandid,
            "Tag": tag,
            "BrandName": brandname,
            "CatalogName": catalogname
        }
    return None

def get_unprocessed_images(cursor):
    query = """
        SELECT 
            ImageID,
            CASE
                WHEN CHARINDEX('_', ImageName) > 0 THEN LEFT(ImageName, CHARINDEX('_', ImageName)-1)
                WHEN CHARINDEX('~', ImageName) > 0 THEN LEFT(ImageName, CHARINDEX('~', ImageName)-1)
                WHEN CHARINDEX('-', ImageName) > 0 THEN LEFT(ImageName, CHARINDEX('-', ImageName)-1)
                WHEN CHARINDEX('.', ImageName) > 0 THEN LEFT(ImageName, CHARINDEX('.', ImageName)-1)
            END AS ProductID,
            LocationRaw
        FROM [apidev].[dbo].[PulseAppImageRaw]
        WHERE ImageID NOT IN (SELECT ImageID FROM [apidev].[dbo].[PulseAppImageProcessed])
    """
    cursor.execute(query)
    return cursor.fetchall()

def get_next_product_image_no(cursor, product_id):
    query = """
        SELECT ISNULL(MAX(ProductImageNo), 0) 
        FROM [apidev].[dbo].[PulseAppImageProcessed]
        WHERE ProductID = ?
    """
    cursor.execute(query, product_id)
    max_no = cursor.fetchone()[0]
    return str(max_no + 1).zfill(3)

def insert_processed_image(cursor, processed_image):
    query = """
        INSERT INTO [apidev].[dbo].[PulseAppImageProcessed] (
            ImageID,
            BrandID,
            ProductID,
            LogoID,
            LogoPlacementID,
            MarketID,
            ProductImageNo,
            ProcessedFlag,
            ProductImageName,
            LocationProcessed,
            PartsLaneOwnedFlag,
            ProcessedBy,
            ProcessedDate
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """
    cursor.execute(query, (
        processed_image["ImageID"],
        processed_image["BrandID"],
        processed_image["ProductID"],
        processed_image["LogoID"],
        processed_image["LogoPlacementID"],
        processed_image["MarketID"],
        processed_image["ProductImageNo"],
        processed_image["ProcessedFlag"],
        processed_image["ProductImageName"],
        processed_image["LocationProcessed"],
        processed_image["PartsLaneOwnedFlag"],
        processed_image["ProcessedBy"],
        processed_image["ProcessedDate"]
    ))

def process_images(conn, container_client, market_id):
    cursor = conn.cursor()

    market = get_market_info(cursor, market_id)
    if not market:
        print(f"MarketID {market_id} not found.")
        return

    brandid = market["BrandID"]
    tag = market["Tag"]
    brandname = market["BrandName"]
    catalogname = market["CatalogName"]

    images = get_unprocessed_images(cursor)
    batch_copy = []

    for row in images:
        image_id, product_id, location_raw = row
        product_image_no = get_next_product_image_no(cursor, product_id)

        product_image_name = f"{tag}{product_id}-{product_image_no}-{catalogname}.png"
        location_processed = (
            f"https://azaueausadevdpp02.blob.core.windows.net/product-images/02_Processed/{brandname}/{product_image_name}"
        )

        processed_image = {
            "ImageID": image_id,
            "BrandID": brandid,
            "ProductID": product_id,
            "LogoID": 0,
            "LogoPlacementID": 0,
            "MarketID": market_id,
            "ProductImageNo": product_image_no,
            "ProcessedFlag": 1,
            "ProductImageName": product_image_name,
            "LocationProcessed": location_processed,
            "PartsLaneOwnedFlag": 0,
            "ProcessedBy": "PulseApp",
            "ProcessedDate": datetime.now()
        }

        insert_processed_image(cursor, processed_image)
        batch_copy.append((location_raw, f"02_Processed/{brandname}/{product_image_name}"))
        print(f"Processed {product_image_name}")

    for src_url, dest_path in batch_copy:
        dest_blob = container_client.get_blob_client(dest_path)
        dest_blob.start_copy_from_url(src_url)

    conn.commit()
    cursor.close()
    print("All unprocessed images inserted and copied.")
