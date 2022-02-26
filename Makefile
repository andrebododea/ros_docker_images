# Makefile for general ros project usage
# Refer here for how to get NVIDIA support with Docker: http://wiki.ros.org/action/login/docker/Tutorials/Hardware%20Acceleration#nvidia-docker2

# Another useful link: https://github.com/koenlek/docker_ros_nvidia


# Docker variables
IMAGE_NAME = turtlebot3
CORE_DOCKERFILE = ${PWD}/docker/dockerfile_nvidia_ros
BASE_DOCKERFILE = ${PWD}/docker/dockerfile_tb3_base
OVERLAY_DOCKERFILE = ${PWD}/docker/dockerfile_tb3_overlay


# Mount directories in the container's overlay_ws to local directories, using volumes. Also set up X11 forwarding. Setting all permissions to read-write
# Command is structured as: --volume=PATH_TO_LOCAL_DIRECTORY_TO_MOUNT_TO : PATH_TO_WORKSPACE_INSIDE_CONTAINER : OPTIONS (e.g. permissions)
DOCKER_VOLUMES = \
		--volume="${PWD}/tb3_autonomy":"/overlay_ws/src/tb3_autonomy":rw $\
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" 
 

# Set up docker environment variables
DOCKER_ENV_VARS = \
		--env="DISPLAY" $\ 
		--env="QT_X11_NO_MITSHM=1" $\
		--device="/dev/dri:/dev/dri"

# Depending on args to makefile, set GPU enabled or disabled
DOCKER_GPU_ARGS = --gpus="all" --env="NVIDIA_VISIBLE_DEVICES=all" --env="NVIDIA_DRIVER_CAPABILITIES=all" --env="DISPLAY" --env="QT_X11_NO_MITSHM=1"

# Finally, set a variable to contain the full docker arguments 
DOCKER_ARGS = ${DOCKER_VOLUMES} ${DOCKER_ENV_VARS} ${DOCKER_GPU_ARGS}



#########
# SETUP #
#########

# Build the core image
.PHONY: build-core
build-core:
		@docker build -f ${CORE_DOCKERFILE} -t nvidia_ros .

# Build the base image (depends on core image build)
.PHONY: build-base
build-base: build-core # start by building core, then go on to build base
		@docker build -f ${BASE_DOCKERFILE} -t ${IMAGE_NAME}_base .

# Build the overlay image (depends on base image build)
.PHONY: build
build: build-base # start by building base (which subsequently builds core), then go on to build the overlay image
		@docker build --no-cache -f ${OVERLAY_DOCKERFILE} -t ${IMAGE_NAME}_overlay .

# Kill any running Docker containers
.PHONY: kill 
kill:
		@echo "Closing all running Docker containers:"
		@docker kill $(shell docker ps -q --filter ancestor=${IMAGE_NAME}_overlay)


########
# TASKS #
#######

# Set up xhost for docker to allow x11 forwarding to work
# Use the host networking scheme. In other words, do not isolate the container's network stack from the Docker host
DOCKER_RUN_CMD = @xhost +local:docker &> /dev/null && docker run -it --net=host ${DOCKER_ARGS} ${IMAGE_NAME}_overlay 

# Start a terminal inside the Docker containers
.PHONY: term
term:
		${DOCKER_RUN_CMD} bash	

# Start Terminal for teleoperating the TurtleBot3
.PHONY: tb3teleop
tb3teleop:
		${DOCKER_RUN_CMD} roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch


# Start Terminal for the TurtleBot3
.PHONY: tb3
tb3:
		${DOCKER_RUN_CMD} roslaunch turtlebot3_gazebo turtlebot3_empty_world.launch

# Start Terminal for the TurtleBot3 maze
.PHONY: tb3maze
tb3maze:
		${DOCKER_RUN_CMD} roslaunch turtlebot3_gazebo turtlebot3_world.launch

# Start Terminal for the TurtleBot3 house
.PHONY: tb3house
tb3house:
		${DOCKER_RUN_CMD} roslaunch turtlebot3_gazebo turtlebot3_house.launch
		

# Start Terminal for the TurtleBot3 fake
.PHONY: tb3fake
tb3fake:
		${DOCKER_RUN_CMD} roslaunch turtlebot3_fake turtlebot3_fake.launch