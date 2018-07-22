import os
import cv2
import numpy as np


FILE = "datasets/dresses/train/labels.txt"
VALIDATION_FILE = "datasets/dresses/val/labels.txt"

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

       # label = np_utils.to_categorical(label, 14)
        labels.append(label)

    return images, labels

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