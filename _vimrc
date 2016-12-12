" Init global variables -------------------------------------- {{{
execute pathogen#infect()
"^^^use pathogen
syntax on			" Turn on syntax so filetype detection will work properly
filetype plugin indent on	" Turn on filetype detection
color sea
"^^^ set color scheme for vim
let mapleader=","		" Set up my map leader for <leader> variable thing
let maplocalleader="." 		" Set up my local map leader variable thing
let g:quickfix_is_open = 1	" Since we auto load the quickfix window this will be set to one

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

"Open / Closes the quickfix window for us, mapped to <leader>q
function! QuickFixToggle()
	if g:quickfix_is_open
		cclose
		let g:quickfix_is_open = 0
	else
		execute "normal! :vertical topleft copen 99\<cr>:wincmd l\<cr>"
		let g:quickfix_is_open = 1
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
nnoremap <C-.> :wincmd l<cr>
"^^^ shortcut to jump right a window buffer!
nnoremap <C-,> :wincmd h<cr>
"^^^ shortcut to jump left a window buffer!
nnoremap <leader>q :call QuickFixToggle()<cr>
"^^^ open/close the quickfix window for us
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
