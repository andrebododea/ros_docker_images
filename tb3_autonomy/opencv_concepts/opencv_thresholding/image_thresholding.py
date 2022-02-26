#!/usr/bin/env python3

import numpy as np
import cv2

def read_image(image_name, as_gray):
    if as_gray:
        # Automatically transform to grayscale
        image = cv2.imread(image_name, cv2.IMREAD_GRAYSCALE)
    else:
        # Read as color image
        image = cv2.imread(image_name, cv2.IMREAD_COLOR)

    # Display the unaltered image after reading it in
    cv2.imshow("Image", image)
    return image

# For simple thresholding, if a pixel value is greater than the threshold value (from 0-255) then it is assigned a certain value (e.g. 255 for white).
# And if it is lower than the threshold value, then it is assigned to another value (for example 0 for black). 
# We can also invert this scheme, which is the policy that we are using here.
def basic_thresholding(gray_image, threshold_value):
    # This is usually 255 (white) when dealing with grayscale images
    maxval = 255 
    
    # Now perform the thresholding with policy THRESH_BINARY_INV. 
    # What this does is that if a pixel value is greater than thresh, set to 0 (black). Else, set to maxval (in this case - white)
    ret, thresh_basic = cv2.threshold( gray_image,
                                  threshold_value,
                                  maxval,
                                  cv2.THRESH_BINARY_INV)
    cv2.imshow("Basic Binary Image", thresh_basic) 

def adaptive_thresholding(gray_image, threshold_value):
    # This is usually 255 (white) when dealing with grayscale images
    maxval = 255 

    # Constant subtracted from the mean or weighted mean.
    C = 2

    # Now perform adaptive thresholding, and try two different policies
    adaptive_threshold_image = cv2.adaptiveThreshold(gray_image,
                                                     maxval,
                                                     cv2.ADAPTIVE_THRESH_MEAN_C, # adaptive method
                                                     cv2.THRESH_BINARY_INV,      # thresholding type
                                                     threshold_value,
                                                     C)

    cv2.imshow("Adapt. Mean C", adaptive_threshold_image)


    # Now perform adaptive thresholding, and try two different policies
    adaptive_threshold_image = cv2.adaptiveThreshold(gray_image,
                                                     maxval,
                                                     cv2.ADAPTIVE_THRESH_GAUSSIAN_C, # adaptive method
                                                     cv2.THRESH_BINARY_INV,      # thresholding type
                                                     threshold_value,
                                                     C)

    cv2.imshow("Adapt. Gaussian C", adaptive_threshold_image)



def main():
    image_name = "../images/shapes.png"
    # image_name = "../images/tomato.jpg"
    as_gray = True

    threshold_value = 115
    gray_image = read_image(image_name, as_gray)
    basic_thresholding(gray_image, threshold_value)
    adaptive_thresholding(gray_image, threshold_value)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()