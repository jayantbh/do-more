terraform apply $*

[ $? -ne 0 ] && exit $?

ip=`echo aws_instance.web.public_ip | terraform console`
instance_user=`echo var.instance_user | terraform console`
pvt_key=`echo var.pvt_key | terraform console`
project_dir=`echo var.project_dir | terraform console`
remote_project_dir=`echo var.remote_project_dir | terraform console`

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 6`
bold=`tput bold`
bg=`tput rev`
reset=`tput sgr0`

echo -e "\n\n\n${yellow}${bold}==============================${reset}\n"
echo "${green}You may SSH into the machine with this command:$reset"
echo "${blue}${bold}ssh $instance_user@$ip -i $pvt_key$reset"
echo -e "${green}${bg}Public IP: $ip$reset\n"
cd $project_dir;

__cmd_exists() { hash $1 2> /dev/null > /dev/null; return $?; }
dep_missing='false'
__cmd_exists rsync || echo "${yellow}Missing dependency: ${bg}${bold} rsync $reset" && dep_missing='true'
__cmd_exists nodemon || echo "${yellow}Missing dependency: ${bg}${bold} nodemon $reset" && dep_missing='true'
[ $dep_missing == 'true' ] && echo "${bold}${red}Exiting, because some dependencies were missing.$reset" && exit 1

notif_msg="Setup is ready. You may begin your work now."
notif_title="Do More"

echo `__cmd_exists ls`
__cmd_exists osascript && osascript -e "display notification \"$notif_msg\" with title \"$notif_title\""
__cmd_exists notify-send && notify-send "$notif_title" "$notif_msg" -t 4000

ssh_cmd="ssh -q -o StrictHostKeyChecking=no -i $pvt_key"
nodemon_cmd() { rsync -q -r -a -v -e "$ssh_cmd" . $instance_user@$ip:./$remote_project_dir --exclude node_modules --exclude .git -P; }
nodemon --watch . --ignore ./dist --ignore node_modules --ignore .git --exec "$(nodemon_cmd)"
