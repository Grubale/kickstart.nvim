" Vim syntax file
" Language:	TypoScript
" Maintainer:	Nimjii
" Filenames:	.typoscript
" Last Change:	2023 Oct 09

if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn case match
syn keyword typoscriptBoolean true false
syn keyword typoscriptComparisonOperator in not matches
syn keyword typoscriptObject CASE COA COA_INT CONFIG CONTENT EXTBASEPLUGIN FILES FLUIDTEMPLATE GIFBUILDER HMENU
	    \ IMAGE IMG_RESOURCE LOAD_REGISTER PAGE RECORDS RESTORE_REGISTER SVG TEXT TMENU USER USER_INT

syn match typoscriptAltComment "\/\/.*" containedin=typoscriptLeft
syn match typoscriptBrackets "[\[\]]"
syn match typoscriptComma ","
syn match typoscriptComment "#.*" containedin=typoscriptLeft
syn match typoscriptCurly "[{}]" containedin=typoscriptDefBlock
syn match typoscriptDelimiter "|" contained containedin=typoscriptMultiLineStringInner,typoscriptMultiLineStringOuter,typoscriptRightString
syn match typoscriptDot "?\=\\\@<!\." containedin=typoscriptLeft,typoscriptRightRef
syn match typoscriptEscapedDot "\\\." contained containedin=typoscriptLeft,typoscriptRightRef transparent
syn match typoscriptMethod "\h\+\((.*)\)\@="
syn match typoscriptNumber "\d\+\(\.\d\+\)\="
syn match typoscriptOperator "[:!=<>&|]"
syn match typoscriptParenthesis "[()]"

syn region typoscriptBlock start="{" end="}" transparent fold
syn region typoscriptBlockComment start="\/\*" end="\*\/" containedin=typoscriptLeft extend
syn region typoscriptConditionInner start="\[" end="\]" contains=TOP,typoscriptDef,typoscriptDefBlock,typoscriptDefString
	    \ contained containedin=typoscriptConditionInner,typoscriptConditionOuter oneline extend
syn region typoscriptConditionOuter start="\[" end="\]" contains=TOP,typoscriptDef,typoscriptDefBlock,typoscriptDefString oneline keepend
syn region typoscriptConstant start="{\$" end="}" containedin=typoscriptRightString,typoscriptString oneline
syn region typoscriptDef start="^[^\[\]\/{}<>=@#]" end="[<>][^\]]*$" oneline keepend
syn region typoscriptDefBlock start="^[^\[\]\/{}<>=@#]" end="[{(]$" oneline keepend
syn region typoscriptDefString start="^[^\[\]\/{}<>=@#]" end="[<>=]\@<!=[=<]\@!.*$" oneline keepend
syn region typoscriptInclude start="@import" end="$" oneline keepend
syn region typoscriptLeft start="^[^\[\]{}<>=@]" end="\(:=\|>\|<\|=\|=<\|[({}]\)"me=s-1 contained containedin=typoscriptDef,typoscriptDefBlock,typoscriptDefString
syn region typoscriptMultiLineStringInner start="(" end=")" contained containedin=typoscriptMultiLineStringInner,typoscriptMultiLineStringOuter extend
syn region typoscriptMultiLineStringOuter matchgroup=Delimiter start="(" end=")" contained containedin=typoscriptDefBlock extend fold
syn region typoscriptRightRef matchgroup=Delimiter start="\(>\|=\{,1}<\)" end="$" contained containedin=typoscriptDef
syn region typoscriptRightString matchgroup=Delimiter start=":\==" end="$" contained containedin=typoscriptDefString contains=typoscriptObject
syn region typoscriptString start=/\\\@<!['"]/ end=/\\\@<!['"]/ containedin=typoscriptInclude

hi def link typoscriptAltComment		Comment
hi def link typoscriptBlockComment		Comment
hi def link typoscriptBoolean			Boolean
hi def link typoscriptBrackets			Delimiter
hi def link typoscriptComma			Delimiter
hi def link typoscriptComment			Comment
hi def link typoscriptComparisonOperator	Operator
hi def link typoscriptConditionInner		Conditional
hi def link typoscriptConditionOuter		Conditional
hi def link typoscriptConstant			Constant
hi def link typoscriptCurly			Delimiter
hi def link typoscriptDelimiter			Delimiter
hi def link typoscriptDot			Ignore
hi def link typoscriptInclude			Include
hi def link typoscriptLeft			Identifier
hi def link typoscriptNumber			Number
hi def link typoscriptMethod			Function
hi def link typoscriptMultiLineStringInner	String
hi def link typoscriptMultiLineStringOuter	String
hi def link typoscriptObject			Type
hi def link typoscriptOperator			Operator
hi def link typoscriptParenthesis		Delimiter
hi def link typoscriptString			String
hi def link typoscriptRightRef			Identifier
hi def link typoscriptRightString		String
hi def link typoscriptVariable			Keyword

let b:current_syntax = 'typoscript'
