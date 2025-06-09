#!/bin/bash

NODE_NAME="mono_camera"
PARAM_NAME="frame_rate"
NEW_VALUE="10"

# Wait for the node to be initialized
while ! ros2 param list | grep -q "$NODE_NAME"; do
    echo "Waiting for $NODE_NAME to start..."
    sleep 2
done

echo "$NODE_NAME is running. Changing parameter..."

# Set the parameter
ros2 param set $NODE_NAME $PARAM_NAME $NEW_VALUE

echo "Parameter $PARAM_NAME changed to $NEW_VALUE."

NODE_NAME="color_camera"

# Wait for the node to be initialized
while ! ros2 param list | grep -q "$NODE_NAME"; do
    echo "Waiting for $NODE_NAME to start..."
    sleep 2
done

echo "$NODE_NAME is running. Changing parameter..."

# Set the parameter
ros2 param set $NODE_NAME $PARAM_NAME $NEW_VALUE

echo "Parameter $PARAM_NAME changed to $NEW_VALUE."

