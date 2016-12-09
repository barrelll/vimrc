" Init global variables -------------------------------------- {{{
syntax on			" Turn on syntax so filetype detection will work properly
filetype plugin indent on	" Turn on filetype detection
let mapleader=","		" Set up my map leader for <leader> variable thing
let maplocalleader="." 		" Set up my local map leader variable thing

set number 			" Show side/row numbers
set numberwidth=1		" Set width of the side numbers area to 10 columns
set backspace=2			" make backspace work like most other apps

if has("win32")			" Only if we have win32, I have a feeling this will get really big
	set grepprg=findstr	" Make sure vim uses the grep command instead of windows findstr
endif
" }}}

" Function definitions for vimscripting! --------------------------------------- {{{
	" Find out wheter the line we're on is commented out or not
	function! IsItCommentedVimS()
		return ( expand("<cWORD>") ==? '"' )
	endfunction

	" Comment out the line if it's not commented else we uncomment
	" it, Super simple stuff!
	function! CommentOutVimS() " We'll have differnt calls for different filetypes
		:execute "normal! I\<esc>\<right>"
		if IsItCommentedVimS()
			:execute "normal! I\<esc>\<right>x\<esc>x"
		else
			:execute "normal! I\"\<space>\<esc>"
		endif
	endfunction
" }}}

" Mapping goes here --------------------------------------- {{{
map <space> :normal! viw<cr>
" Remap space to select the word under the cursor
map - dd<Down><S-P>		
" Remap subtract/dash to delete current line and move it down one row
map _ dd<Up><S-P>		
" Will need to refine these two later, same as above except move it up

nnoremap <leader>ne	:split $MYVIMRC<cr>
" ^^^Shortcut to open vimrc in vim
nnoremap <leader>sv	:source $MYVIMRC<cr>
" ^^^ Shortcut to load vimrc after an edit in the same session no reloading 
nnoremap <leader>lb	:execute "rightbelow split " . bufname("#")<cr>
" ^^^Shortcut to open last buffer in horizontal split on bottom screen
" nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel " remap ," to encase currently hovered over word by the cursor with quotations
if has("win32")
	" cnoremap <localleader>g :silent execute ":grep! /n /s " . shellescape(expand("<cWORD>")) . " *." . expand("%:e")<cr><cr>:copen<cr>
	" ^^^ long one here, use findstr if we're in windows shellescape and
	" expand the word under the cursor, the /n shows the numbers inside
	" the file we found the strings in, the /s is for recursion, since no
	" file directory is specified we search from the current directory.
	" expand the string "%:e" which should find the current file extension 
	" so this should work in any programming language where all the file
	" extensions match, then we open the quickfix window! 
	" in the future, make this grep the word under the cursor in all
	" project files, but no other file
endif
nnoremap <C-.> :wincmd l<cr>
"^^^ shortcut to jump right a window buffer!
nnoremap <C-,> :wincmd h<cr>
"^^^ shortcut to jump left a window buffer!
" }}}

" Auto load for all files goes here  --------------------------------------- {{{
autocmd VimEnter * execute "normal! :vertical topleft copen 99\<cr>:wincmd l\<cr>"
" }}}

" Grouping goes here --------------------------------------- {{{
" Python file settings
augroup filetype_python " basically a namespace for our auto cmd's
	" prevent anything from being defined twice in the same group with au!
	" same as autocmd!
	:  au!
	autocmd FileType python nnoremap <buffer> <localleader>co I#<esc>
	" ^^^ only activate on entering a .py file, remap ,co to comment out a line 
	autocmd FileType python iabbrev <buffer> if if:<left> 
	" ^^^ when typing if in have it add the : for you and move over to the
	" left
augroup END

" Vimscript file settings
augroup filetype_vim
	" prevent anything from being defined twice in the same group with au!
	" same as autocmd!
	:  au!
	autocmd FileType vim setlocal foldmethod=marker
	" Make sure we're checking for markers to fold with
	autocmd FileType vim nnoremap <buffer> <localleader>co :call CommentOutVimS()<cr>
	" place the cursor at the start of the line, and comment out said line
	" co for comment out
	set foldlevelstart=0 " default is -1
augroup END
" }}}

" Any abbreviations go here --------------------------------------- {{{
iabbrev ssig jharrell552@gmail.com
" ^^^  an abbreviation for my email address! ^^^
" }}}

" Statusline stuff! --------------------------------------- {{{
set laststatus=2
" Always display status line
set statusline=%f\ -\ FileType:\ %y\ %=\ %4l\/\%-4L\ %%\%3p
" Set up my status line ^^^ :help 'statusline' for information on what each character does
" }}}