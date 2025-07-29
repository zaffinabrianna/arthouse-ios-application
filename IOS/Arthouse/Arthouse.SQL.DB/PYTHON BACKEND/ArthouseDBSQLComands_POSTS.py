#perform CRUD operations on post related items in the database (create, read, update, delete)

from queryHelper import run_cud_query, run_read_multiple, run_read_single
from ArthouseDBSQLComands_MEDIA import create_audio, delete_media, get_media_by_post, create_medias

################################################################################################
# POST
################################################################################################

# ----------------------
# CREATE        POST
# ----------------------

def create_post(username, audio_id=None, post_description="", hashtags=None):
    try:
        query = """
        INSERT INTO post (username, audio_id, post_description)
        VALUES (%s, %s, %s)
        """
        post_id = run_cud_query(query, (username, audio_id, post_description))
        # Get post_id for insertion into the hashtag table
        if post_id is None:
            raise Exception("Failed to retrieve post_id after insert.")
        
        # Insert hashtags if any
        if hashtags:
            insert_hashtag_query = "INSERT INTO hashtag (hashtag, post_id) VALUES (%s, %s)"
            for tag in hashtags:
                run_cud_query(insert_hashtag_query, (tag, post_id))
        
        return post_id
    except Exception as e:
        print(f"Failed to create post for '{username}': {e}")
        return None


def make_post_with_media(username, audio_id=None, post_description="", hashtags=None, media_list={}):
    #media_list must be a dictionary {"file_path" : "media type"...}
    try:
        returned_post_id = create_post(username, audio_id, post_description, hashtags)
        print("PostID: ", returned_post_id)
        if returned_post_id != None:
            create_medias(returned_post_id, media_list)
    except Exception as e:
        print(f"Failed to create post and upload media [make_post_with_media()]: {e}")
        return False



# ----------------------
# READ (All / By username)  POST
# ----------------------

# selects only 5 posts at a time from ALL posts
#increment offset by 5
def get_posts_paginated(limit=5, offset=0):
    try:
        query = """
        SELECT * FROM post
        ORDER BY created_at DESC
        LIMIT %s OFFSET %s
        """
        return run_read_multiple(query, (limit, offset))
    except Exception as e:
        print(f"Failed to obtain posts: {e}")
        return None

#selects only 5 posts at a time from a specific user
#increment offset by 5
def get_user_posts_paginated(username, limit=5, offset=0):
    try:
        query = """
        SELECT * FROM post
        WHERE username = %s
        ORDER BY created_at DESC
        LIMIT %s OFFSET %s
        """
        return run_read_multiple(query, (username, limit, offset))
    except Exception as e:
        print(f"Failed to obtain posts for \"{username}\" : {e}")
        return None

#probably not useful
def get_all_posts():
    try:
        query = "SELECT * FROM post ORDER BY created_at DESC"
        return run_read_multiple(query)
    except Exception as e:
        print(f"Failed get all posts: {e}")
        return None

#Best not to use incase the user has MANY posts
def get_all_posts_of_user(username):
    try:
        query = "SELECT * FROM post WHERE username = %s ORDER BY created_at DESC"
        return run_read_multiple(query, (username,))
    except Exception as e:
        print(f"Failed to get all posts for {username}: {e}")
        return None

def get_number_of_posts(username):
    try:
        query = "SELECT COUNT(*) FROM post WHERE username = %s"
        result = run_read_single(query, (username,))
        return result[0] if result else 0
    except Exception as e:
        print(f"Failed to get number of posts for {username}: {e}")
        return None

def get_posts_containing_hashtags(list_of_hashtags):
    if not list_of_hashtags:
        return []
    try:
        placeholders = ','.join(['%s'] * len(list_of_hashtags))
        query = f"""
            SELECT DISTINCT p.*
            FROM post p
            JOIN hashtag h ON p.post_id = h.post_id
            WHERE h.hashtag IN ({placeholders})
            ORDER BY p.created_at DESC
        """
        return run_read_multiple(query, tuple(list_of_hashtags))
    except Exception as e:
        print(f"Failed to retrieve posts containing the hashtags:")
        for tag in list_of_hashtags:
            print(tag)     
        print(" : {e}")
        return None




   #################
   # ALGOS
   #################


