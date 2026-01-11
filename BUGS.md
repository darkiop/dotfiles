tmux -> standard shell wird überschrieben
```
┌[6:54:48] [ssh:darkiop@pve-ct-dev (10.4.0.10): ~ (750)]
└─$ echo $SHELL
/bin/zsh

┌[6:55:11] [ssh:darkiop@pve-ct-dev (10.4.0.10): ~ (750)]
└─$ cat /etc/passwd | grep darkiop
darkiop:x:1000:1000:,,,:/home/darkiop:/bin/bash
```

---

zsh prompt git:

┌[6:55:56] [ssh:darkiop@pve-ct-dev (10.4.0.10): ~/dotfiles (775)] [git:wip/experiments%F{39}]
└─$

┌[06:56:11] [ssh:darkiop@pve-ct-dev (10.4.0.10): ~/dotfiles (775)] [git:wip/experiments %]
└─$

"*%>" sollen immer dasselbe rot haben. aktuelle ist es in der bash version für > noch ein abweichendes rot in verwendung