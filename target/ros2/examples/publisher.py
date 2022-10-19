import rclpy
from rclpy.node import Node
from rclpy.qos import QoSProfile
from std_msgs.msg import String

class Publisher(Node):

    def __init__(self):
        super().__init__('py_publisher')
        qos_profile = QoSProfile(depth=10)
        self.publisher = self.create_publisher(String, 'topic', qos_profile)
        self.timer = self.create_timer(1, self.publish_msg)
        self.count = 0

    def publish_msg(self):
        msg = String()
        msg.data = 'msg: {0}'.format(self.count)
        self.publisher.publish(msg)
        self.get_logger().info('Published message: {0}'.format(msg.data))
        self.count += 1

def main(args=None):
    rclpy.init(args=args)
    node = Publisher()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        node.get_logger().info('Keyboard Interrupt (SIGINT)')
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
