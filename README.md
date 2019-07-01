# Do More

Make sure you have these 4 env variable in your .bashrc or .zshrc or whatever.

```
export TF_VAR_do_token="$DIGITALOCEAN_TOKEN"
export TF_VAR_pub_key="$(cat ~/.ssh/id_rsa_pwdless.pub)"
export TF_VAR_pvt_key="$(cat ~/.ssh/id_rsa_pwdless)"
export TF_VAR_ssh_fingerprint="$(ssh-keygen -E md5 -lf ~/.ssh/id_rsa_pwdless.pub | awk '{print $2}')"
```

Add this to `.zshrc` or `.bashrc`:
```
path_to_do_more='/PATH/TO/DO_MORE_DIR/'

alias do-more='function __f() { export TF_VAR_project_dir=$(pwd); cd $path_to_do_more; sh ./init.sh $*; cd -; ret=$?; unset -f __f; return $ret; }; __f'

alias do-taint='function __f() { export TF_VAR_project_dir=$(pwd); cd $path_to_do_more; terraform taint digitalocean_droplet.web $*; cd -; ret=$?; unset -f __f; return $ret; }; __f'
```

## To get started:
1. Do the above things.
2. `terraform init` in the Do More directory.
2. Go to your project root directory that contains the package.json.
3. Run `do-more`.
4. Done! 🎉

For repeat runs, just run `do-more`. If your container was built previously, it'll use it. Else it'll create one.

If you want to force re-create, do this:
```
do-taint && do-more --auto-approve
```

---

Note: This version of the project supports remote setup for only a yarn start-able project. Intended to be a proof-of-concept that it indeed is possible to setup, and resume work on a fully capable project that needs dependencies and stuff, and needs to be accessed over SSH or publicly.

Note: Your SSH key needs to be a [password-less one](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean).
