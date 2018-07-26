import os
import cv2
from keras import Sequential
from keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Activation, BatchNormalization, regularizers
from keras.callbacks import ModelCheckpoint, EarlyStopping, TensorBoard
from keras.utils import np_utils
import numpy as np



def read_number_of_lines(filename):
    #https: // stackoverflow.com / questions / 845058 / how - to - get - line - count - cheaply - in -python
    with open(filename) as f:
        for i, l in enumerate(f):
             pass
        return i + 1

def read_data(filename, number):
    if number == "*" :
        with open(filename) as f:
            lines = f.read().splitlines()
    else:
        with open(filename) as f:
            lines = f.read().splitlines()[:number]
    return lines

def read_data1(filename, number0,numberN):
    #https://stackoverflow.com/questions/2081836/reading-specific-lines-only-python
    with open(filename) as f:
        lines =[] #scope is proper, if file is not opened function will return None
        for i, line in enumerate(f):
            if i >= number0 and i<=numberN: #YES! It is supposed to be that way in case the file is large, I am aware it is not a Python paradigm way, trust me Cage, it's the only way
                print(line)
                lines.append(line)
            break


    with open(filename) as f:
            lines = f.read().splitlines()[number0:numberN]
    return lines

def create_images_labels(lines,directory):
    images = []
    labels = []

    for line in lines:
        tmp = line.split()
        path = tmp[0]
        label = tuple(map(int,tmp[1:]))
        path = os.path.join(directory, path)
        img = cv2.imread(path)
        images.append(img)
        labels.append(label)

    return images, labels

def rescale_image(img,size_tuple):
    return  cv2.resize(img,size_tuple,interpolation=cv2.INTER_AREA)

def create_model():
    model = Sequential()
    model.add(Conv2D(16,(3,3),input_shape = (128,128,3))) #warstwa wejściowa więc jest zdjęcie 128 128 x RGB (==3)
    model.add(BatchNormalization()) #normalizacja wyników w celu lepszego trenowania
    model.add(Activation("relu"))
    model.add(Conv2D(16,(3,3)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))
    model.add(MaxPooling2D((2,2)))
    model.add(Conv2D(32, (3, 3)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))
    model.add(Conv2D(32, (3, 3)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))
    model.add(MaxPooling2D((2, 2)))
    model.add(Flatten())
    model.add(Dense(128,kernel_regularizer=regularizers.l2(0.01)))
    model.add(Activation("relu"))
    model.add(Dense(52,activation = "sigmoid")) # because number of colours = 14
    return model