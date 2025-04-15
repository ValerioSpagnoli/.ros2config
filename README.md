# ROS 2 Run Commands - `ros2rc`

This repository contains a shell script (`ros2rc`) designed to simplify and streamline common ROS 2 development tasks. It provides a set of convenient aliases and functions for building workspaces, managing ROS 2 environment sourcing, cleaning build artifacts, configuring DDS settings, setting the ROS_DOMAIN_ID, and more.


## Installation

1.  **Clone the repository:**
    Clone this repository to a location of your choice. A common practice is to place configuration files in a hidden directory in your home folder.

    ```bash
    git clone https://github.com/ValerioSpagnoli/.ros2config.git ~/.ros2config
    echo "source ~/.ros2config/ros2rc" >> ~/.$(basename $SHELL)rc 
    source ~/.$(basename $SHELL)rc
    ```

2.  **(Optional) Customize Defaults:**
    Review the `~/.ros2config/ros2rc` file. You might want to adjust default settings like:
    * `ROS_WS`: Change `~/ros2_ws` if your ROS 2 workspace is located elsewhere.
    * Default `RMW_IMPLEMENTATION`.
    * Default `ROS_DOMAIN_ID`.
    * Paths for DDS configuration files (`CYCLONEDDS_URI`, `FASTRTPS_DEFAULT_PROFILES_FILE`).

## Available Commands

The following commands (aliases and functions) are made available by sourcing the `ros2rc` script:

* **`ros2rc`**: Handles operations on the `ros2rc` configuration file itself.
    * `ros2rc -s` or `ros2rc --source`: Re-sources the `~/.ros2config/ros2rc` file.
    * `ros2rc -n` or `ros2rc --nano`: Opens `~/.ros2config/ros2rc` for editing with nano.
    * `ros2rc -g` or `ros2rc --gedit`: Opens `~/.ros2config/ros2rc` for editing with gedit.
    * `ros2rc -c` or `ros2rc --code`: Opens `~/.ros2config/ros2rc` for editing with VS Code (`code` command).

* **`ros2source`**: Sources both the global ROS 2 setup file (`/opt/ros/$ROS_DISTRO/setup.*`) and the local workspace setup file (`~/ros2_ws/install/local_setup.*`).

* **`ros2build`**: Builds the ROS 2 workspace (`~/ros2_ws`) using `colcon build`. Run from any directory.
    * `ros2build -s` or `--seq`: Build packages sequentially.
    * `ros2build -w <num>` or `--workers <num>`: Specify the number of parallel workers.
    * `ros2build -j <num>` or `--jobs <num>`: Specify the number of Make jobs (cores) to use per package.
    * `ros2build -p <pkg1,pkg2,...>` or `--pkg <pkg1,pkg2,...>`: Build only the specified package(s).
    * `ros2build -e <pkg1,pkg2,...>` or `--exclude <pkg1,pkg2,...>`: Exclude specific package(s) from the build.
    * `ros2build -r 0` or `--release 0`: Disable building with `CMAKE_BUILD_TYPE=Release`. (Release is enabled by default).

* **`ros2clean`**: Removes build artifacts from the workspace (`~/ros2_ws`). Run from any directory.
    * `ros2clean -a` or `--all`: Removes the entire `build`, `install`, and `log` directories and clears relevant environment variables.
    * `ros2clean -p <pkg>` or `--pkg <pkg>`: Removes the build, install, and log artifacts for a specific package.

* **`ros2domain`**: Manages the `ROS_DOMAIN_ID` environment variable.
    * `ros2domain`: Shows the current `ROS_DOMAIN_ID`.
    * `ros2domain -p <num>` or `--perm <num>`: Sets the `ROS_DOMAIN_ID` permanently (updates `~/.ros2config/ros2rc` and sources it). Requires a number between 0 and 232.
    * `ros2domain -t <num>` or `--temp <num>`: Sets the `ROS_DOMAIN_ID` temporarily for the current shell session. Requires a number between 0 and 232.

* **`ros2dds`**: Manages the RMW (DDS) implementation (`RMW_IMPLEMENTATION`) environment variable permanently.
    * `ros2dds`: Shows the current DDS implementation being used.
    * `ros2dds -c` or `--cyclone`: Sets the DDS implementation to CycloneDDS (`rmw_cyclonedds_cpp`) permanently (updates `~/.ros2config/ros2rc` and sources it).
    * `ros2dds -f` or `--fastrtps`: Sets the DDS implementation to Fast RTPS (`rmw_fastrtps_cpp`) permanently.
    * `ros2dds -z` or `--zenoh`: Sets the DDS implementation to Zenoh (`rmw_zenoh_cpp`) permanently.
    * `ros2dds -h` or `--help`: Shows help for the `ros2dds` command.

* **`ros2lh`**: Manages the `ROS_LOCALHOST_ONLY` environment variable and the multicast setting on the loopback network interface.
    * `ros2lh`: Shows the current `ROS_LOCALHOST_ONLY` setting.
    * `ros2lh -e` or `--enable`: Sets `ROS_LOCALHOST_ONLY=1` permanently, enables multicast on `lo` (requires sudo), and sources `ros2rc`.
    * `ros2lh -d` or `--disable`: Sets `ROS_LOCALHOST_ONLY=0` permanently, disables multicast on `lo` (requires sudo), and sources `ros2rc`.
    * `ros2lh -h` or `--help`: Shows help for the `ros2lh` command.

* **`foxglove-bridge`**: Alias to launch the Foxglove Bridge with an increased send buffer limit (`ros2 launch foxglove_bridge foxglove_bridge_launch.xml send_buffer_limit:=300000000`).

* **`teleop`**: Alias to run the keyboard teleoperation node (`ros2 run teleop_twist_keyboard teleop_twist_keyboard`).

* **`tf2`**: Generates a PDF (`~/ros2_ws/frames.pdf`) of the TF2 frame tree using `tf2_tools view_frames` and opens it with `evince`.
    * `tf2 -t <seconds>`: Specify the duration (default is 2 seconds) for which to listen to TF frames.

* **`ros2conf`**: Displays the current ROS 2 configuration settings detected by the script (Username, Shell, Distro, Domain ID, DDS, Localhost Only).

* **`ros2hz`**: Measures and displays the publishing frequency of a ROS 2 topic using the `zed_topic_benchmark` tool (requires the `zed-ros2-examples` package to be installed).
    * `ros2hz <topic_name>`: The topic to monitor (required).
    * `ros2hz <topic_name> -w <size>`: Set the window size for averaging frequency.
    * `ros2hz <topic_name> -n <node_name>`: Set a custom node name for the benchmark tool.

* **`ros2help`**: Shows the list of available custom commands defined in `ros2rc`.