# Home: you, your follower’s, and who you follow's post
# Fetch posts with relations to you
def home_feed_algo(username, offset=0):
    try:
        query = """
        SELECT p.*, m.media_id, m.file_name, m.extension_name, m.media_type
        FROM post p
        LEFT JOIN media m ON p.post_id = m.post_id
        WHERE p.username = %s
           OR p.username IN (
                SELECT followee FROM follower_relationships WHERE follower = %s
           )
        ORDER BY p.created_at DESC
        LIMIT 5 OFFSET %s
        """
        return run_read_multiple(query, (username, username, offset))
    except Exception as e:
        print(f"Posts failed to load [home_feed_algo()] : {e}")
        return None


# Search: recommended
# 	RECOMENDED FEED ALGO Sql query =
#      -select the posts that a user has liked 
#      -fetch the hashtags with those posts
#      -Calculate the top 3-5 most common hashtags among the posts
#      -Recommend similar posts with the similar hashtags
# NOTE: dont just recommend ONLY post with hashtags, 
#       maybe give a higher percentage to favor posts with those hashtags

def recommended_feed_algo(username):
    try:
        print(f"Running recommended feed for user: {username}")
        query = """
        WITH liked_hashtags AS (
            SELECT h.hashtag
            FROM user_liked_relationships ul
            JOIN hashtag h ON ul.post_id = h.post_id
            WHERE ul.username = %s
        ),
        top_hashtags AS (
            SELECT hashtag, COUNT(*) AS freq
            FROM liked_hashtags
            GROUP BY hashtag
            ORDER BY freq DESC
            LIMIT 5
        ),
        hashtag_posts AS (
            SELECT DISTINCT p.*, m.media_id, m.file_name, m.extension_name, m.media_type, 1 AS priority
            FROM post p
            LEFT JOIN media m ON p.post_id = m.post_id
            JOIN hashtag h ON p.post_id = h.post_id
            WHERE h.hashtag IN (SELECT hashtag FROM top_hashtags)
              AND p.username != %s
        ),
        fallback_posts AS (
            SELECT p.*, m.media_id, m.file_name, m.extension_name, m.media_type, 2 AS priority
            FROM post p
            LEFT JOIN media m ON p.post_id = m.post_id
            WHERE p.username != %s
              AND p.post_id NOT IN (SELECT post_id FROM hashtag_posts)
        ),
        combined_posts AS (
            SELECT * FROM hashtag_posts
            UNION ALL
            SELECT * FROM fallback_posts
        )
        SELECT * FROM combined_posts
        ORDER BY priority, created_at DESC
        LIMIT 10
        """
        result = run_read_multiple(query, (username, username, username))
        print(f"Got {len(result)} recommended posts.")
        return result
    except Exception as e:
        print(f"Posts failed to load [recommended_feed_algo()] : {e}")
        return None
 

# ----------------------
# UPDATE        POST
# ----------------------

def update_post(post_id, new_audio_id=None, post_description="", hashtags=None, is_private=None):
    try:
        updates = []
        values = []

        if new_audio_id is not None:
            updates.append("audio_id = %s")
            values.append(new_audio_id)
            old_audio_id = get_media_by_post(post_id)
            delete_media(old_audio_id)          # if changing the audio file, must delete the old one 
            create_audio(new_audio_id)          # and reupload

        if post_description is not None:
            updates.append("post_description = %s")
            values.append(post_description)

        if is_private is not None:
            updates.append("is_private = %s")
            values.append(is_private)

        if updates:
            query = f"UPDATE post SET {', '.join(updates)} WHERE post_id = %s"
            values.append(post_id)
            run_cud_query(query, tuple(values))

        # Handle hashtags (clear and insert new ones)
        if hashtags is not None:
            delete_query = "DELETE FROM hashtag WHERE post_id = %s"
            run_cud_query(delete_query, (post_id,))
            insert_query = "INSERT INTO hashtag (hashtag, post_id) VALUES (%s, %s)"
            for tag in hashtags:
                run_cud_query(insert_query, (tag, post_id))

        return True

    except Exception as e:
        print(f"Failed to update post {post_id}: {e}")
        return False

