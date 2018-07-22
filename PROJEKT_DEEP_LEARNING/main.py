import os

import cv2
from keras import Sequential
from keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Activation, BatchNormalization, regularizers
from keras.callbacks import ModelCheckpoint, EarlyStopping, TensorBoard
from keras.utils import np_utils
import numpy as np

from dresses_utils import *


absolute_path = "C:\\Users\\miser\\Documents\\Projects\\GIT\\DATA_SCIENCE\\jdsz1-sqluci\\PROJEKT_DEEP_LEARNING\\"
FILE = absolute_path + "dresses\\train\\labels.txt"
VALIDATION_FILE = absolute_path +"dresses\\val\\labels.txt"




def main():
    lines = read_data(FILE,100)
    #print(lines)

    dirname = os.path.dirname(FILE)
    images, labels = create_images_labels(lines,dirname)

    print(labels)

    #images = np.array(images)
    #labels = np.array(labels)


if __name__ == "__main__":
    main()