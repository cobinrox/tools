#!/bin/bash
# scriptlet to send a long command to a Docker Exec


# Declare the heredoc variable
read -d '' VARIABLE_NAME << EOF
[HEREDOC_CONTENTS_PUT_YOUR_LONG_WINDED_COMMAND_HERE]
EOF

# Pass the heredoc variable as an argument to the Docker exec command
docker exec [CONTAINER_NAME] [COMMAND] <<< "$VARIABLE_NAME"
