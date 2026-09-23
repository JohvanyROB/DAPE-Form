import os, xacro

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.actions import IncludeLaunchDescription, DeclareLaunchArgument, TimerAction
from launch_ros.actions import Node



def generate_launch_description():
    simu_pkg = get_package_share_directory("tello_gazebo")
    xacro_file = os.path.join(get_package_share_directory("tello_description"), "xacro", "tello.xacro")
    base_colors = ("Blue", "Yellow", "Green", "Orange", "White", "Red", "Gray", "Blue")

    robots = [
        {"name" : "drone1", "x" : -0.5, "y" : 0.5, "yaw": 0.7},
        {"name" : "drone2", "x" : -1, "y" : -1, "yaw": -0.2},  #-1,-1.5,-0.2
        {"name" : "drone3", "x" : 1, "y" : 1, "yaw": 0.2},
        {"name" : "drone4", "x" : 2, "y" : -1, "yaw": -1.7},
        {"name" : "drone5", "x" : 0.5, "y" : -0.5, "yaw": -0.8},
        {"name" : "drone6", "x" : 1.5, "y" : -2, "yaw": -0.3},
        {"name" : "drone7", "x" : -1, "y" : -0.5, "yaw": 0.1},
        {"name" : "drone8", "x" : -1, "y" : 2, "yaw": 0.5}
    ]

    os.environ["GAZEBO_MODEL_PATH"] += os.path.join(simu_pkg, "models")
    # os.environ["GAZEBO_PLUGIN_PATH"] += os.pathsep + os.path.join(os.path.expanduser("~"), "GazeboPlugin", "export")
    # os.environ["GAZEBO_MASTER_URI"] = "http://192.168.73.156:14581"
    # os.environ["ROS_DOMAIN_ID"] = "8"   #export ROS_DOMAIN_ID=8 in the terminal


    gazebo_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(get_package_share_directory("gazebo_ros"), "launch", "gazebo.launch.py")
        )
    )
    nb_agents = 3

    spawn_robots_cmds = []
    for robot in robots[:nb_agents]:
        spawn_robots_cmds.append(
            Node(
                package = "gazebo_ros",
                executable = "spawn_entity.py",
                arguments = [
                    "-entity", robot["name"], 
                    "-topic", f"/{robot['name']}/robot_description",
                    "-x", str(robot["x"]), 
                    "-y", str(robot["y"]),
                    "-Y", str(robot["yaw"]),
                    "-robot_namespace", robot["name"]
                ],
            )         
        )
    
    robot_state_pub_cmds = []
    for i, robot in enumerate(robots[:nb_agents]):
        robot_state_pub_cmds.append(
             Node(
                package = "robot_state_publisher",
                executable = "robot_state_publisher",
                namespace = robot["name"],
                parameters = [
                    {"robot_description": xacro.process_file(xacro_file, mappings={"base_color_arg": base_colors[i], "suffix": f'{i+1}', "cam_needed": "false"}).toxml()},
                    {"frame_prefix" : f"{robot['name']}/"}
                ]
            )
        )
    
    dist_node = Node(
        package = "tello_controller",
        executable = "dists_to_group.py"
    )

    #display_tell_state_node = Node(
    #    package = "tello_controller",
    #    executable = "display_tello_state.py",
    #    parameters = [
    #        {"nb_uavs" : nb_agents}
    #    ],
    #)


    #*************************************************************    
    ld = LaunchDescription()

    ld.add_action(
        DeclareLaunchArgument(
            "world",
            default_value = os.path.join(simu_pkg, "worlds", "swarm_1.world"),
            description = "World file to use for the simulation"
        )
    )

    ld.add_action(
        DeclareLaunchArgument(
            "verbose",
            default_value = "true",
            description = "Increase messages written to terminal"
        )
    )

    ld.add_action(gazebo_launch)

    for spawn_robot in spawn_robots_cmds[:nb_agents]:
        ld.add_action(spawn_robot)
    
    for robot_state_pub in robot_state_pub_cmds[:nb_agents]:
        ld.add_action(robot_state_pub)
    
    ld.add_action(dist_node)
    #ld.add_action(display_tell_state_node)
    
    return ld