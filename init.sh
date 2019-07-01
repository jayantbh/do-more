terraform apply $*;

[ $? -ne 0 ] && exit $?;

ip=`echo digitalocean_droplet.web.ipv4_address | terraform console`
pvt_key=`echo var.pvt_key | terraform console`
project_dir=`echo var.project_dir | terraform console`
remote_project_dir=`echo var.remote_project_dir | terraform console`

red=`tput setaf 1`
green=`tput setaf 2`
bold=`tput bold`
bg=`tput smso`
reset=`tput sgr0`

echo "\n\n\n==============================\n"
echo "${green}You may SSH into the machine with this command:$reset"
echo "${red}${bold}ssh root@$ip -i $pvt_key$reset";
echo "${red}${bg}Public IP: $ip$reset";
echo "${green}Frontend server: ${bg}http://$ip:3000$reset";
cd $project_dir;
osascript -e 'display notification "Setup is ready. You may begin your work now." with title "Do More"'
nodemon --watch . --ignore ./dist --ignore node_modules --ignore .git --exec "rsync -r -a -v -e 'ssh -q -o StrictHostKeyChecking=no -i $pvt_key' . root@$ip:./$remote_project_dir --exclude node_modules --exclude .git -P"
