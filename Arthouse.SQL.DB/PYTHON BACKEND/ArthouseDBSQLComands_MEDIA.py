###############################################
# Note: we store the paths and generate urls.
# I should change the names in the database,
# but I'm lazy and need to do my calculus. GL!
#                          - Jacob
###############################################

#perform CRUD operations on media data in the database (create, read, update, delete)

from queryHelper import run_cud_query, run_read_multiple, run_read_single


################################################################################################
# MEDIA
################################################################################################

# ----------------------
# CREATE   
# ----------------------

def create_media(post_id, file_name, extension_name, media_type):
    try:
        query = """
            INSERT INTO media (post_id, file_name, extension_name, media_type)
            VALUES (%s, %s, %s, %s)
        """
        run_cud_query(query, (post_id, file_name, extension_name, media_type))
        return True
    except Exception as e:
        print(f"Creation of media failed: {e}")
        return False

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

# ----------------------
# UPDATE 
# ----------------------

def update_media(media_id, file_name=None, extension_name=None, media_type=None):
    try:
        updates = []
        values = []

        if file_name:
            updates.append("file_name = %s")
            values.append(file_name)
        if extension_name:
            updates.append("extension_name = %s")
            values.append(extension_name)
        if media_type:
            updates.append("media_type = %s")
            values.append(media_type)

        if not updates:
            return False

        query = f"UPDATE media SET {', '.join(updates)} WHERE media_id = %s"
        values.append(media_id)
        run_cud_query(query, tuple(values))
        return True
    except Exception as e:
        print(f"Could not update media \"{media_id}\": {e}")
        return False

# ----------------------
# DELETE
# ----------------------

def delete_media(media_id):
    try:
        query = "DELETE FROM media WHERE media_id = %s"
        run_cud_query(query, (media_id,))
        return True
    except Exception as e:
        print(f"Failed to delete media ID:\"{media_id}\" : {e}")
        return False



################################################################################################
# PHOTO
################################################################################################


# ----------------------
# CREATE   
# ----------------------

def create_photo(media_id, width, height):
    try:
        query = "INSERT INTO photo (media_id, width, height) VALUES (%s, %s, %s)"
        run_cud_query(query, (media_id, width, height))
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
        query = "INSERT INTO video (media_id, duration, resolution) VALUES (%s, %s, %s)"
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
        query = "INSERT INTO audio (media_id, duration, bitrate) VALUES (%s, %s, %s)"
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