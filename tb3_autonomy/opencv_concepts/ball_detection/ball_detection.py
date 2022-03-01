#!/usr/bin/env python

import numpy as np
import cv2

# Read image from a specified path as RGB image
def read_rgb_image(image_path):
    rgb_image = cv2.imread(image_path, cv2.IMREAD_COLOR)
    cv2.imshow("RGB_Image", rgb_image)
    return rgb_image

# Convert an RGB image into HSV, then apply a mask to that image based on the provided color ranges
def apply_filter(rgb_image, lower_hsv_color_bound, upper_hsv_color_bound):
    # Convert image to HSV
    hsv_image = cv2.cvtColor(rgb_image, cv2.COLOR_BGR2HSV)
    cv2.imshow("HSV_Image", hsv_image)

    # Define the yellow mask based on the upper and lower bounds
    # This function performs a thresholding operation and converts the image into black and white
    mask = cv2.inRange(hsv_image, lower_hsv_color_bound, upper_hsv_color_bound)
    cv2.imshow("Yellow mask", mask)

    # return the binary image after mask has been applied
    return mask

# TODO: FINISH THIS FUNCTION
def get_all_contours(binary_image_mask):


# TODO: FINISH THIS FUNCTION
def draw_ball_contour(binary_image_mask, rgb_image, contour_list):


def main():
    # Step 1: Read the image in
    image_path = "../images/tennisball01.jpg"
    rgb_image = read_rgb_image(image_path)

    # Step 2: Apply the binary image mask
    # Format is H, S, V. So to target yellow, we'll target the below as upper and lower bounds. 
    lower_hsv_color_bound = (30, 150, 100)
    upper_hsv_color_bound = (60, 255, 255)
    binary_image_mask = apply_filter(rgb_image, lower_hsv_color_bound, upper_hsv_color_bound)

    # Step 3: Get the contours
    # TODO: FINISH THIS FUNCTION
    contour_list = get_all_contours(binary_image_mask)

    # Step 4: Draw the contour onto the image
    # TODO: FINISH THIS FUNCTION
    draw_ball_contour(binary_image_mask, rgb_image, contour_list)

    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()  