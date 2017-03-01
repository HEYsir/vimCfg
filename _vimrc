"==========================================
" Author:  HEYsir
" Version: 0.1
" Email: wafx1314@gmail.com
" BlogPost: http://www.noinf.com
" ReadMe: README.md
" Sections:
"       -> Initial Plugin 加载插件
"       -> Theme Settings  主题及字体设置
"       -> FileEncode Settings 文件编码设置
"       -> General Settings 基础设置
"       -> Others 其它配置
"       -> FileType Settings  针对文件类型的设置
"       -> HotKey Settings  自定义快捷键


"
"       -> 插件配置和具体设置在vimrc.bundles中
"       -> gui相关配置在vimrc.gui中
"==========================================

set nocompatible	"去掉vi的兼容模式
let mapleader = ' ' "将空格设置为leader

" == 插件加载 =====================================
if filereadable(expand("~/.vim/vimrc.bundles"))
    source ~/.vim/vimrc.bundles
endif

" == 主题配置 =====================================
" -----配色-----	
set background=dark      "设置背景色"
let &t_Co = 256

" 配色方案，如果可能采用256色
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
	let &t_Co = 256
endif

" 防止tmux下vim的背景色显示异常
" Refer: http://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

try
    colorscheme Tomorrow-Night-Eighties
catch
    colorscheme desert
endtry

" -----字体-----	


if filereadable(expand("~/.vim/vimrc.gui"))
    source ~/.vim/vimrc.gui
endif

" == 文件编码 ====================================================
"set enc=utf-8  	"Vim的内部编码方式,影响Buffer,registers,菜单,消息,viminfo file，
set fenc=chinese    "文件编码，无论新旧文件以此种编码方式保存。在与enc不一致时以会转为enc，保存时再转回fenc
set fencs=ucs-bom,utf-8,cp936,gbk,ucs-bom,shift-jis "打开文件时自动依次判断编码
set fileformat=unix    "设置默认unix格式，读入文件自动转换为对应格式
set ffs=unix,dos,mac" 文件格式列表（回车符的格式）

"语言设置  
"set langmenu=zh_CN.UTF-8  
set helplang=cn  "帮助系统设置为中文

" ==基础设置=============================================================	
filetype on " 侦测文件类型 
filetype plugin on " 载入文件类型插件

" VIM重新打开文件时自动跳转到上次位置, 需要确认 .viminfo 当前用户可写
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set fillchars=vert:\ ,stl:\ ,stlnc:\  " 在被分割的窗口间显示空白，便于阅读 

set ruler	" 标尺，用于显示光标位置的行号和列号。如果窗口有状态行，标尺在那里显示。否则，它显示在屏幕的最后一行上
set scrolloff=3       "距离顶部和底部3行"

" 上下左右键的行为 会显示其他信息
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

" -- 高亮相关配置 --------------------------------------
syntax on			"开启语法高亮"
set cursorline       "突出显示当前行"
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white   
"set cursorcolumn      "突出显示当前列"
"hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white

set showmatch		"显示匹配的括号"
set matchtime=5		"匹配括号高亮的时间（单位是十分之一秒）

" 设置标记一列的背景颜色和数字一行颜色一致
"hi! link SignColumn   LineNr
"hi! link ShowMarksHLl DiffAdd
"hi! link ShowMarksHLu DiffChange
" for error highlight，防止错误整行标红导致看不清
"highlight clear SpellBad
"highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
"highlight clear SpellCap
"highlight SpellCap term=underline cterm=underline
"highlight clear SpellRare
"highlight SpellRare term=underline cterm=underline
"highlight clear SpellLocal
"highlight SpellLocal term=underline cterm=underline

" 自定义高亮的关键字
if has("autocmd")
  " Highlight TODO, FIXME, NOTE, etc.
  if v:version > 701
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')
  endif
endif

" -----状态行设置-----
set laststatus=2    "总是显示状态行
" 状态行显示的内容（包括文件类型和解码）  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}  
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]

