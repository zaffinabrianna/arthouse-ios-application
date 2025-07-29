from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import ArthouseDBSQLComands_USER as user_db
from queryHelper import run_cud_query, run_read_multiple, run_read_single
import os
import uuid
import base64

app = Flask(__name__)
CORS(app)

def upload_image_locally(image_data, filename):
    """Save base64 image locally for testing"""
    try:
        # Create uploads directory if it doesn't exist
        uploads_dir = "uploads"
        if not os.path.exists(uploads_dir):
            os.makedirs(uploads_dir)
        
        # Decode base64 image
        image_bytes = base64.b64decode(image_data)
        
        # Create unique filename
        unique_filename = f"{uuid.uuid4()}_{filename}"
        file_path = os.path.join(uploads_dir, unique_filename)
        
        # Save to local file
        with open(file_path, 'wb') as f:
            f.write(image_bytes)
        
        # Return local URL (for testing)
        return f"http://localhost:5001/uploads/{unique_filename}"
        
    except Exception as e:
        print(f"Error saving image locally: {e}")
        return None

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
            user_db.delete_user(username)
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
        image_data = data.get('image_data')  # Base64 encoded image
        
        image_url = None
        if image_data:
            # Use local storage for now
            filename = f"{username}_{uuid.uuid4()}.jpg"
            image_url = upload_image_locally(image_data, filename)
            
            if not image_url:
                return {"error": "Failed to save image"}, 400
        
        # Save post to database with image URL
        query = "INSERT INTO post (username, post_description, image_url, is_private, like_count, comment_count) VALUES (%s, %s, %s, %s, %s, %s)"
        post_id = run_cud_query(query, (username, caption, image_url, False, 0, 0))
        
        if post_id:
            print(f"✅ Post saved to database:")
            print(f"   Post ID: {post_id}")
            print(f"   User: {username}")
            print(f"   Caption: {caption}")
            print(f"   Image URL: {image_url}")
            
            return {
                "success": True,
                "message": "Post created successfully",
                "post": {
                    "post_id": post_id,
                    "username": username,
                    "caption": caption,
                    "image_url": image_url,
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
        # Get posts from database including image URLs
        query = "SELECT post_id, username, post_description, image_url, like_count, created_at FROM post ORDER BY created_at DESC LIMIT 20"
        posts_data = run_read_multiple(query)
        
        if posts_data:
            posts = []
            for post_row in posts_data:
                posts.append({
                    "post_id": post_row[0],
                    "username": post_row[1],
                    "caption": post_row[2] or "",
                    "image_url": post_row[3] or "",
                    "like_count": post_row[4] or 0,
                    "created_at": str(post_row[5]) if post_row[5] else ""
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

@app.route('/api/posts/<int:post_id>', methods=['DELETE'])
def delete_post(post_id):
    try:
        data = request.json
        username = data.get('username')
        
        if not username:
            return {"error": "Username required"}, 400
        
        # First, verify the post belongs to the user
        verify_query = "SELECT username FROM post WHERE post_id = %s"
        result = run_read_single(verify_query, (post_id,))
        
        if not result:
            return {"error": "Post not found"}, 404
            
        post_owner = result[0]
        if post_owner != username:
            return {"error": "Not authorized to delete this post"}, 403
        
        # Delete the post
        delete_query = "DELETE FROM post WHERE post_id = %s"
        run_cud_query(delete_query, (post_id,))
        
        print(f"✅ Post deleted:")
        print(f"   Post ID: {post_id}")
        print(f"   User: {username}")
        
        return {
            "success": True,
            "message": "Post deleted successfully",
            "post_id": post_id
        }
        
    except Exception as e:
        print(f"Error deleting post: {e}")
        return {"error": f"Failed to delete post: {str(e)}"}, 500

# Route to serve uploaded images
@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory('uploads', filename)

if __name__ == '__main__':
    print("Starting Arthouse API...")
    app.run(debug=True, host='0.0.0.0', port=5001)
