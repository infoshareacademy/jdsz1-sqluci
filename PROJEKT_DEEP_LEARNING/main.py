import os

import cv2
from keras import Sequential
from keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Activation, BatchNormalization, regularizers
from keras.callbacks import ModelCheckpoint, EarlyStopping, TensorBoard
from keras.utils import np_utils
import numpy as np


absolute_path = "C:\\Users\\miser\\Documents\\Projects\\GIT\\DATA_SCIENCE\\jdsz1-sqluci\\PROJEKT_DEEP_LEARNING\\"
FILE = absolute_path + "dresses\\train\\labels.txt"
VALIDATION_FILE = absolute_path +"dresses\\val\\labels.txt"

def read_data(filename, number):
    with open(filename) as f:
        lines = f.read().splitlines()[:number]
    return lines

def create_images_labels(lines,directory):
    images = []
    labels = []

    for line in lines:
        path, label = line.split()
        path = os.path.join(directory, path)
        img = cv2.imread(path)
        img = cv2.resize(img,(128,128),interpolation=cv2.INTER_AREA)
        images.append(img)

        label = int(label)
        label = np_utils.to_categorical(label, 14)
        labels.append(label)

    return images, labels

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
    model.add(Dense(14,activation = "sigmoid")) # because number of colours = 14
    return model

def main():
    lines = read_data(FILE,100)
    dirname = os.path.dirname(FILE)
    images, labels = create_images_labels(lines,dirname)

    images = np.array(images)
    labels = np.array(labels)

    model = create_model()
    model.compile(optimizer = "adam", loss="binary_crossentropy",metrics=["categorical_accuracy"])
    model.summary()


    #validation
    validation_lines = read_data(VALIDATION_FILE, 100)
    validation_dirname = os.path.dirname(VALIDATION_FILE)
    validation__images, validation_labels = create_images_labels(validation_lines,validation_dirname)

    validation__images = np.array(validation__images)
    validation_labels = np.array(validation_labels)

    model.fit(images, labels, batch_size=10, epochs=10,validation_data=(validation__images, validation_labels),
              callbacks=[ModelCheckpoint("checkpoint.hdf5", save_best_only=True,verbose=1),
                         EarlyStopping(monitor='val_loss', min_delta=0, patience=0, verbose=1, mode='auto', baseline=None),
                         TensorBoard(log_dir='./logs', histogram_freq=0, batch_size=32, write_graph=True,
                                     write_grads=False, write_images=False, embeddings_freq=0,
                                     embeddings_layer_names=None, embeddings_metadata=None, embeddings_data=None)])


    #model.load_weights("checkpoint.hdf5")
    #print(labels)
    #cv2.imshow('image', images[0])

    #for img in images:
    #   cv2.imshow('image',img)
    #   cv2.waitKey(0)




if __name__ == "__main__":
    main()