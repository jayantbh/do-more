ip=`echo digitalocean_droplet.web.ipv4_address | terraform console`
pvt_key=`echo var.pvt_key | terraform console`
remote_project_dir=`echo var.remote_project_dir | terraform console`

default_init_cmd="cd $remote_project_dir;"

if [ $# -eq 0 ]; then
    ssh -t root@$ip -i $pvt_key "$default_init_cmd \$SHELL";
else
    ssh root@$ip -i $pvt_key "$default_init_cmd $*"
fi
