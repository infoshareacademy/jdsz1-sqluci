import os

import cv2
#import utils

import numpy as np
import keras
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Activation, BatchNormalization, regularizers

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
    model.add(Dense(52,activation = "softmax"))
    return model

class DataGenerator(keras.utils.Sequence):
    'Generates data for Keras'
    def __init__(self, training_file_name, batch_size=32, n_classes=52, shuffle=True):
        'Initialization'
        self.shuffle = shuffle
        self.train_labels_file_name = training_file_name
        self.sample_size = self.read_number_of_lines(self.train_labels_file_name)
        self.batch_size = batch_size
        self.n_classes = n_classes
        self.lines = self.read_all_lines(self.train_labels_file_name)

        if self.shuffle == True:
            np.random.shuffle(self.lines)

        self.batch_bounds = [(i,i+self.batch_size) for i in range(0,self.sample_size,self.batch_size)]

    def read_all_lines(self, filename):
         with open(filename) as f:
             lines = []  # scope is proper, if file is not opened function will return None
             for i, line in enumerate(f):
                  lines.append(line)

             return lines

    def read_number_of_lines(self,filename):
        # https: // stackoverflow.com / questions / 845058 / how - to - get - line - count - cheaply - in -python
        with open(filename) as f:
            for i, l in enumerate(f):
                pass
            return i + 1

    def __len__(self):
        'Denotes the number of batches per epoch'
        return len(self.batch_bounds)

    def getitem(self,index):
        return self.__getitem__(index)

    def __getitem__(self, index):
        'Generate one batch of data'
        # Generate indexes of the batch
        if index == len(self.batch_bounds): #start over again
            index = 0
        number0, numberN = self.batch_bounds[index]
        # Generate data
        X, y = self.__data_generation(number0,numberN)
        return X, y

    def on_epoch_end(self):
        print("I am doing nothing")

    def create_images_labels(self,lines, directory):
        images = []
        labels = []

        for line in lines:
            path, label = line.split()
            path = os.path.join(directory, path)
            img = cv2.imread(path)
            img = cv2.resize(img, (128, 128), interpolation=cv2.INTER_AREA)
            images.append(img)

            label = int(label)
            label = keras.utils.to_categorical(label, self.n_classes)
            labels.append(label)

        return np.array(images), np.array(labels)

    def __data_generation(self, number0,numberN):
        print("__data_generation")
        dirname = os.path.dirname(self.train_labels_file_name)
        return self.create_images_labels(self.lines[number0:numberN], dirname)


def main():
   dataGeneratorInstanceTrain = DataGenerator("faces/faces_is/train/labels.txt")
   X, y = dataGeneratorInstanceTrain.getitem(0)
   print(X)
   print(y)

   X, y = dataGeneratorInstanceTrain.getitem(1)
   print(X)
   print(y)


   dataGeneratorInstanceValidate = DataGenerator("faces/faces_is/val/labels.txt")
   X, y = dataGeneratorInstanceValidate.getitem(0)
   print(X)
   print(y)

   X, y = dataGeneratorInstanceValidate.getitem(1)
   print(X)
   print(y)


   model = create_model()
   model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["categorical_accuracy"])

   model.fit_generator(generator=dataGeneratorInstanceTrain,
                    validation_data=dataGeneratorInstanceTrain,
                    use_multiprocessing=True,
                    workers=4)

if __name__ == "__main__":
    main()
