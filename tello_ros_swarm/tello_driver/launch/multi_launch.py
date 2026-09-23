from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    tello1 = Node(package='tello_driver', executable='tello_driver_main', output='screen', namespace="drone1",
                  parameters=[{'drone_ip': "192.168.2.110"}, {'rasp_port': 50010}, {'cmd_port': 50011}, {'state_port': 50012}, {'video_port': 50013}])
    
    tello2 = Node(package='tello_driver', executable='tello_driver_main', output='screen', namespace="drone2",
                  parameters=[{'drone_ip': "192.168.2.109"}, {'rasp_port': 50020}, {'cmd_port': 50021}, {'state_port': 50022}, {'video_port': 50023}])
    
    tello3 = Node(package='tello_driver', executable='tello_driver_main', output='screen', namespace="drone3",
                  parameters=[{'drone_ip': "192.168.2.105"}, {'rasp_port': 50030}, {'cmd_port': 50031}, {'state_port': 50032}, {'video_port': 50033}])

    tello4 = Node(package='tello_driver', executable='tello_driver_main', output='screen', namespace="drone4",
                  parameters=[{'drone_ip': "192.168.2.104"}, {'rasp_port': 50040}, {'cmd_port': 50041}, {'state_port': 50042}, {'video_port': 50043}])
                    
                    # arguments=['--ros-args', '--log-level', 'debug'])
    # tello2 = Node(package='tello_driver', executable='tello_driver_main', output='screen', namespace="drone2",
    #               parameters=[{'drone_ip': "192.168.10.1"}])  # "192.168.10.1" 192.168.123.158

    nb_agents = 4
    display_tell_state_node = Node(
        package = "tello_controller",
        executable = "display_tello_state.py",
        parameters = [
            {"nb_uavs" : nb_agents}
        ],
    )

    return LaunchDescription([
        tello1,
        tello2,
        tello3,
        tello4,
        display_tell_state_node
    ])
