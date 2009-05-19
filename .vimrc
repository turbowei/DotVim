filetype plugin indent on
syntax on

set autoindent
set foldenable
set tw=0
set ts=8
set number
set path=.,/usr/include,/usr/include/*,/usr/local/include,/usr/local/include/*,/home/xxxxx/FDDS/cvs/include/,/home/xxxxx/FDDS/cvs/include/*
set lines=70
set columns=200
set shiftwidth=8
set hidden
set bs=2
" set cursorline

set writebackup " Make a backup of the original file when writing
set backup " and don't delete it after a succesful write.
set backupskip= " There are no files that shouldn't be backed up.
set backupdir=/tmp/Backup
au BufWritePre * let &bex = '~' . 'backup' . '~'
" strftime("%Y%b%d%X") . '~'

set shortmess+=a " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler 
set laststatus=2 " Always show statusline, even if only 1 window.
set hlsearch
set incsearch
set guioptions-=T " no more toolbar
 
"let &statusline = '%<%f%{&mod?"[+]":""}%r%'
 "\ . '{&fenc !~ "^$\\|utf-8" || &bomb ? "[".&fenc.(&bomb?"-bom":"")."]" : ""}'
 "\ . '%='
 "\ . '%15.(%l,%c%V %P%)'

function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

if has('statusline')
  set statusline=                              " clear statusline in case we need to reload .gvimrc
  "set statusline=%#Question#                   " set highlighting
  set statusline+=%-2.2n\                      " buffer number
  "set statusline+=%#WarningMsg#                " set highlighting
  set statusline+=%f\                          " file name
  set statusline+=%* 
  "set statusline+=%#Question#                  " set highlighting
  set statusline+=%h%m%r%w\                    " flags
  set statusline+=%{strlen(&ft)?&ft:'none'},   " file type
  set statusline+=%{(&fenc==\"\"?&enc:&fenc)}, " encoding
  set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
  set statusline+=%{&fileformat},              " file format
  set statusline+=%{&spelllang},               " language of spelling checker
  set statusline+=%{SyntaxItem()}              " syntax highlight group under cursor
  set statusline+=%=                           " ident to the right
  set statusline+=0x%-8B\                      " character code under cursor
  set statusline+=%-7.(%l,%c%V%)\ %<%P         " cursor position/offset
endif


"colorscheme brookstream
"colorscheme candy
" colorscheme wuye
" colorscheme moria
" colorscheme lettuce

set guifont=LucidaTypewriter\ 9

"au BufNewFile,BufRead *.java,*.c,*.cc,*.C,*.h map <A-F1> :call CurlyBracket()<CR>

" Postgresql
au BufNewFile,BufRead *.sql setf psql
au BufNewFile,BufRead *.psql setf psql

"Fazzt
au BufNewFile,BufRead *.fsp setf fsp
au BufNewFile,BufRead *.fzt setf c++


function CurlyBracket()
	let l:startline = line(".")
	let l:result1 = searchpair('{', '', '}', 'bW')
	if (result1 > 0)
	let l:linenum = line(".")
	let l:string1 = substitute(getline(l:linenum), '^\s*\(.*\)\s*$', '\1', "")
	if (l:string1 =~ '^{')
	let l:string1 = substitute(getline(l:linenum - 1), '^\s*\(.*\)\s*$', '\1', "") . " " . l:string1
	sil exe "normal k"
	endif

	" get else part if necessary
	if (l:string1 =~ "^}")
	sil exe "normal 0"
	let l:result2 = searchpair('{', '', '}', 'bW')
	if (l:result2 > 0)
	let l:linenum = line(".")
	let l:string2 = substitute(getline(l:linenum), '^\s*\(.*\)\s*$', '\1', "")
	if (l:string2 =~ '^{')
	let l:string2 = substitute(getline(l:linenum - 1), '^\s*\(.*\)\s*$', '\1', "") . " " . l:string2
	endif
	let l:string1 = l:string2 . " ... " . l:string1
	endif
	endif

	" remove trailing whitespaces and curly brace
	let l:my_string = substitute(l:string1, '\s*{[^{]*$', '', "")
	let l:my_strlen = strlen(l:my_string)
	if (l:my_strlen > 30)
	let l:my_string = strpart(l:my_string,0,30)."..."
	endif

	sil exe ":" . l:startline
	sil exe "normal i}"
	if ((l:startline - l:linenum) > 10)
	sil exe "normal a /* " . l:my_string . " */"
	endif

	endif
endfunction

au BufNewFile,BufRead *.c,*.cc,*.h imap }<CR> <Esc>:call CurlyBracket()<CR>a
au BufNewFile,BufRead *.cpp,*.C imap }<CR> <Esc>:call CurlyBracket()<CR>a
au BufNewFile,BufRead *.java,*.idl imap }<CR> <Esc>:call CurlyBracket()<CR>a


" Clever Tab
function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

map <silent><F3> :NEXTCOLOR<cr>
map <silent><F2> :PREVCOLOR<cr> 

let Tlist_Ctags_Cmd = '/usr/bin/ctags'  "  --c++-kinds=+p --fields=+iaS --extra=+q'

" Open and close all the three plugins on the same time
nmap <F8>   :TrinityToggleAll<CR>

