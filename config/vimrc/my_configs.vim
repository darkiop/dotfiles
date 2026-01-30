" vimrc-amix user config
" links to: ~/dotfiles/modules/vimrc/my_configs.vim

colorscheme dracula
" colorscheme pyte

" Ensure MRU file can be created (use /tmp as fallback if home isn't writable)
if filewritable($HOME) == 2
    let MRU_File = $HOME . '/.vim_mru_files'
else
    let MRU_File = '/tmp/.vim_mru_files_' . $USER
endif
