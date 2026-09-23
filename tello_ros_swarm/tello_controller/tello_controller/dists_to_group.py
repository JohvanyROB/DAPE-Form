import rclpy
from rclpy.node import Node
from nav_msgs.msg import Odometry
from geometry_msgs.msg import PoseStamped
from std_msgs.msg import Float32MultiArray
import numpy as np


class DistsToGroup(Node):
    def __init__(self):
        Node.__init__(self, "dists_to_group")

        self.dists = [None, None, None, None, None]
        self.dists1 = [None, None, None, None, None]
        self.dists2 = [None, None, None, None, None]
        self.p1 = (None, None, None)
        self.p2 = (None, None, None)
        self.p3 = (None, None, None)
        self.p4 = (None, None, None)
        self.p5 = (None, None, None)
        self.p6 = (None, None, None)
        self.p7 = (None, None, None)
        self.p8 = (None, None, None)
        self.ready_to_publish = False
        self.ready_to_publish1 = False
        self.ready_to_publish2 = False

        self.create_subscription(Odometry, "/drone1/odom", self.pose1_cb, qos_profile=1)
        self.create_subscription(Odometry, "/drone2/odom", self.pose2_cb, qos_profile=1)
        self.create_subscription(Odometry, "/drone3/odom", self.pose3_cb, qos_profile=1)
        self.create_subscription(Odometry, "/drone4/odom", self.pose4_cb, qos_profile=1)
        self.create_subscription(Odometry, "/drone5/odom", self.pose5_cb, qos_profile=1)
        self.create_subscription(Odometry, "/drone6/odom", self.pose6_cb, qos_profile=1)
        self.create_subscription(Odometry, "/drone7/odom", self.pose7_cb, qos_profile=1)
        self.create_subscription(Odometry, "/drone8/odom", self.pose8_cb, qos_profile=1)

        self.pose1_pub = self.create_publisher(PoseStamped, "/drone1/pose", qos_profile=1)
        self.pose2_pub = self.create_publisher(PoseStamped, "/drone2/pose", qos_profile=1)
        self.pose3_pub = self.create_publisher(PoseStamped, "/drone3/pose", qos_profile=1)
        self.pose4_pub = self.create_publisher(PoseStamped, "/drone4/pose", qos_profile=1)
        self.pose5_pub = self.create_publisher(PoseStamped, "/drone5/pose", qos_profile=1)
        self.pose6_pub = self.create_publisher(PoseStamped, "/drone6/pose", qos_profile=1)
        self.pose7_pub = self.create_publisher(PoseStamped, "/drone7/pose", qos_profile=1)
        self.pose8_pub = self.create_publisher(PoseStamped, "/drone8/pose", qos_profile=1)

        self.dists_pub = self.create_publisher(Float32MultiArray, "/dists", qos_profile=1)
        self.create_timer(0.05, self.publish_distances)  #distances are published @ 2Hz

        self.dists_pub1 = self.create_publisher(Float32MultiArray, "/dists1", qos_profile=1)
        self.create_timer(0.05, self.publish_distances1)  #distances are published @ 2Hz

        self.dists_pub2 = self.create_publisher(Float32MultiArray, "/dists2", qos_profile=1)
        self.create_timer(0.05, self.publish_distances2)  #distances are published @ 2Hz
    

    def __del__(self):
        self.get_logger().warn("Shutting down...")
    

    def pose1_cb(self, msg):
        """ Get the current pose of UAV 1 """
        self.p1 = (msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z)    #position of UAV 1
        msg_to_publish = PoseStamped()
        msg_to_publish.header.frame_id = "map"
        msg_to_publish.header.stamp = self.get_clock().now().to_msg()
        msg_to_publish.pose = msg.pose.pose
        self.pose1_pub.publish(msg_to_publish)
    

    def pose2_cb(self, msg):
        """ Get the current pose of UAV 2 """
        self.p2 = (msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z)    #position of UAV 2
        msg_to_publish = PoseStamped()
        msg_to_publish.header.frame_id = "map"
        msg_to_publish.header.stamp = self.get_clock().now().to_msg()
        msg_to_publish.pose = msg.pose.pose
        self.pose2_pub.publish(msg_to_publish)
    

    def pose3_cb(self, msg):
        """ Get the current pose of UAV 3 """
        self.p3 = (msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z)    #position of UAV 3
        msg_to_publish = PoseStamped()
        msg_to_publish.header.frame_id = "map"
        msg_to_publish.header.stamp = self.get_clock().now().to_msg()
        msg_to_publish.pose = msg.pose.pose
        self.pose3_pub.publish(msg_to_publish)


    def pose4_cb(self, msg):
        """ Get the current pose of UAV 4 """
        self.p4 = (msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z)    #position of UAV 4
        msg_to_publish = PoseStamped()
        msg_to_publish.header.frame_id = "map"
        msg_to_publish.header.stamp = self.get_clock().now().to_msg()
        msg_to_publish.pose = msg.pose.pose
        self.pose4_pub.publish(msg_to_publish)
        if self.p1[0] != None and self.p2[0] != None and self.p3[0] != None:    #all positions are available     ##Change for every simulation!!!!!!!!!!!!!
            self.compute_distances()    #compute distances btw UAV4 and the others
            if not self.ready_to_publish:   #if no distances have been published yet
                self.ready_to_publish = True


    def pose5_cb(self, msg):
        """ Get the current pose of UAV 3 """
        self.p5 = (msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z)    #position of UAV 5
        msg_to_publish = PoseStamped()
        msg_to_publish.header.frame_id = "map"
        msg_to_publish.header.stamp = self.get_clock().now().to_msg()
        msg_to_publish.pose = msg.pose.pose
        self.pose5_pub.publish(msg_to_publish)
        if self.p1[0] != None and self.p2[0] != None and self.p3[0] != None:    #all positions are available
            self.compute_distances1()    #compute distances btw UAV5 and the others
            if not self.ready_to_publish1:   #if no distances have been published yet
                self.ready_to_publish1 = True


    def pose6_cb(self, msg):
        """ Get the current pose of UAV 3 """
        self.p6 = (msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z)    #position of UAV 6
        msg_to_publish = PoseStamped()
        msg_to_publish.header.frame_id = "map"
        msg_to_publish.header.stamp = self.get_clock().now().to_msg()
        msg_to_publish.pose = msg.pose.pose
        self.pose6_pub.publish(msg_to_publish)

    def pose7_cb(self, msg):
        """ Get the current pose of UAV 3 """
        self.p7 = (msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z)    #position of UAV 7
        msg_to_publish = PoseStamped()
        msg_to_publish.header.frame_id = "map"
        msg_to_publish.header.stamp = self.get_clock().now().to_msg()
        msg_to_publish.pose = msg.pose.pose
        self.pose7_pub.publish(msg_to_publish)  
        
    def pose8_cb(self, msg):
        """ Get the current pose of UAV 3 """
        self.p8 = (msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z)    #position of UAV 8
        msg_to_publish = PoseStamped()
        msg_to_publish.header.frame_id = "map"
        msg_to_publish.header.stamp = self.get_clock().now().to_msg()
        msg_to_publish.pose = msg.pose.pose
        self.pose8_pub.publish(msg_to_publish)
        if self.p1[0] != None and self.p2[0] != None and self.p3[0] != None:    #all positions are available
            self.compute_distances2()    #compute distances btw UAV5 and the others
            if not self.ready_to_publish2:   #if no distances have been published yet
                self.ready_to_publish2 = True    
        
    
    def compute_distances(self):
        """ Noisy distances btw the 4th uav and the 3 others """
        d1 = self.dist_3D(self.p1, self.p4)
        d2 = self.dist_3D(self.p2, self.p4)
        d3 = self.dist_3D(self.p3, self.p4)
        d4 = self.dist_3D(self.p5, self.p4)
        d5 = self.dist_3D(self.p6, self.p4)
        d6 = self.dist_3D(self.p7, self.p4)
        d7 = self.dist_3D(self.p8, self.p4)
        d1_noisy = d1 + np.random.normal(0, 0)  #gaussian noise added
        d2_noisy = d2 + np.random.normal(0, 0)
        d3_noisy = d3 + np.random.normal(0, 0)
        d4_noisy = d4 + np.random.normal(0, 0)
        d5_noisy = d5 + np.random.normal(0, 0)
        d6_noisy = d6 + np.random.normal(0, 0)
        d7_noisy = d7 + np.random.normal(0, 0)
        self.dists = [d1, d2, d3, d4, d5, d6, d7, d1_noisy, d2_noisy, d3_noisy, d4_noisy, d5_noisy, d6_noisy, d7_noisy]

    def compute_distances1(self):
        """ Noisy distances btw the 5th uav and the 3 others """
        d1 = self.dist_3D(self.p1, self.p5)
        d2 = self.dist_3D(self.p2, self.p5)
        d3 = self.dist_3D(self.p3, self.p5)
        d4 = self.dist_3D(self.p4, self.p5)
        d5 = self.dist_3D(self.p6, self.p5)
        d6 = self.dist_3D(self.p7, self.p5)
        d7 = self.dist_3D(self.p8, self.p5)
        d1_noisy = d1 + np.random.normal(0, 0)  #gaussian noise added
        d2_noisy = d2 + np.random.normal(0, 0)
        d3_noisy = d3 + np.random.normal(0, 0)
        d4_noisy = d4 + np.random.normal(0, 0)
        d5_noisy = d5 + np.random.normal(0, 0)
        d6_noisy = d6 + np.random.normal(0, 0)
        d7_noisy = d7 + np.random.normal(0, 0)
        self.dists1 = [d1, d2, d3, d4, d5, d6, d7, d1_noisy, d2_noisy, d3_noisy, d4_noisy, d5_noisy, d6_noisy, d7_noisy]

    def compute_distances2(self):
        """ Noisy distances btw the 5th uav and the 3 others """
        d1 = self.dist_3D(self.p1, self.p8)
        d2 = self.dist_3D(self.p2, self.p8)
        d3 = self.dist_3D(self.p3, self.p8)
        d4 = self.dist_3D(self.p4, self.p8)
        d5 = self.dist_3D(self.p5, self.p8)
        d6 = self.dist_3D(self.p6, self.p8)
        d7 = self.dist_3D(self.p7, self.p8)
        d1_noisy = d1 + np.random.normal(0, 0)  #gaussian noise added
        d2_noisy = d2 + np.random.normal(0, 0)
        d3_noisy = d3 + np.random.normal(0, 0)
        d4_noisy = d4 + np.random.normal(0, 0)
        d5_noisy = d5 + np.random.normal(0, 0)
        d6_noisy = d6 + np.random.normal(0, 0)
        d7_noisy = d7 + np.random.normal(0, 0)
        self.dists2 = [d1, d2, d3, d4, d5, d6, d7, d1_noisy, d2_noisy, d3_noisy, d4_noisy, d5_noisy, d6_noisy, d7_noisy]

    
    def dist_3D(self, p1, p2):
        """ Return the length of a 3D vector considering 2 points p1 and p2 """
        return np.sqrt( (p2[0] - p1[0])**2 + (p2[1] - p1[1])**2 + (p2[2] - p1[2])**2 )
    

    def publish_distances(self):
        """ Publish distances to the topic /dists """
        if self.ready_to_publish:
            msg = Float32MultiArray()   #array of floats
            msg.data = self.dists   #assign distances to msg component
            self.dists_pub.publish(msg) #publish msg
            # self.get_logger().info(f"d1: {self.dists[0]:.2f}, d2: {self.dists[1]:.2f}, d3: {self.dists[2]:.2f}")    #display distances if needed

    def publish_distances1(self):
        """ Publish distances to the topic /dists1 """
        if self.ready_to_publish1:
            msg = Float32MultiArray()   #array of floats
            msg.data = self.dists1   #assign distances to msg component
            self.dists_pub1.publish(msg) #publish msg

    def publish_distances2(self):
        """ Publish distances to the topic /dists1 """
        if self.ready_to_publish2:
            msg = Float32MultiArray()   #array of floats
            msg.data = self.dists2   #assign distances to msg component
            self.dists_pub2.publish(msg) #publish msg

    

def main(args=None):
    rclpy.init(args=args)

    node = DistsToGroup()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()