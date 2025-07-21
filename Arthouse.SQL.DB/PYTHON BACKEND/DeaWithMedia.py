from mutagen import File
from pathlib import Path
from PIL import Image
import subprocess, json

import ArthouseGoogleCloudInterface as AGCI
from queryHelper import run_cud_query, run_read_multiple, run_read_single

def get_photo_metadata(photo_path):
    with Image.open(photo_path) as img:
        width, height = img.size
        return f"{width}x{height}"

def get_video_metadata(video_path):
    cmd = [
        'ffprobe', '-v', 'error',
        '-show_entries', 'format=duration',
        '-show_streams',
        '-of', 'json',
        video_path
    ]
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    info = json.loads(result.stdout)

    duration = float(info['format']['duration'])
    streams = info['streams']
    # Usually the first video stream has resolution
    for stream in streams:
        if stream['codec_type'] == 'video':
            width = stream.get('width')
            height = stream.get('height')
            resolution = f"{width}x{height}"
            break
    else:
        resolution = "Unknown"

    return duration, resolution

def get_audio_metadata(audio_path):
    audio = File(audio_path)
    duration = audio.info.length  # in seconds
    bitrate = audio.info.bitrate // 1000  # convert to kbps
    return duration, bitrate


media_type = 'video'
file_path = "video/MVI_1470.MOV"

if media_type == 'photo':
    resolution = get_photo_metadata(file_path)
    # Insert into `photo` table using media_id + resolution
elif media_type == 'video':
    duration, resolution = get_video_metadata(file_path)
    # Insert into `video` table using media_id, duration, resolution
elif media_type == 'audio':
    duration, bitrate = get_audio_metadata(file_path)
    # Insert into `audio` table using media_id, duration, bitrate