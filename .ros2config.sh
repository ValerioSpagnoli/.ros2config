source /opt/ros/iron/setup.$CURRENT_SHELL


#| FUNCTIONS |#
function ros2build() {
    CURRENT_DIR=$(pwd)

    cd ~/ros2_ws
    case $1 in
        -s|--seq) colcon build --symlink-install --executor sequential && source install/local_setup.$CURRENT_SHELL;;
        -j|--jobs) colcon build --symlink-install --parallel-workers $2 && source install/local_setup.$CURRENT_SHELL;;
        -p|--pkg) colcon build --symlink-install --packages-select $2 && source install/local_setup.$CURRENT_SHELL;;
        -h|--help) 
            echo "Usage: ros2build [-s|--seq] [-j <num>|--jobs <num>] [-p <pkg>|--pkg <pkg>]"
            echo "  -s|--seq:  to build one package at time (sequentially)"
            echo "  -j|--jobs: to specify the number of core used to build"
            echo "  -p|--pkg:  to specify which package to build"
            echo "Only one flag can be used.\n";;
        *) colcon build --symlink-install;;
    esac
    cd $CURRENT_DIR
}

function ros2sourceGlobal() {
    source /opt/ros/$ROS_DISTRO/setup.$CURRENT_SHELL
}

function ros2sourceLocal() {
    CURRENT_DIR=$(pwd)

    cd ~/ros2_ws
    source install/local_setup.$CURRENT_SHELL
    
    cd $CURRENT_DIR
}

function ros2source(){
    ros2sourceGlobal
    ros2sourceLocal
}

function ros2clean() {
    CURRENT_DIR=$(pwd)

    cd ~/ros2_ws
    rm -rf build install log
    export AMENT_PREFIX_PATH=''
    export CMAKE_PREFIX_PATH=''
    export COLCON_PREFIX_PATH=''

    cd $CURRENT_DIR

    ros2sourceGlobal
}

function ros2domain() {
    case $1 in
        -p|--perm) 
            sed -i "s/ROS_DOMAIN_ID=$ROS_DOMAIN_ID/ROS_DOMAIN_ID=$2/g" ~/.ros2config && sourceRos2config
            echo "ROS_DOMAIN_ID permanently set to $2";;
        -t|--temp) 
            export ROS_DOMAIN_ID=$2
            echo "ROS_DOMAIN_ID temporarily set to $2";;
        -h|--help) 
            echo "Usage: ros2domain [-p <num>|--perm <num>] [-t <num>|--temp <num>]"
            echo "  -p|--perm: to set the domain id permanently"
            echo "  -t|--temp: to set the domain id temporarily"
            echo "Only one flag can be used.\n";;
        *) echo "ROS_DOMAIN_ID=$ROS_DOMAIN_ID";;
    esac
}

function ros2dds() {
    FASTRTPS_DDS="rmw_fastrtps_cpp"
    CYCLONE_DDS="rmw_cyclonedds_cpp"
    case $1 in
        -c|--cyclone) 
            sed -i "s/RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION/RMW_IMPLEMENTATION=$CYCLONE_DDS/g" ~/.ros2config && sourceRos2config
            echo "DDS implementation set to $CYCLONE_DDS";;
        -f|--fastrtps) 
            sed -i "s/RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION/RMW_IMPLEMENTATION=$FASTRTPS_DDS/g" ~/.ros2config && sourceRos2config
            echo "DDS implementation set to $FASTRTPS_DDS";;
        -h|--help)
            echo "Usage: ros2dds [-c|--cyclone] [-f|--fastrtps]"
            echo "  -c|--cyclone: to set the DDS implementation to Cyclone DDS"
            echo "  -f|--fastrtps: to set the DDS implementation to FastRTPS DDS"
            echo "Only one flag can be used.\n";;
        *) echo "DDS implementation: $RMW_IMPLEMENTATION";;
    esac
}

function ros2help() {
    echo "Available commands:"
    echo "  ros2configNano:   to edit the configuration file with nano"
    echo "  ros2configGedit:  to edit the configuration file with gedit"
    echo "  ros2configSource: to source ~/.ros2config"
    echo "  ros2build:        to build the workspace"
    echo "  ros2source:       to source /opt/ros/$ROS_DISTRO/setup.$CURRENT_SHELL and ~/ros2_ws/install/local_setup.$CURRENT_SHELL"
    echo "  ros2sourceGlobal: to source /opt/ros/$ROS_DISTRO/setup.$CURRENT_SHELL"
    echo "  ros2sourceLocal : to source ~/ros2_ws/install/local_setup.$CURRENT_SHELL" 
    echo "  ros2clean:        to clean the workspace"
    echo "  ros2domain:       to set the domain id"
    echo "  ros2dds:          to set the DDS implementation"
    echo "  foxgloveBridge:   to launch the foxglove bridge"
}


#| ALIASES |#
alias ros2configNano="nano ~/.ros2config"
alias ros2configGedit="gedit ~/.ros2config"
alias ros2configSource="source ~/.ros2config"

alias foxgloveBridge="ros2 launch foxglove_bridge foxglove_bridge_launch.xml send_buffer_limit:=300000000"
alias ros2build="ros2build"
alias ros2source="ros2source"
alias ros2sourceGlobal="ros2sourceGlobal"
alias ros2sourceLocal="ros2sourceLocal"
alias ros2clean="ros2clean"
alias ros2domain="ros2domain"
alias ros2dds="ros2dds"
alias ros2help="ros2help"


#| ENVIRONMENT VARIABLES |#
CURRENT_SHELL=$(basename $SHELL)
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export CYCLONEDDS_URI=~/ros2_ws/dds_config/cyclone_dds_config.xml
export FASTRTPS_DEFAULT_PROFILES_FILE=~/ros2_ws/dds_config/fast_rtps_dds_config.xml
export ROS_DOMAIN_ID=100
