# ros_docker_images
My images for building and running ROS projects in Docker containers 

# Inspiration
At my job, my local Linux environment has a ton of libraries installed on it to support our code base in ROS. I find that when I try to spin up on a side project on the same computer during my off-hours, many libraries conflict due to version mismatches and other such issues. To resolve that issue and speed up my spin-up time when starting a new personal ROS project, I've decided to dockerize the environment that I typically use for those purposes. This will initially be set up to support a Turtlebot3 project, but should be flexible enough to be easily extended to new projects in the future. It should also allow me to easily swap between ROS1 and ROS2 as needed for different projects. 

My inspiration for this particular method of implementing the containers is [this blog post](https://roboticseabass.com/2021/04/21/docker-and-ros/) by [Sebastian Castro](https://roboticseabass.com/about/). Implementation can be found [here](https://github.com/sea-bass/turtlebot3_behavior_demos). Also gained some inspiration from the ROS World 2021 talk ["VSCode, Docker and ROS2"](https://vimeo.com/649658020/9ef0b5ec32) by Allison Thackerton's which focuses more on integrating a ROS/ROS2 Docker environment with VS Code. 

# Architecture Overview
In this setup there will be three images, each layering onto the previous one. 

<img src="https://user-images.githubusercontent.com/9446419/153943467-6ba79a96-e157-4425-bcdf-5b34aabd6225.png" width="500">

The big win with this way of modularly putting together a stack of images is that it's simple to to upgrade/downgrade the Ubuntu image separately from the ROS image (e.g. Ubuntu 20.04 with ROS1, 18.04 with ROS2, 20.04 with ROS2, etc). It also makes it simple to change around the base image containing project-specific libraries depending on what the project is. For example, swapping out Turtlebot3 with an OpenMANIPULATOR arm is done by simply selecting a new base image to stack on top of the OS and ROS images. It's pretty slick.

Another piece of functionality that this may unlock is the ability to more easily run ROS projects directly on a server, and serve users a simulation via a webpage. This might be a really cool way to demo projects by allowing users to directly interact with demos via Gazebo or Rviz. 

# Implementation Plan

- Implement the base Ubuntu image
- Implement the ROS1 Noetic image
- Implement the Turtlebot3 image
- Successfully run a Turtlebot3 sim demo using the images
- Bonus: Integrate with VS Code?