" -----命令行设置-----
set cmdheight=2  	" 命令行（在状态行下）的高度为2 
set showcmd         " 命令行显示输入的命令
set showmode        " 命令行显示vim当前模式

autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>   " command-line window

" -- 行号设置 -------------------------------------
set number			"显示行号
" 相对行号: 行号变成相对，可以用 nj/nk 进行跳转
set relativenumber number
au FocusLost * :set norelativenumber number
au FocusGained * :set relativenumber
" 插入模式下用绝对行号, 普通模式下用相对
autocmd InsertEnter * :set norelativenumber number
autocmd InsertLeave * :set relativenumber
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber number
  else
    set relativenumber
  endif
endfunc
nnoremap <leader>nt :call NumberToggle()<cr>

" -----代码折叠-----
set foldenable      " 允许折叠  
set foldmethod=syntax	" 设置折叠方法
                        " manual    手工折叠
                        " indent    使用缩进表示折叠
                        " expr      使用表达式定义折叠
                        " syntax    使用语法定义折叠
                        " diff      对没有更改的文本进行折叠
                        " marker    使用标记进行折叠, 默认标记是 {{{ 和 }}}
"set foldlevel=99

" 代码折叠自定义快捷键
"let g:FoldMethod = 0
"map <leader>zz :call ToggleFold()<cr>
"fun! ToggleFold()
"    if g:FoldMethod == 0
"        exe "normal! zM"
"        let g:FoldMethod = 1
"    else
"        exe "normal! zR"
"        let g:FoldMethod = 0
"    endif
"endfun


" --断行设置--
set tw=78		" 设置光标超过 78 列的时候折行。
set linebreak	" 整词换行,不在单词中间断行
set fo+=mB		" 打开断行模块对亚洲语言支持;
				" m 表示允许在两个汉字之间断行，即使汉字之间没有出现空格;
				" B 表示将两行合并为一行的时候，汉字与汉字之间不要补空格。

"set t_ti= t_te=    " 设置 退出vim后，内容显示在终端屏幕

set ambiwidth=double    "防止Unicode特殊符号无法正常显示
"set nowrap  " 取消换行,终端里不建议

" ================编辑======================================================
" --TAB设置---------------------
set tabstop=4		"定义程序中tab所等同的空格长度
set shiftwidth=4	"用于程序中自动缩进所使用的空格长度，同时它也是符号移位长度的制定者
set softtabstop=4	"按下tab键，插入的是空格和tab制表符的混合，逢tabstop个空格进为1制表符
set shiftround  " 缩进时，取整 use multiple of shiftwidth when indenting with '<' and '>'
set expandtab		" 将tables扩展成空格,[需要输入真正的Tab键时，使用 Ctrl+V + Tab]
set smarttab        " 行首输入 tab 插入 shiftwidth的空格,其他以 tabstop 和 softtabstop 处理，按退格键时可以一次删掉 4 个空格

" --缩进allow plugins by file type (required for plugins!)--
"set smartindent
"set autoindent "自动缩进，即每行的缩进值与上一行相等"
filetype indent on "按 indent 目录下的脚本自动缩进
set cindent        "设置C样式的缩进格式
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s     "设置C/C++语言的具体缩进方式

" --搜索设置----------------------------------
set ignorecase		"搜索时忽略大小写，可能中文支持不好
set hlsearch        "高亮搜索项"
set incsearch		" 增量搜索，边输入边显示效果
"set smartcase      " 有一个或以上大写字母时仍大小写敏感
set magic     		" 设置魔术，设置正则表达式除了 $ . * ^ 之外其他元字符都要加反斜杠。


" -- 文件读取和保存 ------------------------------------
set autoread        "文件在Vim之外修改过，自动重新读入
set autowrite       " 自动把内容写回文件: 如果文件被修改过，
			" 在每个 :next、:rewind、:last、:first、:previous、:stop、:suspend、:tag、:!、:make、CTRL-] 和 CTRL-^命令时进行；
			"用 :buffer、CTRL-O、CTRL-I、'{A-Z0-9} 或 `{A-Z0-9} 命令转到别的文件时亦然。
