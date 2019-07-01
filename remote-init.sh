apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'
apt update
apt-cache policy docker-ce
apt install -y docker-ce
systemctl status docker | cat
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ~/.bashrc
echo "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ~/.bashrc

# Prevent .bashrc source from terminating prematurely on a [ -z "$PS1" ] check
line_num=`cat ~/.bashrc | grep '\[ \-z \"\$PS1\" ]' -n | cut -f1 -d:`
line_text=`sed "${line_num}q;d" ~/.bashrc`
escaped_line_text=$(printf "%q" "$line_text")
sed -i "${line_num}s/.*/# $escaped_line_text/" ~/.bashrc
source ~/.bashrc
