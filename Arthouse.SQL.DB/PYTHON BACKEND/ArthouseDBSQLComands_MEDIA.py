###############################################
# Note: we store the paths and generate urls.
# I should change the names in the database,
# but I'm lazy and need to do my calculus. GL!
#                          - Jacob
###############################################
###############################################################
#   Note, remember to upload FIRST. If upload is successful,
#   then update the sql database.
#   Failure to do so will get us clapped.
###############################################################

#perform CRUD operations on media data in the database (create, read, update, delete)

import os

from queryHelper import run_cud_query, run_read_multiple, run_read_single
import ArthouseGoogleCloudInterface as agci
import MediaManager

################################################################################################
# MEDIA
################################################################################################
bucket_name = "arthouse-media-bucket-storage"

# ----------------------
# CREATE   
# ----------------------

def create_media(post_id, file_path, media_type):
    file_name = os.path.basename(file_path)
    extension_name = (os.path.splitext(file_name))[1][1:]
    file_to_upload = [file_path]
    
    try:
        agci.upload_via_signed_url(bucket_name, file_to_upload, media_type)
    except Exception as e:
        print(f"Upload to google cloud server : {e}")
    try:
        query = """
            INSERT INTO media (post_id, file_name, extension_name, media_type)
            VALUES (%s, %s, %s, %s)
        """
        media_id = run_cud_query(query, (post_id, file_name, extension_name, media_type))

        if media_type == 'photo':
            resolution = MediaManager.get_photo_metadata(file_path)
            # Insert into `photo` table using media_id + resolution
            create_photo(media_id, resolution)
        elif media_type == 'video':
            duration, resolution = MediaManager.get_video_metadata(file_path)
            # Insert into `video` table using media_id, duration, resolution
            create_video(media_id, duration, resolution)
        elif media_type == 'audio':
            duration, bitrate = MediaManager.get_audio_metadata(repr(file_path))
            # Insert into `audio` table using media_id, duration, bitrate
            create_audio(media_id, duration, bitrate)
        
        print(f"Added {file_name} to the media and {media_type} database")
    except Exception as e:
        print(f"Media failed to be upload and/or be uploaded into the database. [create_media()] : {e}")
        return False
    return True

#   post_id = int, file_paths = {"file_path" : "media type"...}
def create_medias(post_id, file_paths):
    for file_path, media_type in file_paths.items():
        file_name = os.path.basename(file_path)
        extension_name = (os.path.splitext(file_name))[1][1:]
        file_to_upload = [file_path]
        
        try:
            agci.upload_via_signed_url(bucket_name, file_to_upload, media_type)
        except Exception as e:
            print(f"Upload to google cloud server : {e}")
            continue
        try:
            query = """
                INSERT INTO media (post_id, file_name, extension_name, media_type)
                VALUES (%s, %s, %s, %s)
            """
            media_id = run_cud_query(query, (post_id, file_name, extension_name, media_type))

            if media_type == 'photo':
                resolution = MediaManager.get_photo_metadata(file_path)
                # Insert into `photo` table using media_id + resolution
                create_photo(media_id, resolution)
            elif media_type == 'video':
                duration, resolution = MediaManager.get_video_metadata(file_path)
                # Insert into `video` table using media_id, duration, resolution
                create_video(media_id, duration, resolution)
            elif media_type == 'audio':
                duration, bitrate = MediaManager.get_audio_metadata(repr(file_path))
                # Insert into `audio` table using media_id, duration, bitrate
                create_audio(media_id, duration, bitrate)
            
            print(f"Added {file_name} to the media and {media_type} database")
        except Exception as e:
            print(f"Media failed to be upload and/or be uploaded into the database. [create_media()] : {e}")
            return False
    return True

# ----------------------
# READ
# ----------------------

def get_media_by_post(post_id):
    try:
        query = "SELECT * FROM media WHERE post_id = %s"
        return run_read_multiple(query, (post_id,))
    except Exception as e:
        print(f"Could not get media: {e}")
        return None

def get_media_by_id(media_id):
    try:
        query = "SELECT * FROM media WHERE media_id = %s"
        return run_read_single(query, (media_id,))
    except Exception as e:
        print(f"Could not get media: {e}")
        return None
    
def get_media_url_by_media_ids(media_ids):
    url = []
    for id in media_ids:
        try:
            media_type = get_media_by_id(id)[3]
            file_name = get_media_by_id(id)[1]
            url = url + agci.view_via_signed_url(bucket_name, [file_name], media_type)
        except Exception as e:
            print(f"Could not retrieve url [get_media_url_by_media_id()] : {e}")
            url = url + None
    return url