"set autowriteall   "比autowrite 多了新建文件，或退出窗口时也能自动保存
set hidden " Hide buffers when they are abandone,允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存

" vimrc文件修改之后自动加载
if (has("win32"))
autocmd! bufwritepost _vimrc source %   "windows
else
autocmd! bufwritepost .vimrc source %   "linux
endif

" --VIM在插入模式下可以通过backspace按键进行删除--
set backspace=indent,eol,start 	"indent: 用了:set indent,:set ai等自动缩进，想用退格键将字段缩进的删掉,必须设置这个选项。否则不响应。
								"eol:如果插入模式下在行开头，想通过退格键合并两行，需要设置eol。
								"start：要想删除此次插入前的输入，需设置这个。
								"和set backspace=2
set whichwrap+=<,>,h,l  " 允许跨越行边界(正常和可视模式),b:backspace,s:空格键,</>/h/l:光标键，[/]:方向键（插入和替换模式）

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
if has('mouse')
  set mouse=a	"启用鼠标"
" set mousehide " Hide the mouse cursor while typing
endif

" 修复ctrl+m 多光标操作选择的bug，但是改变了ctrl+v进行字符选中时将包含光标下的字符
set selection=inclusive    " 选中光标所在字符，exclusive可能会出现某些文本无法被选中的情况
"set selectmode=mouse,key
 
" ==代码自动补全=====================
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {<CR>}<ESC>O
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
function! ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction

" -- 自动补全基础 --------------------------------
set completeopt=longest,menu	"设置OmniComplete补全列表
set wildmenu "在命令模式用 Tab自动补全时，将补全内容使用单行菜单形式显示 
"set wildmode=list:longest
autocmd InsertLeave * if pumvisible() == 0|pclose|endif " 离开插入模式后自动关闭预览窗口
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"    " 回车即选中当前项

set lazyredraw      " 解决某些类型的文件由于syntax导致vim反应过慢的问题
set ttyfast         " 平滑地变化

"===FileType Settings  文件类型设置 ========================
" 具体编辑文件类型的一般设置，比如TAB长度设置等，用于通用设置不一致时
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType ruby,javascript,html,css,xml set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown set filetype=markdown.mkd
autocmd BufRead,BufNewFile *.part set filetype=html
" disable showmatch when use > in php
au BufWinEnter *.php set mps-=<:>

" 保存python文件时删除多余空格
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" 定义函数AutoSetFileHead，自动插入文件头
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif

    "如果文件类型为python
    if &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python")
        call append(1, "\# encoding: utf-8")
    endif

    normal G
    normal o
    normal o
endfunc


" ================其他======================================================
set history=2000    " history存储容量
set backupext=.bak  "修改备份文件名
"set backupdir=/tmp/vimbk/   "设置备份文件位置，一设置就无法正常保存
set nobackup " 取消备份，视情况自己改

"set noswapfile  " 关闭交换文件,极不推荐
set clipboard+=unnamed	"共享系统剪贴板     

set nrformats=  " 00x增减数字时使用十进制
set wildignore=*.swp,*.bak,*.pyc,*.class,.svn,*.o,*~

set novisualbell    " 去掉输入错误的屏幕闪烁提示
set noerrorbells    " 去掉输入错误的提示声音
set t_vb=
set tm=500


" TODO: remove this, use gundo
" if has('persistent_undo') " create undo file
  " set undolevels=1000 " How many undos
  " set undoreload=10000    " number of lines to save for undo
  " " So is persistent undo ...
  " set undofile
  " set undodir=/tmp/vimundo/
" endif


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"======自定义快捷键 ===========
if filereadable(expand("~/.vim/vimrc.keymap"))
    source ~/.vim/vimrc.keymap
endif



