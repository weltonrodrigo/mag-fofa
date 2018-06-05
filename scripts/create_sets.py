# From a folder containing categories, create train and validation sets
# in a certain ratio.


import os
import pprint
import random
import shutil

# Location of raw dataset
RAW_DATA_PATH="datalab/mag-fofa"

# New location for the processed dataset
PATH="datalab/mag-fofa-ready"

# Ratio between train and validation
TRAIN_RATIO=0.8

def copy_files(files, src_folder, dest_folder): 

  # Create the destination folder if not already present
  if not os.path.exists(dest_folder):
    os.makedirs(dest_folder)
  
  # Copy files
  for file in files:
    original_file = os.path.join(src_folder, file)
    shutil.copy(original_file, dest_folder)
  
  print ("Copied %d files from %s to %s" % (len(files), src_folder, dest_folder))
  
  
categories = os.listdir(RAW_DATA_PATH)
categories

for category in categories:
  # Original location of the photos
  original_folder = os.path.join(RAW_DATA_PATH, category)
  
  # Get the whole list of photos for that category
  photos_list = os.listdir(original_folder)

  # Shuffle the list in place
  random.shuffle(photos_list)
  
  # From that, how many will be used to training? Round to lowest integer
  trainset_size = int( len(photos_list) * TRAIN_RATIO )
 
  # Slice the list of photos accordingly (remember: arrays are zero based)
  trainset_photos = photos_list[                 :trainset_size - 1 ]
  validset_photos = photos_list[ trainset_size:                     ]
  
  # Copy files to their final destination
  copy_files(trainset_photos, original_folder, os.path.join(PATH, "train", category) )
  copy_files(validset_photos, original_folder, os.path.join(PATH, "valid", category) )
