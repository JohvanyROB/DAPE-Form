printf "UAVs are landing...\n"
ros2 service call /drone1/tello_action tello_msgs/srv/TelloAction "{cmd : 'land'}"
ros2 service call /drone2/tello_action tello_msgs/srv/TelloAction "{cmd : 'land'}"
