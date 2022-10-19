#include <functional>
#include <memory>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"

using std::placeholders::_1;


class Subscriber : public rclcpp::Node
{
public:
  Subscriber()
  : Node("cpp_subscriber")
  {
    auto qos_profile = rclcpp::QoS(rclcpp::KeepLast(10));
    _subscriber_ = this->create_subscription<std_msgs::msg::String>(
      "topic",
      qos_profile,
      std::bind(&Subscriber::subscribe_topic_message, this, _1));
  }

private:
  void subscribe_topic_message(const std_msgs::msg::String::SharedPtr msg) const
  {
    RCLCPP_INFO(this->get_logger(), "Received message: '%s'", msg->data.c_str());
  }
  rclcpp::Subscription<std_msgs::msg::String>::SharedPtr _subscriber_;
};


int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  auto node = std::make_shared<Subscriber>();
  rclcpp::spin(node);
  rclcpp::shutdown();
  return 0;
}
