import rclpy
from rclpy.node import Node
from rosgraph_msgs.msg import Clock


class ClockPublisher(Node):
    def __init__(self):
        Node.__init__(self, "clock_publisher")
        self.clock_pub = self.create_publisher(Clock, "/clock", qos_profile=1)
        self.t_init = self.get_clock().now().nanoseconds    #initial time
        self.create_timer(0.1, self.publish_clock)
    

    def publish_clock(self):
        msg = Clock()
        # msg.clock = self.get_clock().now().to_msg()
        t_now = self.get_clock().now().nanoseconds
        sec = (t_now - self.t_init) // 1000000000
        nan = (t_now - self.t_init) % 1000000000
        msg.clock.sec = int(sec)
        msg.clock.nanosec = int(nan)
        self.clock_pub.publish(msg)
        # self.get_logger().info(f"{(self.get_clock().now() - self.t_init).}")
    

def main(args=None):
    rclpy.init(args=args)

    node = ClockPublisher()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()