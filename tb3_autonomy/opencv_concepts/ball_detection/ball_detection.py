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

def get_all_contours(binary_image_mask):
    contours, hierarchy = cv2.findContours(binary_image_mask, 
                                              cv2.RETR_TREE,
                                              cv2.CHAIN_APPROX_SIMPLE  )
    return contours

def draw_ball_contour(binary_image, rgb_image, contour_list):
    black_image = np.zeros([binary_image.shape[0], binary_image.shape[1], 3], 'uint8')
    index = -1 # specify all contours
    thickness = 2 # thickness of the contour line
    green_color = (150, 250, 150) 
    red_color = (0, 0, 255) 
    pink_color = (150, 159, 255) 
    
    # cv2.drawContours(rgb_image, contour_list, index, color, thickness)

    for c in contour_list:
        area = cv2.contourArea(c)
        perimiter = cv2.arcLength(c, True)
        ((x,y), radius) = cv2.minEnclosingCircle(c)
        if (area>100):
            cv2.drawContours(rgb_image, [c], index, green_color, thickness)
            cv2.drawContours(black_image, [c], index, green_color, thickness)
            cx, cy = get_contour_center(c) 
            cv2.circle(rgb_image, (cx, cy), (int)(radius), red_color,1) # draw enclosing circle
            cv2.circle(black_image, (cx, cy), (int)(radius), red_color,1) # draw enclosing circle
            cv2.circle(black_image, (cx, cy), 5, pink_color,-1) # draw center
            print("Area: {}, Perimiter: {}".format(area, perimiter))

    print("Number of contours: {}".format(len(contour_list)))
    cv2.imshow("RGB Image Contours", rgb_image)  
    cv2.imshow("Black Image Contours", black_image)  

def get_contour_center(contour):
    M = cv2.moments(contour)
    cx = -1
    cy = -1 
    if (M['m00'] != 0):
        cx = int(M['m10']/M['m00'])
        cy = int(M['m01']/M['m00'])
    return cx, cy

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
    contour_list = get_all_contours(binary_image_mask)

    # Step 4: Draw the contour onto the image
    draw_ball_contour(binary_image_mask, rgb_image, contour_list)

    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()  