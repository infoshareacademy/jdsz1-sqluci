import os
import cv2
import numpy as np


FILE = "datasets/dresses/train/labels.txt"
VALIDATION_FILE = "datasets/dresses/val/labels.txt"


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