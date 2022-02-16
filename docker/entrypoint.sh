#!/bin/bash
# Basic entrypoint for ROS / Catkin Docker containers

# Source ROS and Catkin workspaces
source /opt/ros/noetic/setup.bash
if [ -f /turtlebot3_ws/devel/setup.bash ]
then
  echo "source /turtlebot3_ws/devel/setup.bash" >> ~/.bashrc
  source /turtlebot3_ws/devel/setup.bash
fi
if [ -f /overlay_ws/devel/setup.bash ]
then
  echo "source /overlay_ws/devel/setup.bash" >> ~/.bashrc
  source /overlay_ws/devel/setup.bash
fi
echo "Sourced Catkin workspace!"

# Set environment variables
export TURTLEBOT3_MODEL=waffle
export SVGA_VGPU10=0 # Keep Gazebo from exploding

# Execute the command passed into this entrypoint
exec "$@"