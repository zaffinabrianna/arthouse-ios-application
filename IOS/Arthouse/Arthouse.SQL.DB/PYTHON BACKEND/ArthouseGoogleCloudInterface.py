from flask import Flask, request, jsonify
from google.cloud import storage
from datetime import timedelta
import requests
import os

app = Flask(__name__)
client = storage.Client.from_service_account_json("caramel-feat-466118-i4-f6cde017fca1.json")
@app.route("/generate-signed-url", methods=["POST"])


def generate_url(bucket_name, file_name, destination_blob_folder, request_method, expiration_minutes=15):
    if destination_blob_folder not in ["photo", "video", "audio"]:
        print("folder for [generate_url()]")
        return ""
    else:
        storage_client = storage.Client.from_service_account_json("caramel-feat-466118-i4-f6cde017fca1.json")
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(f"{destination_blob_folder}/{file_name}")
        ext_name = (os.path.splitext(file_name))[1][1:]

        url = blob.generate_signed_url(
            version="v4",
            expiration=timedelta(minutes=expiration_minutes),
            method=request_method,
            content_type=f"{destination_blob_folder}/{ext_name}",
        )

    return url


###############################################################################

#take in multiple file_paths for upload, view/download, and deletion from the google cloud storage

def upload_via_signed_url(bucket_name, file_paths, destination_blob_folder):
    success = True
    for file_path in file_paths:
        try:
            with open(file_path, "rb") as f:
                file_data = f.read()

            base_file_name = os.path.basename(file_path)
            ext_name = (os.path.splitext(base_file_name))[1][1:]
            signed_url = generate_url(bucket_name, base_file_name, destination_blob_folder, "PUT")
            headers = {"Content-Type": f"{destination_blob_folder}/{ext_name}"}
            response = requests.put(signed_url, data=file_data, headers=headers)

            if response.status_code == 200:
                print(f"{response} Successfully uploaded {base_file_name}.")
            else:
                print(f"{response} upload failed {base_file_name}.")
                success = False
        except FileNotFoundError:
            print("File could not be located. Check your pathing again.")
            success = False
        except: 
            print(f"Upload failed for an unknown reason.")
            success = False
    return success


def delete_via_signed_url(bucket_name, file_paths, destination_blob_folder):
    success = True
    for file_path in file_paths:
        try:
            base_file_name = os.path.basename(file_path)
            ext_name = (os.path.splitext(base_file_name))[1][1:]
            url = generate_url(bucket_name, base_file_name, destination_blob_folder, "DELETE")
            headers = {"Content-Type": f"{destination_blob_folder}/{ext_name}"}
            response = requests.delete(url, headers=headers)

            if response.status_code == 204:
                print(f"Successfully deleted {base_file_name}.")
            else:
                print(f"The deletion of {base_file_name} was unsuccessful.")
                success = False
        except FileNotFoundError:
            print("The file could not be deleted because it does not exist.")
            success = False
        except:
            print("Failed for an unknown reason.")
            success = False
    return success


def view_via_signed_url(bucket_name, file_paths, destination_blob_folder):
    url_list = []
    for file_path in file_paths:
        try:
            base_file_name = os.path.basename(file_path)
            ext_name = (os.path.splitext(base_file_name))[1][1:]
            url = generate_url(bucket_name, base_file_name, destination_blob_folder, "GET")
            headers = {"Content-Type": f"{destination_blob_folder}/{ext_name}"}
            url = generate_url(bucket_name, base_file_name, destination_blob_folder, "GET")
            response = requests.get(url, headers=headers)
            
            if(response.status_code == 200):
                print(f"Successfully downloaded {base_file_name}")
                url_list.append(url)
            else:
                print(f"Could not retrieve the download link for {base_file_name}")
        except FileNotFoundError:
            print(f"The file: {base_file_name} does not exist")
        except:
            print("Something went wrong while trying to fetch the content.")

    return url_list
        


########################################################################################


#test deleteing stuff  
# upload_via_signed_url(bucketName, ["photo/test.txt", "photo/IMG_1466.jpg"], "photo")
# delete_blob_url(bucketName, ["test.txt", "IMG_1466.jpg"], "photo")
# delete_via_signed_url(bucketName, ["IMG_1294.jpg"], "photo")

# bucketName = "arthouse-media-bucket-storage"
# #testFilePaths = ["C:/Users/jcngu/OneDrive/Documents/FULLERTON SCHOOL WORK/Arthouse-SQL-DB/PYTHON-BACKEND-TESTS/testPhotos/IMG_1371-2.jpg"]
# testFilePhoto = [r"photo/IMG_1371-2.jpg", r"photo/IMG_1398-2.jpg"]
# testFileVideo = [r"video/MVI_1470.MOV"]

#test uploading stuff
# bucketName = "arthouse-media-bucket-storage"
# ifExists = os.path.exists(r"/mnt/c/Users/jcngu/OneDrive/Pictures/MEMORY FOLDER/HanhBalboaDate/JPGs/IMG_1294.jpg")
# print(ifExists)
# upload_via_signed_url(bucketName, [r"/mnt/c/Users/jcngu/OneDrive/Pictures/MEMORY FOLDER/HanhBalboaDate/JPGs/IMG_1294.jpg"], "photo")

#upload_via_signed_url(bucketName, testFilePhoto, "photo")
#upload_via_signed_url(bucketName, testFileVideo, "video")

#urls = view_via_signed_url(bucketName, testFilePhoto, "photo")
#print(urls)

# ifExists = os.path.exists(r"/mnt/c/Users/jcngu/OneDrive/Pictures/MEMORY FOLDER/HanhBalboaDate/JPGs/IMG_1294.jpg")
# print(ifExists)
#delete_via_signed_url(bucketName, testFilePhoto, "photo")

#view test

#print(generate_signed_view_url(bucketName, "IMG_1294.jpg", "photo"))