# ----------------------
# DELETE       POST
# ----------------------

def delete_post(post_id):
    #deletes post and everything associated with it (likes, media, etc)
    try:
        query = "DELETE FROM post WHERE post_id = %s"
        run_cud_query(query, (post_id,))
        medias = get_media_by_post(post_id=post_id)
        for id in medias:
            delete_media(id)
        return True
    except Exception as e:
        print(f"The post \"{post_id}\" failed to be deleted. Verify it exists. : {e}")
        return False


################################################################################################
# HASHTAG
################################################################################################


# ----------------------
# CREATE        hashtag
# ----------------------

# Not needed, is created when a post is created.


# ----------------------
# READ          hashtags
# ----------------------

#find all posts that are associated with the hashtags in the parameter.
def search_by_hashtags(hashtags):
    if not hashtags:
        return []
    try:
        placeholders = ','.join(['%s'] * len(hashtags))
        query = f"""
            SELECT DISTINCT p.*
            FROM post p
            JOIN hashtag h ON p.post_id = h.post_id
            WHERE h.hashtag IN ({placeholders})
            ORDER BY p.created_at DESC
        """
        return run_read_multiple(query, tuple(hashtags))
    except Exception as e:
        print(f"An error occured searching for posts containing the hashtags:")
        for tag in hashtags:
            print(tag)
        print(" : ", e)
        return None


# ----------------------
# UPDATE        HASTAG
# ----------------------

# Not needed. Updated with post

# ----------------------
# DELETE       HASHTAG
# ----------------------

# Not needed. Deletes when post dies

################################################################################################
# user_liked_relationships
################################################################################################


# ----------------------
# CREATE   
# ----------------------

#creates user and post "like" relationship
def like_post(username, post_id):
    try:
        query = "INSERT INTO user_liked_relationships (username, post_id) VALUES (%s, %s)"
        run_cud_query(query, (username, post_id))
        return True
    except Exception as e:
        print(f"Failed to like post \"{post_id}\". : {e}")
        return False

# ----------------------
# READ (All / By username) 
# ----------------------

#sees who liked a post
def get_liked_users(post_id):
    try:
        query = "SELECT user FROM user_liked_relationships WHERE post_id = %s"
        users = run_read_multiple(query, (post_id,))
        return [row[0] for row in users]
    except Exception as e:
        print(f"The users who liked post \"{post_id}\" failed to load. : {e}")
        return None

def get_users_liked_posts(username):
    try:
        query = "SELECT post_id FROM user_liked_relationships WHERE username = %s"
        users = run_read_multiple(query, (username,))
        return [row[0] for row in users]
    except Exception as e:
        print(f"\"{username}\"\'s liked posts could not be found. : {e}")
        return None


# ----------------------
# UPDATE 
# ----------------------

# no need for an update since users can either like a post or not like a post -> (create or delete(none) like-relationship) 

# ----------------------
# DELETE
# ----------------------

def unlike_post(username, post_id):
    #terminates relationship of all likes to post
    try:
        queryDelete = "DELETE FROM user_liked_relationships WHERE username = %s AND post_id = %s"
        queryUnlike = """UPDATE post
                SET like_count = GREATEST(like_count - 1, 0)
                WHERE post_id = %s"""
        run_cud_query(queryDelete, (username, post_id))
        run_cud_query(queryUnlike, (post_id,))
        return True
    except Exception as e:
        print(f"The post \"{post_id}\" failed to be unliked. Verify that \"{post_id}\" exists. : {e}")
        return False


