SSH_COMMAND="ssh pi@192.168.0.121 -fTN -R 2222:192.168.0.120:22 -i $HOME/.ssh/id_rsa"

while true; do
    if [[ -z $(ps -aux | grep "$SSH_COMMAND" | sed '$ d') ]]
    then eval $SSH_COMMAND
    else sleep 60
    fi
done

