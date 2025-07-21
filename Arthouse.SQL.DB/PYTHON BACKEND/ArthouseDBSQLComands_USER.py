###############################################################
#   Note, remember to upload FIRST. If upload is successful,
#   then update the sql database.
#   Failure to do so will get us clapped.
###############################################################

#perform CRUD operations on user data in the database (create, read, update, delete)


import bcrypt
from queryHelper import run_cud_query, run_read_multiple, run_read_single


################################################################################################
# USER
################################################################################################



# ----------------------
# CREATE (Register) USER
# ----------------------
def create_user(username, email, password):
    try:
        password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        query = "INSERT INTO user (username, email, password_hash) VALUES (%s, %s, %s)"
        run_cud_query(query, (username, email, password_hash))
        return True
    except Exception as e:
        print(f"Could not create \"{username}\". Perhaps the user already exists? : {e}")
        return False

# ----------------------
# READ (All / By username) USER
# ----------------------
def get_all_users():
    try:
        query = "SELECT username, email FROM user"
        users = run_read_multiple(query)
        return users
    except Exception as e:
        print(f"Users could be loaded idk why. : {e}")
        return None

def get_user_by_username(username):
    try:
        query = "SELECT username, email FROM user WHERE username = %s"
        user = run_read_single(query, (username,))
        return user
    except Exception as e:
        print(f"\"{username}\" was not found for some reason. Maybe you broke something????? : {e}")
        return None

# ----------------------
# UPDATE USER
# ----------------------
def update_user(username, new_username=None, email=None, password=None):
    updates = []
    values = []
    try:
        if new_username:
            updates.append("username = %s")
            values.append(new_username)
        if email:
            updates.append("email = %s")
            values.append(email)
        if password:
            hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
            updates.append("password_hash = %s")
            values.append(hashed)

        if not updates:
            return None

        values.append(username)
        query = f"UPDATE user SET {', '.join(updates)} WHERE username = %s"
        run_cud_query(query, tuple(values))
        return True
    except Exception as e:
        print(f"Updating to \"{username}\" failed. : {e}")
        return False

# ----------------------
# DELETE USER
# ----------------------
def delete_user(username):
    try:
        query = "DELETE FROM user WHERE username = %s"
        run_cud_query(query, (username,))
        return True
    except Exception as e:
        print(f"\"{username}\" could not be deleted. Verify that \"{username}\" exists. : {e}")
        return False

# ----------------------
# LOGIN / VERIFY PASSWORD
# ----------------------
def verify_user_login(username, password_attempt):
    query = "SELECT password_hash FROM user WHERE username = %s"
    result = run_read_single(query, (username,))
    if result:
        stored_hash = result
        if bcrypt.checkpw(password_attempt.encode('utf-8'), stored_hash.encode('utf-8')):
            return True  # Successful login
    return False



################################################################################################
# PROFILE
################################################################################################



# ----------------------
# CREATE PROFILE
# ----------------------
def create_profile(name, username, profile_picture_url, bio):
    try:    
        query = "INSERT INTO profile (name, username, profile_picture_url, bio) VALUES (%s, %s, %s, %s)"
        run_cud_query(query, (name, username, profile_picture_url, bio))
        return True
    except Exception as e:
        print(f"An unexpected error occured. The profile \"{username}\" as \"{name}\" was not created or already exists. EVERYONE PANICK!!!! : {e}")
        return False

# ----------------------
# READ (All / By username) PROFILES
# ----------------------
def get_all_profiles():
    try:
        query = "SELECT name, username, profile_picture_url, bio FROM profile"
        users = run_read_multiple(query)
        return users
    except Exception as e:
        print(f"Could not fetch all profiles. : {e}")
        return None

def get_profile_by_username(username):
    try:
        query = "SELECT name, username, profile_picture_url, bio FROM profile WHERE username = %s"
        user = run_read_single(query, (username,))
        return user
    except Exception as e:
        print(f"An error occured. {username} was not found. : {e}")
        return None

# ----------------------
# UPDATE PROFILE
# ----------------------
def update_profile(username, new_username=None, name=None, profile_picture_url=None, bio=None):
    updates = []
    values = []
    try:
        if new_username:
            updates.append("username = %s")
            values.append(new_username)
        if name:
            updates.append("name = %s")
            values.append(name)
        if profile_picture_url:
            updates.append("profile_picture_url = %s")
            values.append(profile_picture_url)
        if bio:
            updates.append("bio = %s")
            values.append(bio)

        if not updates:
            return None

        values.append(username)
        query = f"UPDATE profile SET {', '.join(updates)} WHERE username = %s"
        run_cud_query(query, tuple(values))
        return True
    except Exception as e:
        print(f"An error occured. Verify that {username} exists in user. : {e}")
        return False