" Open and close the srcexpl.vim separately
nmap <F9>   :TrinityToggleSourceExplorer<CR>

" Open and close the taglist.vim separately
nmap <F10>  :TrinityToggleTagList<CR>

" Open and close the NERD_tree.vim separately
nmap <F11>  :TrinityToggleNERDTree<CR>

cd /home/xxxxx/FDDS/cvs
cs add /home/xxxxx/FDDS/cvs/cscope.out /home/xxxxx/FDDS/cvs

" set grepprg=ack
" set grepformat=%f:%l:%m
let mapleader=","

function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

map <leader>sc :call ToggleScratch()<CR>
map <leader>d :NERDTreeToggle<CR>
map <leader>t :TlistToggle<CR>
map <leader>s :SrcExplToggle<CR>

if version >= 700 && &term != 'cygwin' && !has('gui_running')
  " In the color terminal, try to use CSApprox.vim plugin or
  " guicolorscheme.vim plugin if possible in order to have consistent
  " colors on different terminals.
  "
  " Uncomment one of the following line to force 256 or 88 colors if
  " your terminal supports it.  Or comment both of them if your terminal
  " supports neither 256 nor 88 colors.  Unfortunately, querying the
  " number of supported colors does not work on all terminals.
  set t_Co=256
  "set t_Co=88

  if &t_Co == 256 || &t_Co == 88
    " Check whether to use CSApprox.vim plugin or guicolorscheme.vim plugin.
    if has('gui') &&
      \ (filereadable(expand("$HOME/.vim/plugin/CSApprox.vim")) ||
      \  filereadable(expand("$HOME/vimfiles/plugin/CSApprox.vim")))
      let s:use_CSApprox = 1
    elseif filereadable(expand("$HOME/.vim/plugin/guicolorscheme.vim")) ||
      \    filereadable(expand("$HOME/vimfiles/plugin/guicolorscheme.vim"))
      let s:use_guicolorscheme = 1
    endif
  endif
endif

if exists('s:use_CSApprox')
  " Can use the CSApprox.vim plugin.
  let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
  colorscheme leo 
elseif exists('s:use_guicolorscheme')
  " Can use the guicolorscheme plugin. It needs to be loaded before
  " running GuiColorScheme (hence the :runtime! command).
  runtime! plugin/guicolorscheme.vim
  GuiColorScheme leo 
else
  colorscheme leo 
endif

let Tlist_Exit_OnlyWindow=1 

nmap <leader>sos :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sog :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>soc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sot :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>soe :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sof :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>soi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader>sod :cs find d <C-R>=expand("<cword>")<CR><CR>


set cscopequickfix=s+,c+,d+,i+,t+,e+,f+,i+
" set completeopt=longest,preview
"cinoptions-value
set cino+=:0,g0,(0,i8,t0

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" Windows emulation
vmap <C-c> "+y
vmap <C-x> "+d
nmap <C-v> "+p
vmap <C-v> "+p
nmap <C-a> ggvG$
imap <C-s> <Esc>:wa<cr>i<Right>
nmap <C-s> :wa<cr>

vnoremap <Tab> >gv

let NERD_c_alt_style = 1 
let NERDShutup = 1
let NERDCompactSexyComs = 1
let NERDSpaceDelims = 1

let g:FuzzyFinderOptions = { 'Base':{}, 'Bookmark':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Tag':{}, 'TaggedFile':{}}
let g:FuzzyFinderOptions.Buffer.mode_available = 1
let g:FuzzyFinderOptions.Bookmark.mode_available = 1
let g:FuzzyFinderOptions.File.mode_available = 1
let g:FuzzyFinderOptions.MruFile.mode_available = 1
let g:FuzzyFinderOptions.MruCmd.mode_available = 0
let g:FuzzyFinderOptions.Dir.mode_available = 1
let g:FuzzyFinderOptions.Tag.mode_available = 1
let g:FuzzyFinderOptions.TaggedFile.mode_available = 0
let g:FuzzyFinderOptions.Base.abbrev_map = { "^Project-" : ["**/"], }
let g:FuzzyFinderOptions.Base.migemo_support = 0
"let g:FuzzyFinderOptions.Base.key_open_split = '<C-O>'
let g:FuzzyFinderOptions.File.excluded_path = '\v\~$|\.obj$|\.jpg$|\.gif$|\.o$|\./|\.git/|\.svn/|\.DS_Store|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)'
noremap <leader>fp :FuzzyFinderFile Project-<CR>
noremap <leader>ff :FuzzyFinderFile<CR>
noremap <leader>fb :FuzzyFinderBuffer<CR>
noremap <leader>fm :FuzzyFinderMruFile<CR>
noremap <leader>fv :FuzzyFinderBookmark<CR>
noremap <leader>fa :FuzzyFinderAddBookmark<CR>
noremap <leader>fd :FuzzyFinderDir<CR>
noremap <leader>ft :FuzzyFinderTag<CR>
noremap <leader>fc :FuzzyFinderRemoveCache<CR>
noremap <leader>ft :FuzzyFinderTextMate<CR>
noremap <leader>fr :FuzzyFinderTextMateRefreshFiles<CR>


let g:fuzzy_ignore = "*.log;*.o;*.jpg;*.gif;*png;.CVS;application/cache/**"

noremap <leader>cd :cd %:p:h<CR>

