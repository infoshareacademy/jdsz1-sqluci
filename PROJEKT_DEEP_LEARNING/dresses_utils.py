import cv2
import os


def read_data(filename, number):
    with open(filename) as f:
        lines = f.read().splitlines()[:number]
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
        img = cv2.resize(img,(128,128),interpolation=cv2.INTER_AREA)
        images.append(img)
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