# ----------------------
# DELETE
# ----------------------

#DELETE FROM USER TO DELETE THE PROFILE 
#user and profile are tied together



################################################################################################
# follower_relationships
################################################################################################


# ----------------------
# CREATE    follower to followee relationships
# ----------------------

def follow(follower_username, followee_username):
    try:
        query = "INSERT INTO follower_relationships (follower, followee) VALUES (%s, %s)"
        # conn = get_connection()
        # cursor = conn.cursor()
        # cursor.execute(query, (follower_username, followee_username))
        # # cursor.execute("""UPDATE profile                                                  #check if counts update by sql trigger, if so remove commented lines
        # #                 SET follower_count = GREATEST(follower_count + 1, 0)
        # #                 WHERE username = %s"""
        # #                , (followee_username,))
        # # cursor.execute("""UPDATE profile
        # #                 SET following_count = GREATEST(following_count + 1, 0)
        # #                 WHERE username = %s"""
        # #                , (follower_username,))
        # conn.commit()
        # cursor.close()
        # conn.close()

        run_cud_query(query, (follower_username, followee_username))
        return True
    except Exception as e:
        print(f"Failed to follow from \"{follower_username}\" to \"{followee_username}\" : {e}")
        return None

# ----------------------
# READ (All / By username) follower_relationships
# ----------------------

def view_all_relationships():
    try:
        query = "SELECT * FROM follower_relationships"
        relationships = run_read_multiple(query)
        return relationships
    except Exception as e:
        print(f"Failed to find follower to followee relationships : {e}")
        return None

# view who follows "username"
def view_followers(username):
    try:
        query = "SELECT follower FROM follower_relationships WHERE followee = %s"
        relationships = run_read_multiple(query, (username,))
        return [row[0] for row in relationships]
    except Exception as e:
        print(f"Failed to find followers for \"{username}\" : {e}")
        return None

# sees who "username" is following
def view_following(username):
    try:
        query = "SELECT followee FROM follower_relationships WHERE follower = %s"
        relationships = run_read_multiple(query, (username,))
        return [row[0] for row in relationships]
    except Exception as e:
        print(f"Failed to find who \"{username}\" follows : {e}")
        return None

# ----------------------
# UPDATE follower_relationships
# ----------------------

# Not needed. either following or not following

# ----------------------
# DELETE
# ----------------------

def unfollow(follower_username, followee_username):
    try:
        # conn = get_connection()
        # cursor = conn.cursor()
        # cursor.execute("DELETE FROM follower_relationships WHERE follower = %s AND followee = %s", (follower_username, followee_username,))
        # # cursor.execute("""UPDATE profile                                          #check if counts update by sql trigger, if so remove commented lines
        # #                 SET follower_count = GREATEST(follower_count - 1, 0)
        # #                 WHERE username = %s"""
        # #                , (followee_username,))
        # # cursor.execute("""UPDATE profile                                          #check if counts update by sql trigger, if so remove commented lines
        # #                 SET following_count = GREATEST(following_count - 1, 0)
        # #                 WHERE username = %s"""
        # #                , (follower_username,))
        # conn.commit()
        # cursor.close()
        # conn.close()

        query = "DELETE FROM follower_relationships WHERE follower = %s AND followee = %s"
        run_cud_query(query, (follower_username, followee_username,))
        return True
    except Exception as e:
        print(f"Failed to unfollow from \"{follower_username}\" to \"{followee_username}\". : {e}")
        return False


##############################################

# TESTING STUFF

##############################################
#create_user("Joe", "iwanttodie@death.com", "joe")
#update_user("Joe", new_username="Joel", password="soup")
#print(get_all_users())
#print(get_user_by_username("Joel"))
#delete_user("Joel")


#TEST profile

# create_user("Joe2", "soup@borscht.com", "jojoPart4")   #must have existing user
# create_profile("JoeDaMAN", "Joe2", "URL HERE", "sql injection")
# update_profile("Joe2", profile_picture_url="URL now?", bio="Busting moves...")
# print(get_all_profiles())
# print(get_profile_by_username("Joe2"))
#delete_user("Joe2")

#test Followers relationships

print(run_read_multiple("SELECT * FROM profile"))

###########################################