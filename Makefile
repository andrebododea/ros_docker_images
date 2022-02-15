# Makefile for general ros project usage


# Command line arguments
ENABLE_GPU ?= false        # Enable the use of GPU devices (set to true if you have an NVIDIA GPU)

# Docker variables
IMAGE_NAME = turtlebot3
CORE_DOCKERFILE = ${PWD}/docker/dockerfile_nvidia_ros
BASE_DOCKERFILE = ${PWD}/docker/dockerfile_tb3_base
OVERLAY_DOCKERFILE = ${PWD}/docker/dockerfile_tb3_overlay

# Mount directories in the container's overlay_ws to local directories, using volumes. Also set up X11 forwarding. Setting all permissions to read-write
# Command is structured as: --volume=PATH_TO_LOCAL_DIRECTORY_TO_MOUNT_TO : PATH_TO_WORKSPACE_INSIDE_CONTAINER : OPTIONS (e.g. permissions)
DOCKER_VOLUMES = \
		--volume="${PWD}/tb3_autonomy":"/overlay_ws/src/tb3_autonomy":rw $\
		--volume="${PWD}/tb3_worlds":"/overlay_ws/src/tb3_worlds":rw $\
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"

# Set up docker environment variables
DOCKER_ENV_VARS = \
		--env="NVIDIA_DRIVER_CAPABILITIES=all" $\ 
		--env="DISPLAY" $\ 
		--env="QT_X11_NO_MITSHM=1"

# Depending on args to makefile, set GPU enabled or disabled
ifeq ("${USE_GPU}", "true")
DOCKER_GPU_ARGS = "--gpus all"
endif

# Finally, set a variable to contain the full docker arguments 
DOCKER_ARGS = ${DOCKER_VOLUMES} ${DOCKER_ENV_VARS} ${DOCKER_GPU_VARS}



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
		@docker build -f ${OVERLAY_DOCKERFILE} -t ${IMAGE_NAME}_overlay .

# Kill any running Docker containers
.PHONY: kill 
kill:
		@echo "Closing all running Docker containers:"
		@docker kill $(shell docker ps -q --filter ancestor=${IMAGE_NAME}_overlay)


########
# TASKS #
#######

# Use the host networking scheme. In other words, do not isolate the container's network stack from the Docker host
DOCKER_RUN_CMD = @docker run -it --net=host ${DOCKER_ARGS} ${IMAGE_NAME}_overlay 

# Start a terminal inside the Docker containers
.PHONY: term
term:
		${DOCKER_RUN_CMD} $\
		bash	

# Start basic simulation included with TurtleBot3 packages
.PHONY: sim
sim:
		${DOCKER_RUN_CMD} $\
		roslaunch turtlebot3_gazebo turtlebot3_world.launch	


# Start Terminal for teleoperating the TurtleBot3
.PHONY: teleop
teleop:
		${DOCKER_RUN_CMD} $\
		roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch

# Start own simulation demo world
.PHONY: demo-world
demo-world:
		${DOCKER_RUN_CMD} $\
		# roslaunch tb3_worlds tb3_demo_world.launch