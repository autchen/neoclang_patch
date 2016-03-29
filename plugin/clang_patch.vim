
let s:cpo_save = &cpo
set cpo&vim

function! s:ShouldComplete()
  if (getline('.') =~ '#\s*\(include\|import\)')
    return 0
  else
    if col('.') == 1
      return 1
    endif
    for l:id in synstack(line('.'), col('.') - 1)
      if match(synIDattr(l:id, 'name'), '\CComment\|String\|Number')
            \ != -1
        return 0
      endif
    endfor
    return 1
  endif
endfunction

function! s:LaunchCompletion()
  let l:result = ""
  if s:ShouldComplete()
    let l:result = "\<C-X>\<C-U>"
    if g:clang_auto_select != 2
      let l:result .= "\<C-P>"
    endif
    if g:clang_auto_select == 1
      let l:result .= "\<C-R>=(pumvisible() ? \"\\<Down>\" : '')\<CR>"
    endif
    setlocal completefunc=ClangComplete
  endif
  return l:result
endfunction

function! s:CompleteDot()
  if g:clang_complete_auto == 1
    return '.' . s:LaunchCompletion()
  endif
  return '.'
endfunction

function! s:CompleteArrow()
  if g:clang_complete_auto != 1 || getline('.')[col('.') - 2] != '-'
    return '>'
  endif
  return '>' . s:LaunchCompletion()
endfunction

function! s:CompleteColon()
  if g:clang_complete_auto != 1 || getline('.')[col('.') - 2] != ':'
    return ':'
  endif
  return ':' . s:LaunchCompletion()
endfunction

function! s:InitPatch()
  if exists('g:clang_complete_auto') && g:clang_complete_auto
    inoremap <silent><expr> <buffer> <C-X><C-U> <SID>LaunchCompletion()
    inoremap <silent><expr> <buffer> . <SID>CompleteDot()
    inoremap <silent><expr> <buffer> > <SID>CompleteArrow()
    inoremap <silent><expr> <buffer> : <SID>CompleteColon()
  endif
endfunction

autocmd FileType c,cpp,objc,objcpp,c.*,cpp.*,objc.*objcpp.*
    \ call <SID>InitPatch()

let &cpo = s:cpo_save
unlet s:cpo_save
