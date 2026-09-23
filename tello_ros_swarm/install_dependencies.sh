#!/bin/bash

sudo apt update -y

# Install project's dependencies 
sudo apt -y install libasio-dev
sudo apt -y install python3-colcon-common-extensions
sudo apt -y install python3-pip
sudo apt -y install ros-galactic-gazebo-ros-pkgs ros-galactic-tf-transformations ros-galactic-tf2-tools ros-galactic-teleop-twist-keyboard ros-galactic-xacro ros-galactic-teleop-twist-joy joystick ros-galactic-image-transport-plugins
sudo apt install -y ros-galactic-gazebo-ros-pkgs ros-galactic-cv-bridge ros-galactic-camera-calibration-parsers
pip3 install transforms3d imutils pandas tensorflow opencv-contrib-python==4.7.0.72

echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc

source /opt/ros/galactic/setup.bash
cd ~/tello_swarm_ws && colcon build --symlink-install
echo "source ~/tello_swarm_ws/install/setup.bash" >> ~/.bashrc