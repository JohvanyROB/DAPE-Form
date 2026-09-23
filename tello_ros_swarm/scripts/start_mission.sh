printf "UAVs are taking off...\n"
ros2 service call /drone1/tello_action tello_msgs/srv/TelloAction "{cmd : 'takeoff'}"
ros2 service call /drone2/tello_action tello_msgs/srv/TelloAction "{cmd : 'takeoff'}"

printf "\nClock publisher node starting\n"
ros2 run tello_controller clock_publisher.py
# ros2 run tello_controller dists_to_group.py