################################################################################################
# Comments
################################################################################################


# ----------------------
# CREATE   
# ----------------------

def create_comment(username, post_id, comment_text):
    try:
        query = """
        INSERT INTO comment (username, post_id, comment_text)
        VALUES (%s, %s, %s)
        """
        run_cud_query(query, (username, post_id, comment_text))
        return True
    except Exception as e:
        print(f"Failed to create comment: {e}")
        return False
    
# ----------------------
# READ (All / By username) 
# ----------------------

def get_all_comments_for_post(post_id):
    try:
        query = """
        SELECT * FROM comment
        WHERE post_id = %s
        ORDER BY comment_id ASC
        """
        return run_read_multiple(query, (post_id,))
    except Exception as e:
        print(f"Failed get comments for post \"{post_id}\" : {e}")
        return False

def get_comments_by_user(username):
    try:
        query = """
        SELECT * FROM comment
        WHERE username = %s
        ORDER BY comment_id DESC
        """
        return run_read_multiple(query, (username,))
    except Exception as e:
        print(f"Failed to retrieve comments from {username}: {e}")
        return False

def get_comment_count_for_post(post_id):
    try:
        query = """
        SELECT COUNT(*) FROM comment
        WHERE post_id = %s
        """
        result = run_read_single(query, (post_id,))
        return result[0] if result else 0
    except Exception as e:
        print(f"Failed to obtain comment count for \"{post_id}\" : {e}")
        return False

# ----------------------
# UPDATE 
# ----------------------

def update_comment(comment_id, new_text):
    try:
        query = """
        UPDATE comment
        SET comment_text = %s
        WHERE comment_id = %s
        """
        run_cud_query(query, (new_text, comment_id))
        return True
    except Exception as e:
        print(f"Failed to update comment: {e}")
        return False

# ----------------------
# DELETE
# ----------------------

def delete_comment(comment_id):
    try:
        query = """
        DELETE FROM comment
        WHERE comment_id = %s
        """
        run_cud_query(query, (comment_id,))
        return True
    except Exception as e:
        print(f"Failed to delete comment: {e}")
        return False
    


##############################################

# TESTING STUFF

##############################################

# create_post(username, audio_id=None, post_description="", hashtags=None, created_at="CURRENT_TIMESTAMP"):
# def make_post_with_media(username, audio_id=None, post_description="", hashtags=None, media_list=[]):

# create_post("dog", post_description="Pucci on pack watch.", hashtags=["packwatch"])
# like_post("Joe1", 13)
# create_comment("Joe1", 13, "This post sucks!")
# unlike_post("Joe1", 13)
# make_post_with_media("MichèleMouton", 
#                      post_description="R.I.P. Irwindale Speedway!", 
#                      hashtags=["cars", "racing", "photography"], 
#                      media_list={r"C:\Users\jcngu\OneDrive\Pictures\MEMORY FOLDER\irwindaleExtravaganza\edits\smalls\sickestDrift.png" 
#                                  : "photo"})
# make_post_with_media("Artismo", 
#                      post_description="The greatest in automotive excellence", 
#                      hashtags=["photography", "cars"],
#                      media_list={r"C:\Users\jcngu\OneDrive\Pictures\edited photos for projects\PorscheCover.png"
#                                 : "photo"})
# make_post_with_media("Joe1", 
#                      post_description="New music video!", 
#                      hashtags=["video", "music"],
#                      media_list={r"C:\Users\jcngu\OneDrive\Documents\blue usb stuff\Advanced crap\FAA_MusicVideo_ConnorBartlett.mp4"
#                                 : "video"})

print(home_feed_algo(r"Artismo"))
print("---------------------------------")
print(recommended_feed_algo(r"Artismo"))


#create_post("Artismo", post_description="ART", hashtags=["art", "photography"])