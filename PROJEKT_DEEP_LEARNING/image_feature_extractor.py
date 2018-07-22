import os

import cv2
from dresses_utils import *
import numpy as np
import matplotlib.pyplot as plt

absolute_path = "C:\\Users\\miser\\Documents\\Projects\\GIT\\DATA_SCIENCE\\jdsz1-sqluci\\PROJEKT_DEEP_LEARNING\\"
FILE = absolute_path + "dresses\\train\\labels.txt"
VALIDATION_FILE = absolute_path +"dresses\\val\\labels.txt"


def main():

    n = read_number_of_lines(FILE);
    print(n)

    lines = read_data(FILE,"*")
   # lines = read_data(FILE,100)

    dirname = os.path.dirname(FILE)
    images, labels = create_images_labels(lines,dirname)

    cv2.imshow('image', images[0])
    cv2.waitKey(0)

    W = np.zeros((n,1))
    H = np.zeros((n, 1))

    for i,img in enumerate(images):
        H[i], W[i] = img.shape[:2]

    plt.hist(W)
    plt.show()

    plt.hist(H)
    plt.show()

    plt.hist(H/W)
    plt.show()

    images = list(map(lambda img: rescale_image(img,(128,128)),images))

    cv2.imshow('image', images[0])
    cv2.waitKey(0)

    print(color_names)

    #images = np.array(images)
    #labels = np.array(labels)


if __name__ == "__main__":
    main()