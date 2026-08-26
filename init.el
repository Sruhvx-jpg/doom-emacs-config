;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

(doom! :input
       ;;bidi

       :completion
       (corfu +orderless +icons)  ;; Modern fast completion overlay
       (vertico +icons)           ;; Vertical minibuffer completion

       :ui
       doom                       ;; What makes DOOM look the way it does
       dashboard                  ;; A stylish splash screen
       doom-quit                  ;; DOOM quit-messages
       hl-todo                    ;; Emphasize TODO/FIXME/NOTE/HACK
       hydra                      ;; Popup helper for sticky keymaps
       (modeline +light)          ;; Modern polished modeline
       ophints                    ;; Visual feedback on edit operations
       (popup +defaults)          ;; Manage popup windows
       treemacs                   ;; Project file drawer
       (vc-gutter +pretty)        ;; Git diff markers in fringe
       vi-tilde-fringe            ;; Fringe indicators for blank lines
       (window-select +numbers)   ;; Jump between splits using numbers
       workspaces                 ;; Tab/workspace grouping
       zen                        ;; Distraction-free coding

       :editor
       (evil +everywhere)         ;; Vim modal keybindings everywhere
       file-templates             ;; Auto-insert boilerplate for new files
       fold                       ;; Universal code folding
       (format +onsave)           ;; Auto-format on save
       multiple-cursors           ;; Multi-cursor editing
       snippets                   ;; Code snippets
       word-wrap                  ;; Soft line-wrapping

       :emacs
       (dired +icons)             ;; Visual Dired file explorer
       electric                   ;; Smart indentation & electric pairs
       (ibuffer +icons)           ;; Interactive buffer list
       undo                       ;; Persistent undo tree
       vc                         ;; Version control integration

       :term
       eshell                     ;; Elisp-powered shell
       vterm                      ;; C-based full-spec terminal emulator

       :checkers
       syntax                     ;; Flymake / Flycheck on the fly

       :tools
       editorconfig               ;; EditorConfig support
       eval                       ;; REPL & inline code runner
       lookup                     ;; Jump-to-definition & documentation
       (lsp +eglot)               ;; Ultra-fast LSP with Eglot
       magit                      ;; Git client
       tree-sitter                ;; Tree-sitter syntax highlighting

       :lang
       (cc +lsp +tree-sitter)
       (csharp +lsp +tree-sitter)
       (data +tree-sitter)
       (emacs-lisp)
       (go +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (json +lsp +tree-sitter)
       (markdown +grip)
       (python +lsp +tree-sitter +pyright)
       (rust +lsp +tree-sitter)
       (sh +lsp +tree-sitter)
       (web +lsp +tree-sitter)
       (yaml +lsp +tree-sitter)

       :config
       (default +bindings +smartparens))