def get_media_url_by_media_id(media_id):
    url = ""
    try:
        media_type = get_media_by_id(media_id)[3]
        file_name = get_media_by_id(media_id)[1]
        url = agci.view_via_signed_url(bucket_name, [file_name], media_type)
    except Exception as e:
        print(f"Could not retrieve url [get_media_url_by_media_id()] : {e}")
    return url   

# ----------------------
# UPDATE 
# ----------------------

# Do not want to update media, only create, delete, or read.

# ----------------------
# DELETE
# ----------------------

def delete_media(media_id):
    try:
        #generate deletion then delete from table
        media_type = get_media_by_id(media_id)[3]
        file_name = get_media_by_id(media_id)[1]
        if agci.delete_via_signed_url(bucket_name, [file_name], media_type):
            query = "DELETE FROM media WHERE media_id = %s"
            run_cud_query(query, (media_id,))
        else:
            raise f"deletion unsuccessful of \"{file_name}\"."
    except Exception as e:
        print(f"Failed to delete media ID: \"{media_id}\" : {e}")
        return False
    return True



################################################################################################
# PHOTO
################################################################################################


# ----------------------
# CREATE   
# ----------------------

def create_photo(media_id, resolution):
    try:
        query = "INSERT INTO photo (media_id, resolution) VALUES (%s, %s)"
        run_cud_query(query, (media_id, resolution))
        return True
    except Exception as e:
        print(f"[create_photo] Error: {e}")
        return False

# ----------------------
# READ 
# ----------------------

def get_photo(media_id):
    try:
        query = "SELECT * FROM photo WHERE media_id = %s"
        return run_read_single(query, (media_id,))
    except Exception as e:
        print(f"[get_photo] Error: {e}")
        return None

# ----------------------
# UPDATE
# ----------------------

# cant update a photo; must reupload photo

# ----------------------
# DELETE
# ----------------------

# Don't need, deleted with media's delete function

################################################################################################
# VIDEO
################################################################################################


# ----------------------
# CREATE   
# ----------------------

def create_video(media_id, duration, resolution):
    try:
        query = "INSERT INTO video (media_id, duration_seconds, resolution) VALUES (%s, %s, %s)"
        run_cud_query(query, (media_id, duration, resolution))
        return True
    except Exception as e:
        print(f"[create_video] Error: {e}")
        return False

# ----------------------
# READ 
# ----------------------

def get_video(media_id):
    try:
        query = "SELECT * FROM video WHERE media_id = %s"
        return run_read_single(query, (media_id,))
    except Exception as e:
        print(f"[get_video] Error: {e}")
        return None

# ----------------------
# UPDATE
# ----------------------

# Can't update video; must reupload video

# ----------------------
# DELETE
# ----------------------

# Don't need, deleted with media's delete function

################################################################################################
# AUDIO
################################################################################################


# ----------------------
# CREATE   
# ----------------------

def create_audio(media_id, duration, bitrate):
    try:
        query = "INSERT INTO audio (media_id, duration_seconds, bitrate) VALUES (%s, %s, %s)"
        run_cud_query(query, (media_id, duration, bitrate))
        return True
    except Exception as e:
        print(f"[create_audio] Error: {e}")
        return False

# ----------------------
# READ
# ----------------------

def get_audio(media_id):
    try:
        query = "SELECT * FROM audio WHERE media_id = %s"
        return run_read_single(query, (media_id,))
    except Exception as e:
        print(f"[get_audio] Error: {e}")
        return None

# ----------------------
# UPDATE
# ----------------------

# Can't update audio, must reupload audio

# ----------------------
# DELETE
# ----------------------

# Don't need, deleted with media's delete function


#create_medias(13, {r"C:\Users\jcngu\OneDrive\Pictures\MEMORY FOLDER\HanhBalboaDate\JPGs\IMG_1294.jpg" : "photo"})
#create_medias(13, {r"C:\Users\jcngu\OneDrive\Pictures\MEMORY FOLDER\Videos\sunset.mp4" : "video", 
#                  r"C:\Users\jcngu\OneDrive\Pictures\MEMORY FOLDER\HanhBalboaDate\JPGs\IMG_1294.jpg" : "photo"})

#create_media(13, r"C:\Users\jcngu\OneDrive\Pictures\MEMORY FOLDER\Videos\sunset.mp4", "video")
#print(get_media_url_by_media_ids([28, 8]))
#print(get_media_url_by_media_id(8))
#delete_media(8)

#file_to_upload = [r""+r"/mnt/c/Users/jcngu/OneDrive/Pictures/MEMORY FOLDER/HanhBalboaDate/JPGs/IMG_1294.jpg"]
#print(file_to_upload)