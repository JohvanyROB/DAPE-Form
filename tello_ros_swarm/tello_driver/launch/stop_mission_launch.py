from launch import LaunchDescription
from launch_ros.actions import Node
from launch.actions import ExecuteProcess
from launch.substitutions import FindExecutable


def generate_launch_description():
    nb_uavs = 4

    land_cmds = []
    for i in range(nb_uavs):
        land_cmds.append(
            ExecuteProcess(
                cmd=[
                    FindExecutable(name="ros2"),
                    "service",
                    "call",
                    f"/drone{i+1}/tello_action",
                    "tello_msgs/srv/TelloAction",
                    "{cmd : land}"
                ],
                output="screen"
            )
        )
    

    ld = LaunchDescription()
    
    for action in land_cmds:
        ld.add_action(action)

    return ld