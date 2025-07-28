from flask import Flask, request, jsonify
from flask_cors import CORS
import ArthouseDBSQLComands_USER as user_db
from queryHelper import run_cud_query, run_read_multiple

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return {"message": "Arthouse API running"}

@app.route('/api/register', methods=['POST'])
def register():
    data = request.json
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')
    name = data.get('name', username)
    
    if user_db.create_user(username, email, password):
        if user_db.create_profile(name, username, "", ""):
            profile = user_db.get_profile_by_username(username)
            return {
                "success": True,
                "user": {
                    "username": username,
                    "email": email,
                    "name": profile[0] if profile else name
                }
            }
        else:
            user_db.delete_user(username)  # cleanup if profile fails
            return {"error": "Profile creation failed"}, 400
    else:
        return {"error": "User creation failed"}, 400

@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    
    if user_db.verify_user_login(username, password):
        user = user_db.get_user_by_username(username)
        profile = user_db.get_profile_by_username(username)
        
        if user and profile:
            return {
                "success": True,
                "user": {
                    "username": user[0],
                    "email": user[1],
                    "name": profile[0]
                }
            }
    
    return {"error": "Invalid login"}, 401

@app.route('/api/user/<username>')
def get_user(username):
    profile = user_db.get_profile_by_username(username)
    if profile:
        followers = user_db.view_followers(username) or []
        following = user_db.view_following(username) or []
        
        return {
            "username": profile[1],
            "name": profile[0],
            "bio": profile[3],
            "follower_count": len(followers),
            "following_count": len(following)
        }
    return {"error": "User not found"}, 404

@app.route('/api/follow', methods=['POST'])
def follow():
    data = request.json
    if user_db.follow(data.get('follower'), data.get('followee')):
        return {"success": True}
    return {"error": "Follow failed"}, 400

@app.route('/api/unfollow', methods=['POST'])
def unfollow():
    data = request.json
    if user_db.unfollow(data.get('follower'), data.get('followee')):
        return {"success": True}
    return {"error": "Unfollow failed"}, 400

@app.route('/api/posts', methods=['POST'])
def create_post():
    try:
        data = request.json
        username = data.get('username')
        caption = data.get('caption', '')
        media_type = data.get('media_type', 'photo')
        
        # Actually save to database
        query = "INSERT INTO post (username, post_description, is_private, like_count, comment_count) VALUES (%s, %s, %s, %s, %s)"
        post_id = run_cud_query(query, (username, caption, False, 0, 0))
        
        if post_id:
            print(f"✅ Post saved to database:")
            print(f"   Post ID: {post_id}")
            print(f"   User: {username}")
            print(f"   Caption: {caption}")
            print(f"   Media Type: {media_type}")
            
            return {
                "success": True,
                "message": "Post created successfully",
                "post": {
                    "post_id": post_id,
                    "username": username,
                    "caption": caption,
                    "media_type": media_type
                }
            }
        else:
            return {"error": "Failed to save post to database"}, 400
            
    except Exception as e:
        print(f"Error creating post: {e}")
        return {"error": f"Failed to create post: {str(e)}"}, 500

@app.route('/api/posts', methods=['GET'])
def get_posts():
    try:
        # Get posts from database
        query = "SELECT username, post_description, like_count, created_at FROM post ORDER BY created_at DESC LIMIT 20"
        posts_data = run_read_multiple(query)
        
        if posts_data:
            posts = []
            for post_row in posts_data:
                posts.append({
                    "username": post_row[0],
                    "caption": post_row[1] or "",
                    "like_count": post_row[2] or 0,
                    "created_at": str(post_row[3]) if post_row[3] else ""
                })
            
            print(f"📊 Returning {len(posts)} posts from database")
            return {
                "success": True,
                "posts": posts
            }
        else:
            print("📊 No posts found in database")
            return {
                "success": True,
                "posts": []
            }
    except Exception as e:
        print(f"Error getting posts: {e}")
        return {"error": f"Failed to get posts: {str(e)}"}, 500

if __name__ == '__main__':
    print("Starting Arthouse API...")
    app.run(debug=True, host='0.0.0.0', port=5001)
