from flask import Flask, request, jsonify
from flask_cors import CORS
import ArthouseDBSQLComands_USER as user_db

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

if __name__ == '__main__':
    print("Starting Arthouse API...")
    app.run(debug=True, host='0.0.0.0', port=5001)
