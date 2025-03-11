#!/bin/bash

# Constants
curr_directory=$(pwd)
curr_directory+="/.local"

mkdir $curr_directory

# Prompt user for input of the project name
echo "Enter project name: "
read project_name

# Setting up setup.sh function
setupFile() {
    setup_file_path="${curr_directory}/setup.sh"

    echo -e "#!/bin/bash\n" > $setup_file_path
    echo -e "# Rename the session" >> $setup_file_path
    echo -e "tmux rename-session \"${project_name}\"" >> $setup_file_path

    echo -e "\n# Start coding enviroment window" >> $setup_file_path
    echo -e "tmux rename-window -t 1 \"Code\"" >> $setup_file_path
    echo -e "tmux send-keys -t \"Code\" \"vim\" C-m" >> $setup_file_path

    echo -e "\n# Start shell window" >> $setup_file_path
    echo -e "tmux new-window -n \"Terminal\" -t 2 -d" >> $setup_file_path
}

teardownFile() {
    teardown_file_path="${curr_directory}/teardown.sh"
    teardown_session_name="${project_name}-exit"
    
    echo -e "#!/bin/bash\n" > $teardown_file_path
    echo -e "# Create new session" >> $teardown_file_path
    echo -e "tmux new-session -d -s \"${teardown_session_name}\"\n" >> $teardown_file_path

    echo -e "# Switch to the new session" >> $teardown_file_path
    echo -e "tmux switch-client -t \"${teardown_session_name}\"\n" >> $teardown_file_path

    echo -e "# Close working environment" >> $teardown_file_path
    echo -e "tmux kill-session -t \"${project_name}\"" >> $teardown_file_path
}

# Call functions
setupFile
teardownFile

# To add an alias:
# 1. Go to .bash_profile
# 2. Add 'alias proj_setup='bash (directory where file is stored)/proj_setup.sh'
# 3. Update bash_profile by exiting shell
