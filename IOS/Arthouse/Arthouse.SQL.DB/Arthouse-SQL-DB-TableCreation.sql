CREATE DATABASE IF NOT EXISTS ARTHOUSE;
USE ARTHOUSE;

CREATE TABLE IF NOT EXISTS user (
	username VARCHAR(36) NOT NULL UNIQUE PRIMARY KEY,
	email VARCHAR(100) NOT NULL,
	password_hash TEXT NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS profile (
	name VARCHAR(100) NOT NULL,
	username VARCHAR(36) NOT NULL UNIQUE,
   	profile_picture_url TEXT,
	bio TEXT,
	follower_count INT DEFAULT 0,
following_count INT DEFAULT 0,
	FOREIGN KEY (username) REFERENCES user(username) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS follower_relationships (
    follower VARCHAR(36),
    followee VARCHAR(36),
    PRIMARY KEY (follower, followee),
    FOREIGN KEY (follower) REFERENCES profile(username) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS post (
post_id INT AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(36) NOT NULL,                      	-- Author of the post
	audio_id INT,
	post_description TEXT,
	is_private BOOLEAN DEFAULT FALSE,
	like_count INT DEFAULT 0,
	comment_count INT DEFAULT 0,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (username) REFERENCES profile(username) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS hashtag (
	hashtag VARCHAR(64),
	post_id INT,
	PRIMARY KEY (hashtag, post_id),
	FOREIGN KEY (post_id) REFERENCES post(post_id) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS user_liked_relationships (
 	username VARCHAR(36),
post_id INT,
PRIMARY KEY (username, post_id),
FOREIGN KEY (username) REFERENCES profile(username) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (post_id) REFERENCES post(post_id) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS comment (
comment_id INT AUTO_INCREMENT PRIMARY KEY,
    	username VARCHAR(36),
    	post_id INT,
	comment_text TEXT,
    	FOREIGN KEY (username) REFERENCES profile(username) ON UPDATE CASCADE ON DELETE CASCADE,
    	FOREIGN KEY (post_id) REFERENCES post(post_id) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS media (
	media_id INT PRIMARY KEY AUTO_INCREMENT UNIQUE,	-- unique identifier
	file_name VARCHAR(255) NOT NULL,
	extension_name text NOT NULL,
	media_type ENUM('photo', 'video', 'audio') NOT NULL,
	post_id INT NOT NULL,              -- Links media to a post
	uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (post_id) REFERENCES post(post_id) ON DELETE CASCADE
)ENGINE=InnoDB;

-- Each table stores only its type
CREATE TABLE IF NOT EXISTS photo (
    media_id INT PRIMARY KEY,
    resolution VARCHAR(50),
    FOREIGN KEY (media_id) REFERENCES media(media_id) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS video (
    media_id INT PRIMARY KEY,
    duration_seconds INT,
    resolution VARCHAR(50),
    FOREIGN KEY (media_id) REFERENCES media(media_id) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS audio (
    media_id INT PRIMARY KEY,
    duration_seconds INT,
    bitrate_kbps INT,
    FOREIGN KEY (media_id) REFERENCES media(media_id) ON DELETE CASCADE
)ENGINE=InnoDB;

ALTER TABLE post
ADD CONSTRAINT fk_post_audio
FOREIGN KEY (audio_id) REFERENCES media(media_id)
ON DELETE SET NULL;

DROP TRIGGER IF EXISTS after_follow_insert;
DROP TRIGGER IF EXISTS after_follow_delete;
DROP TRIGGER IF EXISTS after_like_insert;
DROP TRIGGER IF EXISTS after_like_delete;
DROP TRIGGER IF EXISTS after_comment_insert;
DROP TRIGGER IF EXISTS after_comment_delete;

DELIMITER //

CREATE TRIGGER after_follow_insert
AFTER INSERT ON follower_relationships
FOR EACH ROW
BEGIN
  UPDATE profile SET follower_count = follower_count + 1 WHERE username = NEW.followee;
  UPDATE profile SET following_count = following_count + 1 WHERE username = NEW.follower;
END;
//

CREATE TRIGGER after_follow_delete
AFTER DELETE ON follower_relationships
FOR EACH ROW
BEGIN
  UPDATE profile SET follower_count = GREATEST(follower_count - 1, 0) WHERE username = OLD.followee;
  UPDATE profile SET following_count = GREATEST(following_count - 1, 0) WHERE username = OLD.follower;
END;
//

CREATE TRIGGER after_like_insert
AFTER INSERT ON user_liked_relationships
FOR EACH ROW
BEGIN
  UPDATE post SET like_count = like_count + 1 WHERE post_id = NEW.post_id;
END;
//

CREATE TRIGGER after_like_delete
AFTER DELETE ON user_liked_relationships
FOR EACH ROW
BEGIN
  UPDATE post SET like_count = like_count - 1 WHERE post_id = OLD.post_id;
END;
//

CREATE TRIGGER after_comment_insert
AFTER INSERT ON comment
FOR EACH ROW
BEGIN
  UPDATE post
  SET comment_count = comment_count + 1
  WHERE post_id = NEW.post_id;
END;
//

CREATE TRIGGER after_comment_delete
AFTER DELETE ON comment
FOR EACH ROW
BEGIN
  UPDATE post
  SET comment_count = GREATEST(comment_count - 1, 0)
  WHERE post_id = OLD.post_id;
END;
//



DELIMITER ;