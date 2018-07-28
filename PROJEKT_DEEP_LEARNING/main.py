import os
import cv2
import numpy as np
from keras.applications import ResNet50
from keras import  Model
from keras.layers import  Dense
#import dresses_utils

def dressess_img_data_reader(line,directory =""):
    tmp = line.split()
    path = os.path.join(directory, tmp[0])
    X = cv2.resize(cv2.imread(path),(224,224), interpolation=cv2.INTER_AREA)
    y = tuple(map(int, tmp[1:]))
    return X,y

class cDatasetManager():
    """Class encapsulating simple dataset management functionality"""
    class cDataset():
        def __init__(self, _file_path: str,_data_reader = dressess_img_data_reader ) -> None:
            self.file_path = _file_path
            self.dataset_directory = os.path.dirname(self.file_path)
            self.y = None #lazy field
            self.X = None #lazy field
            self.data_reader = _data_reader #takes path to the exact file

        def __str__(self):
            return "size = "+str(len(self.labels)) + "\n" + self.file_path

        def __len__(self):
            return len(self.labels)

        def get_data(self):
            if self.X is None or self.y is None:
                self.read_data()

            return self.X, self.y

        def getX(self):
            if self.X is None or self.y is None:
                self.read_data()
            return self.X

        def gety(self):
            if self.X is None or self.y is None:
                self.read_data()
            return self.y

        def read_data(self):
            print("starting to read data...")
            with open(self.file_path) as f:
                lines = f.read().splitlines()

                self.X = []
                self.y = []

                for line in lines:
                    X,y = self.data_reader(line,self.dataset_directory)
                    self.X.append(X)
                    self.y.append(y)

                self.X = np.array(self.X)
                self.y = np.array(self.y)
                print("done. Imported "+str(len(self.y))+" entities.")


    def __init__(self,_train_file:str,_validation_file:str,_test_file:str)->None:
        self.dataset={"train":self.cDataset(_train_file),
                      "validation":self.cDataset(_validation_file),
                      "test":self.cDataset(_test_file)}

        for d in self.dataset:
            print(d)




def main():
    dsm = cDatasetManager("dresses\\train\\labels.txt",
                          "dresses\\val\\labels.txt",
                          "dresses\\test\\labels.txt")

    model = ResNet50(input_shape=(224,224,3),include_top=False, weights = "imagenet",pooling= "max", classes=14)
    model.compile(optimizer = "adam", loss="categorical_crossentropy",metrics=["categorical_accuracy"])
    dense = Dense(14,activation = "sigmoid")(model.output)
    model = Model(inputs=[model.input],outputs = [dense])
    model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["categorical_accuracy"])
    model.summary()

    model.fit(dsm.dataset["train"].getX(), dsm.dataset["train"].gety(), batch_size=32, epochs=10,
              validation_data=dsm.dataset["validation"].get_data())


    values = model.evaluate(dsm.dataset["test"].getX(),dsm.dataset["test"].gety())
    print(tuple(zip(values, model.metrics_names)))

if __name__ == "__main__":
    main()