import os
import mimetypes
from datetime import datetime
from PIL import Image

def ingest_raw_images(conn, container_client, base_url, input_folder, created_by):
    cursor = conn.cursor()

    cursor.execute("SELECT MAX([ImageID]) FROM [dbo].[PulseAppImageRaw]")
    row = cursor.fetchone()
    starting_image_id = row[0] + 1 if row[0] is not None else 1

    records = []
    upload_queue = []
    created_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]

    image_id = starting_image_id
    for file_name in os.listdir(input_folder):
        file_path = os.path.join(input_folder, file_name)

        if os.path.isfile(file_path):
            file_size = os.path.getsize(file_path)

            mime_type, _ = mimetypes.guess_type(file_path)
            if mime_type is None:
                mime_type = "application/octet-stream"

            width, height = None, None
            try:
                with Image.open(file_path) as img:
                    width, height = img.size
            except Exception:
                pass

            image_identifier = f"{image_id}-{file_name}"
            blob_path = f"01_Raw/{image_identifier}"
            location_raw = base_url + blob_path

            upload_queue.append((file_path, blob_path))

            records.append((
                image_id,
                image_identifier,
                file_name,
                mime_type,
                file_size,
                width,
                height,
                location_raw,
                created_by,
                created_date
            ))

            image_id += 1
            print(f"Ingested {file_name}")

    insert_query = """
    INSERT INTO [dbo].[PulseAppImageRaw] 
    (ImageID, ImageIdentifier, ImageName, ImageType, FileSize, Width, Height, LocationRaw, CreatedBy, CreatedDate)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """
    cursor.executemany(insert_query, records)
    conn.commit()

    # Upload to blob
    for file_path, blob_path in upload_queue:
        blob_client = container_client.get_blob_client(blob_path)
        with open(file_path, "rb") as data:
            blob_client.upload_blob(data, overwrite=True)

    cursor.close()
    print(f"Inserted and uploaded {len(records)} raw images.")
