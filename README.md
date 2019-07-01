# Do More

Make sure you have these 4 env variable in your .bashrc or .zshrc or whatever.

```
export TF_VAR_aws_access_key_id=AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_access_key=AWS_SECRET_ACCESS_KEY
export TF_VAR_do_token="$DIGITALOCEAN_TOKEN"
export TF_VAR_pub_key="$(cat ~/.ssh/id_rsa_pwdless.pub)"
export TF_VAR_pvt_key="$(cat ~/.ssh/id_rsa_pwdless)"
export TF_VAR_ssh_fingerprint="$(ssh-keygen -E md5 -lf ~/.ssh/id_rsa_pwdless.pub | awk '{print $2}')"
```

Add this to `.zshrc` or `.bashrc`:
```
path_to_do_more='/PATH/TO/DO_MORE_DIR/'

alias do-init='function __f() { cd $path_to_do_more; terraform init $*; cd -; ret=$?; unset -f __f; return $ret; }; __f'

alias do-more='function __f() { export TF_VAR_project_dir=$(pwd); cd $path_to_do_more; sh ./init.sh $*; cd -; ret=$?; unset -f __f; return $ret; }; __f'

alias do-destroy='function __f() { cd ~/Projects/do-more/; terraform destroy $*; cd -; ret=$?; unset -f __f; return $ret; }; __f'

alias do-ssh='function __f() { cd ~/Projects/do-more/; sh ./connect.sh $*; cd -; ret=$?; unset -f __f; return $ret; }; __f'
```

## To get started:
1. Do the above things.
2. `terraform init` in the Do More directory.
3. Go to your project root directory that contains the package.json.
4. Run `do-more`.
5. Done! 🎉

**But wait, we're not done yet.**

Remote syncing and stuff is now working, but the docker-compose environment isn't running yet. To do that:
1. Open a new terminal (optional)
2. `do-ssh docker-compose up`

This part is separated from the automated process, because there is a chance that `docker-compose up` may time-out, and hence need you to retry the command.
It's best if you have control over this. This project just makes it convenient for you to do so.

**TL;DR:**
```
# First, set above variables. Then...
do-init && do-more #in project directory
do-ssh "docker-compose up -d && docker-compose logs -f" #in another terminal
```

For repeat runs, just run `do-more`. If your container was built previously, it'll use it. Else it'll create one.

If you want to force re-create, do this:
```
do-destroy && do-more --auto-approve
```

**Remote commands:**

To connect over SSH:
```
do-ssh
```

To run a command over SSH
```
do-ssh echo "Hello world"
do-ssh docker-compose logs -f
do-ssh "cd integrated-tests; pytest"
```


---

Note: This version of the project supports remote setup for only a docker-compose up startable project.

Note: Your SSH key needs to be without a password.
