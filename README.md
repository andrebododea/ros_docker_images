# ROS Docker Images
My collection of images and related build tools for building and running ROS projects (and graphical tools such as RViz and Gazebo) directly from Docker containers.

# Motivation
I find that when I try to spin up on a side project, I get tons of library conflicts due to version mismatches and other such issues with libraries that I use for my professional projects. To resolve that issue and speed up my spin-up time when working personal ROS projects, I've decided to dockerize the environment that I typically use for those purposes. This will initially the Turtlebot3 dependencies, but should be flexible enough to be easily extended to new projects in the future. 

My inspiration for this particular method of implementing the containers is [this](https://roboticseabass.com/2021/04/21/docker-and-ros/) blog post by Sebastian Castro. I have leaned heavily on his design[^1] for my own implementation including the use of makefiles and a layered Docker image architecture. There are some other useful links on getting GPU support to work with ROS graphical applications (Gazebo, RViz, etc) in a Docker container[^2] [^3]. I also plan to tightly integrate the Docker environment with VSCode in the future for a more streamlined development environment[^4].

# Architecture Overview
In this setup there will be three images, each layering onto the previous one. 

<img src="https://user-images.githubusercontent.com/9446419/153943467-6ba79a96-e157-4425-bcdf-5b34aabd6225.png" width="500">

The big win with this way of modularly putting together a stack of images is that it's simple to to upgrade/downgrade the Ubuntu image separately from the ROS image, and also making it easy to change around the base image containing project-specific libraries depending on what the project needs are. For example, swapping out Turtlebot3 with an OpenMANIPULATOR arm is done by simply selecting a new base image to stack on top of the OS and ROS images. 

# Future TO-DO's
- Basic functionality works great with GPU accel
- Need more documentation on initial setup involving:
    -- What libraries are needed to be installed locally to enable this Docker container setup to work with X11 forwarding:
        --- Docker-CE and then 
                ---- Make sure your $USER variable is set:
                ---- $ echo $USER
                ---- $ sudo usermod -aG docker $USER
                ---- logout
                ---- Upon login, restart the docker service
                ---- $ sudo systemctl restart docker
                ---- $ docker ps
        --- Latest NVIDIA Drivers
        --- NVIDIA Container Toolkit
        --- xhost
    -- How to verify drivers and libraries are installed
    -- How to perform a minimal test
    
- Need to work on robustifying the makefile and ensuring that args are handled a bit more gracefully and with more flexibility.
- Long-term goal is to create a "base" repository - maybe a git submodule or a dockerhub location - that contains these images. And then modifying the makefile to be easily extensible when starting a new project. Ideally the steps would be:
    -- Pick the base image that you want (tb3_base or otherwise) and fetch them somehow
    -- Create a new makefile with the commands that are relevant to your project
    -- Execute the build commands to set up the docker environment.
    -- Run the commands that you want and go!

[^1]: Sebastian Castro's Turtlebot3 integration with Docker can be found [here](https://github.com/sea-bass/turtlebot3_behavior_demos)
[^2]: [ROS Hardware Acceleration with Docker using nvidia-docker-2](http://wiki.ros.org/action/login/docker/Tutorials/Hardware%20Acceleration#nvidia-docker2)
[^3]: [A slightly outdated repo that contains lots of good info on integrating ROS graphical applications with Docker using NVIDIA hardware acceleration](https://github.com/koenlek/docker_ros_nvidia)
[^4]: There's a good ROS World 2021 talk ["VSCode, Docker and ROS2"](https://vimeo.com/649658020/9ef0b5ec32) by Allison Thackerton which focuses on integrating a ROS/ROS2 Docker environment with VS Code