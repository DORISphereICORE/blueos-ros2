
export SPINNAKER_GENTL64_CTI=/opt/ros/${ROS_DISTRO}/lib/spinnaker-gentl/Spinnaker_GenTL.cti
ros2 launch spinnaker_camera_driver driver_node.launch.py camera_name:="color_camera"
