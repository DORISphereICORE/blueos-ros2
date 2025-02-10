ARG ROS_DISTRO=humble
FROM ros:$ROS_DISTRO-ros-base

RUN apt-get update \
    && apt-get install -q -y --no-install-recommends \
    tmux nano nginx wget netcat \
    ros-${ROS_DISTRO}-mavros ros-${ROS_DISTRO}-mavros-extras ros-${ROS_DISTRO}-mavros-msgs \
    ros-${ROS_DISTRO}-geographic-msgs \
    python3-dev python3-pip \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir setuptools pip packaging -U

COPY ros2_ws /home/ros2_ws
RUN cd /home/ros2_ws/ \
    && python3 -m pip install --no-cache-dir -r src/mavros_control/requirements.txt \
    && . "/opt/ros/${ROS_DISTRO}/setup.sh" \
    && colcon build --symlink-install \
    && ros2 run mavros install_geographiclib_datasets.sh \
    && echo "source /ros_entrypoint.sh" >> ~/.bashrc \
    && echo "source /home/ros2_ws/install/setup.sh " >> ~/.bashrc

# Setup environment variables to configure mavros_control
ENV NAVIGATION_TYPE=0 FOXGLOVE=True

# Setup ttyd for web terminal interface
ADD files/install-ttyd.sh /install-ttyd.sh
RUN bash /install-ttyd.sh && rm /install-ttyd.sh
COPY files/tmux.conf /etc/tmux.conf

RUN mkdir -p /site
COPY files/register_service /site/register_service
COPY files/nginx.conf /etc/nginx/nginx.conf

ADD files/start.sh /start.sh

# Add docker configuration
LABEL version="0.0.2"
LABEL permissions='{\
  "NetworkMode": "host",\
  "HostConfig": {\
    "Binds": [\
      "/dev:/dev:rw",\
      "/usr/blueos/extensions/ros2/:/home/persistent_ws/:rw"\
    ],\
    "Privileged": true,\
    "NetworkMode": "host"\
  },\
  "Env": [\
    "NAVIGATION_TYPE=0", \
    "FOXGLOVE=False" \
  ]\
}'
LABEL authors='[\
  {\
    "name": "Kalvik Jakkala",\
    "email": "itskalvik@gmail.com"\
  }\
]'
LABEL company='{\
  "about": "",\
  "name": "ItsKalvik",\
  "email": "itskalvik@gmail.com"\
}'
LABEL readme="https://raw.githubusercontent.com/itskalvik/blueos-ros2/master/README.md"
LABEL type="other"
LABEL tags='[\
  "ros2",\
  "robot"\
]'

# Keep bash alive even if there is an error
RUN echo "set +e" >> ~/.bashrc
ENTRYPOINT [ "/start.sh" ]