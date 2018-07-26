import os

import cv2
import utils
import numpy as np
import matplotlib.pyplot as plt

import numpy as np
import keras
from keras.models import Sequential


class DataGenerator(keras.utils.Sequence):
    'Generates data for Keras'
    def __init__(self, training_file_name, batch_size=10, n_classes=52, shuffle=True):
        'Initialization'
        self.shuffle = shuffle
        #self.train_labels_file_name = "faces/faces_is/train/labels.txt"
        self.train_labels_file_name = training_file_name
        self.sample_size = utils.read_number_of_lines(self.train_labels_file_name)
        self.train_labels_indexes = None #if shuffle is not required, then indexes are redundant and donot have to occupy the memory
        self.batch_size = batch_size
        self.n_classes = n_classes

        if self.shuffle == True:
            self.train_labels_indexes = np.arange(self.sample_size)
            np.random.shuffle(self.train_labels_indexes)

        self.batch_bounds = [(i,i+self.batch_size) for i in range(0,self.sample_size,self.batch_size)]

        self.on_epoch_end()

    def read_batch_from_file(self,filename, number0, numberN):
        # https://stackoverflow.com/questions/2081836/reading-specific-lines-only-python
        with open(filename) as f:
            lines = []  # scope is proper, if file is not opened function will return None
            if self.shuffle:
                for i, line in enumerate(f):
                    if i in sorted(self.train_labels_indexes[number0:numberN]):  # YES! It is supposed to be that way in case the file is large, I am aware it is not a Python paradigm way, trust me Cage, it's the only way
                        lines.append(line)
            else:
                for i, line in enumerate(f):
                    if i >= number0 and i < numberN:  # YES! It is supposed to be that way in case the file is large, I am aware it is not a Python paradigm way, trust me Cage, it's the only way
                        lines.append(line)
            return lines

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

    def __del__(self):
        print("garbage collector, yeah!")

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
        lines = self.read_batch_from_file(self.train_labels_file_name, number0,numberN)
        dirname = os.path.dirname(self.train_labels_file_name)
        return self.create_images_labels(lines, dirname)


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


   model = utils.create_model()
   model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["categorical_accuracy"])

   model.fit_generator(generator=dataGeneratorInstanceTrain,
                    validation_data=dataGeneratorInstanceTrain,
                    use_multiprocessing=False,
                    workers=1)

if __name__ == "__main__":
    main()
