tmux -> standard shell wird überschrieben

┌[6:54:48] [ssh:darkiop@pve-ct-dev (10.4.0.10): ~ (750)]
└─$ echo $SHELL
/bin/zsh

┌[6:55:11] [ssh:darkiop@pve-ct-dev (10.4.0.10): ~ (750)]
└─$ cat /etc/passwd | grep darkiop
darkiop:x:1000:1000:,,,:/home/darkiop:/bin/bash