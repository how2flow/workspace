#include <chrono>
#include <functional>
#include <memory>
#include <string>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"

using namespace std::chrono_literals;


class Publisher : public rclcpp::Node
{
public:
  Publisher()
  : Node("cpp_publisher"), count_(0)
  {
    auto qos_profile = rclcpp::QoS(rclcpp::KeepLast(10));
    _publisher_ = this->create_publisher<std_msgs::msg::String>(
      "topic", qos_profile);
    timer_ = this->create_wall_timer(
      1s, std::bind(&Publisher::publish_msg, this));
  }

private:
  void publish_msg()
  {
    auto msg = std_msgs::msg::String();
    msg.data = "msg: " + std::to_string(count_++);
    RCLCPP_INFO(this->get_logger(), "Published message: '%s'", msg.data.c_str());
    _publisher_->publish(msg);
  }
  rclcpp::TimerBase::SharedPtr timer_;
  rclcpp::Publisher<std_msgs::msg::String>::SharedPtr _publisher_;
  size_t count_;
};


int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  auto node = std::make_shared<Publisher>();
  rclcpp::spin(node);
  rclcpp::shutdown();
  return 0;
}
