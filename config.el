;;; config.el -*- lexical-binding: t; -*-

;; ==============================================================================
;; 1. USER IDENTITY
;; ==============================================================================
(setq user-full-name "Dron"
      user-mail-address "dron@local")

;; ==============================================================================
;; 2. TYPOGRAPHY & FONTS (JetBrains Mono + Inter for Variable Pitch)
;; ==============================================================================
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'regular)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 20 :weight 'semi-bold)
      doom-variable-pitch-font (font-spec :family "Inter" :size 14 :weight 'regular)
      doom-serif-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-symbol-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

;; ==============================================================================
;; 3. THEME & COLOR PALETTE
;; ==============================================================================
(add-to-list 'custom-theme-load-path (expand-file-name "themes" doom-user-dir))
(setq doom-theme 'doom-nvim-dark)

;; ==============================================================================
;; 4. LINE NUMBERS & CURSOR
;; ==============================================================================
;; Normal (absolute) line numbers: 1, 2, 3, 4...
(setq display-line-numbers-type t)
(setq evil-normal-state-cursor '(box "#5f8787")
      evil-insert-state-cursor '((bar . 2) "#c1c1c1")
      evil-visual-state-cursor '(hollow "#79241f"))

;; ==============================================================================
;; 5. DOOM MODELINE (Aesthetic Status Bar)
;; ==============================================================================
(setq doom-modeline-height 32
      doom-modeline-bar-width 4
      doom-modeline-icon t
      doom-modeline-major-mode-icon t
      doom-modeline-major-mode-color-icon t
      doom-modeline-buffer-file-name-style 'relative-from-project
      doom-modeline-enable-word-count nil
      doom-modeline-buffer-encoding nil
      doom-modeline-modal-icon t
      doom-modeline-persp-name t
      doom-modeline-lsp t)

;; ==============================================================================
;; 6. VISUAL POLISH & RICE ENHANCEMENTS
;; ==============================================================================
;; Cursor beacon: pulses cursor position when jumping/scrolling
(use-package! beacon
  :hook (doom-first-buffer . beacon-mode)
  :config
  (setq beacon-color "#5f8787"
        beacon-blink-duration 0.2
        beacon-blink-delay 0.05
        beacon-size 25))

;; Highlight indentation guides
(use-package! highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character ?│
        highlight-indent-guides-responsive 'top))

;; Colorize color hex strings (#ff5555, rgb(...))
(use-package! rainbow-mode
  :hook (prog-mode . rainbow-mode))

;; Window and buffer defaults
(setq-default x-stretch-cursor t)
(setq evil-vsplit-window-right t
      evil-split-window-below t
      scroll-margin 5
      scroll-conservatively 101
      auto-save-default t)

;; ==============================================================================
;; 7. CUSTOM DASHBOARD BANNER
;; ==============================================================================
(defun my-doom-banner ()
  (let* ((quotes
          '("VIM IS JUST AN EMACS PLUGIN"
            "STILL TRAPPED IN :wq?"
            "IMAGINE CONFIGURING IN LUA"
            "YOUR MODAL EDITOR'S DADDY"
            "NEOVIM USERS ON LIFE SUPPORT"
            "VIM COPE. EMACS REIGN."
            "ALL THAT LUA JUST TO EXIT :q!"
            "EMACS: THE OS VIM WISHES IT WAS"
            "YOUR 200 NVIM PLUGINS BROKE AGAIN"
            "EVIL-MODE: VIM BUT ACTUALLY GOOD"
            "LISP GODS > MODAL PEASANTS"
            "REAL HACKERS DON'T FEAR PARENS"
            "WHY ESC WHEN YOU CAN ASCEND?"))
         (selected-quote (nth (random (length quotes)) quotes))
         (pad (max 0 (/ (- 40 (length selected-quote)) 2)))
         (centered-quote (format "%s%s%s"
                                 (make-string pad ?\s)
                                 selected-quote
                                 (make-string (max 0 (- 40 (length selected-quote) pad)) ?\s)))
         (banner
          `("██████╗   ██████╗   ██████╗  ███╗   ███╗"
            "██╔══██╗ ██╔═══██╗ ██╔═══██╗ ████╗ ████║"
            "██║  ██║ ██║   ██║ ██║   ██║ ██╔████╔██║"
            "██║  ██║ ██║   ██║ ██║   ██║ ██║╚██╔╝██║"
            "██████╔╝ ╚██████╔╝ ╚██████╔╝ ██║ ╚═╝ ██║"
            "╚═════╝   ╚═════╝   ╚═════╝  ╚═╝     ╚═╝"
            ""
            "                E M A C S               "
            ,centered-quote)))
    (propertize (string-join banner "\n") 'face '+dashboard-banner)))

(setq +dashboard-ascii-banner-fn #'my-doom-banner
      +doom-dashboard-ascii-banner-fn #'my-doom-banner)

;; ==============================================================================
;; 8. VS CODE-FRIENDLY & ERGONOMIC KEYMAPS
;; ==============================================================================
;; Smart file finder: If in a git project, search project; otherwise search directory
(defun my/find-file ()
  "Find file in project if inside one, otherwise open file finder in current directory."
  (interactive)
  (if (doom-project-p)
      (projectile-find-file)
    (call-interactively #'find-file)))

;; Override Evil's C-p (which defaults to evil-paste-pop)
(after! evil
  (define-key evil-normal-state-map (kbd "C-p") #'my/find-file)
  (define-key evil-motion-state-map (kbd "C-p") #'my/find-file)
  (define-key evil-visual-state-map (kbd "C-p") #'my/find-file)
  (define-key evil-insert-state-map (kbd "C-p") #'my/find-file)
  (define-key evil-normal-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-insert-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-visual-state-map (kbd "C-s") #'save-buffer))

(global-set-key (kbd "C-p") #'my/find-file)
(global-set-key (kbd "C-s") #'save-buffer)
(global-set-key (kbd "C-/") #'comment-line)

;; Easy window navigation with Ctrl+h/j/k/l
(map! :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right)

;; Custom Window Controls: SPC w q to Close, SPC w c to Create
(map! :leader
      (:prefix "w"
       :desc "Close Window"  "q" #'evil-window-delete
       :desc "Create Window" "c" #'evil-window-vsplit))

;; ==============================================================================
;; CUSTOM FILE CONTROLS: SPC f c to Create, SPC f d to Delete
;; ==============================================================================
(defun my/create-file-or-dir (path)
  "Physically create a file or directory on disk immediately (like touch/mkdir).
Does not yank you into a new buffer, and immediately syncs to disk."
  (interactive "FCtl/Path to create: ")
  (let ((expanded (expand-file-name path)))
    (if (string-suffix-p "/" path)
        (progn
          (make-directory expanded t)
          (message "✓ Directory created: %s" path))
      (let ((dir (file-name-directory expanded)))
        (when (and dir (not (file-exists-p dir)))
          (make-directory dir t)))
      (if (file-exists-p expanded)
          (message "⚠ File already exists: %s" path)
        (write-region "" nil expanded nil 'quiet)
        (message "✓ File created on disk: %s" path)))
    ;; If inside Dired, refresh view instantly
    (when (derived-mode-p 'dired-mode)
      (revert-buffer))))

(defun my/delete-file ()
  "Delete current file or selected file in dired."
  (interactive)
  (cond
   ((derived-mode-p 'dired-mode)
    (dired-do-delete))
   ((buffer-file-name)
    (doom/delete-this-file))
   (t
    (user-error "Current buffer has no associated file to delete"))))

(map! :leader
      (:prefix "f"
       :desc "Create File/Directory" "c" #'my/create-file-or-dir
       :desc "Delete File"           "d" #'my/delete-file
       :desc "Delete This File"      "D" #'my/delete-file))

;; Treemacs file explorer toggle
(map! :leader
      :desc "Toggle Project Explorer" "e" #'+treemacs/toggle)

;; ==============================================================================
;; 9. VS CODE-STYLE BOTTOM TERMINAL TOGGLE (vterm)
;; ==============================================================================
;; Bind Ctrl+` and Ctrl+~ globally for instant popup terminal toggle
(global-set-key (kbd "C-`") #'+vterm/toggle)
(global-set-key (kbd "C-~") #'+vterm/toggle)

(map! :leader
      (:prefix "o"
       :desc "Toggle vterm popup" "t" #'+vterm/toggle
       :desc "Open vterm here"    "T" #'+vterm/here
       :desc "Toggle Pi Agent"    "p" #'+pi/toggle)
      (:prefix "c"
       :desc "Ask Pi Agent"       "P" #'+pi/ask)
      :v "c P" #'+pi/send-region)

;; ==============================================================================
;; 10. SYSTEM BINARIES & TOOLCHAIN PATHS
;; ==============================================================================

;; Ensure Cargo/Rust, Dotnet, Go, LLVM/clangd, Pyright & TS binaries are always discoverable
(dolist (dir (list (expand-file-name "~/.cargo/bin")
                   (expand-file-name "~/.dotnet")
                   (expand-file-name "~/.dotnet/tools")
                   (expand-file-name "~/.local/go/bin")
                   (expand-file-name "~/go/bin")
                   (expand-file-name "~/.local/bin")))
  (add-to-list 'exec-path dir))

(setenv "DOTNET_ROOT" (expand-file-name "~/.dotnet"))
(setenv "GOROOT" (expand-file-name "~/.local/go"))
(setenv "GOPATH" (expand-file-name "~/go"))
(setenv "PATH" (concat (expand-file-name "~/.cargo/bin") ":"
                       (expand-file-name "~/.dotnet") ":"
                       (expand-file-name "~/.dotnet/tools") ":"
                       (expand-file-name "~/.local/go/bin") ":"
                       (expand-file-name "~/go/bin") ":"
                       (expand-file-name "~/.local/bin") ":"
                       (getenv "PATH")))

;; ==============================================================================
;; 11. ULTRA-FAST AUTO-COMPLETION & SNIPPETS (Corfu + Cape + Yasnippet)
;; ==============================================================================

;; ==============================================================================
;; 11. ULTRA-FAST AUTO-COMPLETION & SNIPPETS (VS Code-style Corfu + Yasnippet)
;; ==============================================================================

;; Ensure tree-sitter grammars are always discovered
(after! treesit
  (dolist (dir (list (expand-file-name "~/.config/emacs/tree-sitter")
                     (expand-file-name "~/.config/emacs/.local/etc/tree-sitter")))
    (add-to-list 'treesit-extra-load-path dir)))

;; Yasnippet Setup & Snippet Expansion globally
(use-package! yasnippet
  :config
  (yas-global-mode 1)
  (yas-reload-all)
  (setq yas-triggers-in-field t))

(use-package! yasnippet-snippets
  :after yasnippet)

;; Link tree-sitter & rustic modes to base snippet tables
(after! yasnippet
  (add-hook 'rustic-mode-hook (lambda () (yas-activate-extra-mode 'rust-mode)))
  (add-hook 'rust-ts-mode-hook (lambda () (yas-activate-extra-mode 'rust-mode)))
  (add-hook 'go-ts-mode-hook (lambda () (yas-activate-extra-mode 'go-mode)))
  (add-hook 'c-ts-mode-hook (lambda () (yas-activate-extra-mode 'c-mode)))
  (add-hook 'c++-ts-mode-hook (lambda () (yas-activate-extra-mode 'c++-mode)))
  (add-hook 'python-ts-mode-hook (lambda () (yas-activate-extra-mode 'python-mode)))
  (add-hook 'typescript-ts-mode-hook (lambda () (yas-activate-extra-mode 'typescript-mode)))
  (add-hook 'csharp-ts-mode-hook (lambda () (yas-activate-extra-mode 'csharp-mode))))

;; Instant popup autocompletion with docs (VS Code behavior)
(after! corfu
  (setq corfu-auto t
        corfu-auto-delay 0.05
        corfu-auto-prefix 1
        corfu-preview-current 'insert
        corfu-preselect 'first
        corfu-cycle t
        corfu-quit-no-match t)

  (require 'corfu-popupinfo nil t)
  (when (fboundp 'corfu-popupinfo-mode)
    (corfu-popupinfo-mode 1)
    (setq corfu-popupinfo-delay '(0.15 . 0.05)))

  ;; VS Code Keybindings inside the Corfu completion popup
  (define-key corfu-map (kbd "TAB") #'corfu-insert)
  (define-key corfu-map (kbd "<tab>") #'corfu-insert)
  (define-key corfu-map (kbd "RET") #'corfu-insert)
  (define-key corfu-map (kbd "<return>") #'corfu-insert)
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-j") #'corfu-next)
  (define-key corfu-map (kbd "C-p") #'corfu-previous)
  (define-key corfu-map (kbd "C-k") #'corfu-previous)
  (define-key corfu-map (kbd "C-d") #'corfu-popupinfo-toggle)
  (define-key corfu-map (kbd "M-d") #'corfu-popupinfo-toggle))

;; Rich completion pipeline - LSP candidates + Snippets + File paths + Dabbrev
(after! cape
  (require 'yasnippet-capf nil t)
  (defun my/setup-eglot-capf ()
    "Ensure Eglot completion blends LSP candidates and snippet suggestions seamlessly."
    (setq-local completion-at-point-functions
                (list (if (fboundp 'yasnippet-capf)
                          (cape-capf-super
                           (cape-capf-buster #'eglot-completion-at-point)
                           #'yasnippet-capf)
                        (cape-capf-buster #'eglot-completion-at-point))
                      #'cape-file
                      #'cape-dabbrev)))
  (add-hook 'eglot-managed-mode-hook #'my/setup-eglot-capf)

  (defun my/setup-prog-capf ()
    "Ensure clean fallback with snippets and dabbrev for non-LSP buffers."
    (unless (bound-and-true-p eglot--managed-mode)
      (setq-local completion-at-point-functions
                  (list (if (fboundp 'yasnippet-capf) #'yasnippet-capf #'cape-dabbrev)
                        #'cape-file
                        #'cape-dabbrev))))
  (add-hook 'prog-mode-hook #'my/setup-prog-capf))

;; ==============================================================================
;; 12. MULTI-LANGUAGE LSP (EGLOT) ENGINE
;; ==============================================================================

(after! eglot
  ;; Language server binary mapping
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode c-ts-mode c++-ts-mode)
                 "clangd"
                 "--background-index"
                 "--clang-tidy"
                 "--header-insertion=iwyu"
                 "--completion-style=detailed"))
  (add-to-list 'eglot-server-programs
               '((csharp-mode csharp-ts-mode)
                 "csharp-ls"))
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 "pyright-langserver" "--stdio"))
  (add-to-list 'eglot-server-programs
               '((typescript-mode typescript-ts-mode tsx-ts-mode js-mode js-ts-mode)
                 "typescript-language-server" "--stdio"))
  (add-to-list 'eglot-server-programs
               '(((rust-ts-mode :language-id "rust")
                  (rust-mode :language-id "rust")
                  (rustic-mode :language-id "rust"))
                 "rust-analyzer"))
  (add-to-list 'eglot-server-programs
               '(((go-mode :language-id "go")
                  (go-ts-mode :language-id "go")
                  (go-dot-mod-mode :language-id "go.mod"))
                 "gopls"))

  ;; Rust-analyzer & Gopls deep capabilities configuration
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer
                  (:check (:command "clippy")
                   :cargo (:allFeatures t
                           :loadOutDirsFromCheck t
                           :buildScripts (:enable t))
                   :procMacro (:enable t)
                   :inlayHints (:bindingModeHints (:enable :json-false)
                                :chainingHints (:enable :json-false)
                                :closingBraceHints (:enable :json-false)
                                :closureReturnTypeHints (:enable "never")
                                :lifetimeElisionHints (:enable "never")
                                :parameterHints (:enable :json-false)
                                :typeHints (:enable :json-false)
                                :reborrowHints (:enable "never"))
                   :completion (:autoimport (:enable t)
                                :postfix (:enable t)
                                :callable (:snippets "fill_arguments"))
                   :diagnostics (:experimental (:enable t))
                   :hover (:actions (:enable t)))
                  :gopls
                  (:staticcheck t
                   :completeUnimported t
                   :usePlaceholders t
                   :gofumpt t
                   :analyses
                   (:fieldalignment t
                    :nilness t
                    :shadow t
                    :unusedparams t
                    :unusedwrite t
                    :useany t
                    :unusedvariable t)
                   :hints
                   (:assignVariableTypes :json-false
                    :compositeLiteralFields :json-false
                    :compositeLiteralTypes :json-false
                    :constantValues :json-false
                    :functionTypeParameters :json-false
                    :parameterNames :json-false
                    :rangeVariableTypes :json-false)
                   :vulncheck "Imports"
                   :directoryFilters ["-.git" "-.vscode" "-.idea" "-node_modules"]))))

;; Automatically activate eglot on code buffers
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)
(add-hook 'c-ts-mode-hook #'eglot-ensure)
(add-hook 'c++-ts-mode-hook #'eglot-ensure)
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'python-ts-mode-hook #'eglot-ensure)
(add-hook 'typescript-mode-hook #'eglot-ensure)
(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
(add-hook 'js-mode-hook #'eglot-ensure)
(add-hook 'csharp-mode-hook #'eglot-ensure)
(add-hook 'csharp-ts-mode-hook #'eglot-ensure)
(add-hook 'rust-mode-hook #'eglot-ensure)
(add-hook 'rust-ts-mode-hook #'eglot-ensure)
(add-hook 'rustic-mode-hook #'eglot-ensure)
(add-hook 'go-mode-hook #'eglot-ensure)
(add-hook 'go-ts-mode-hook #'eglot-ensure)
(add-hook 'go-dot-mod-mode-hook #'eglot-ensure)

;; ==============================================================================
;; 13. RUST POWERHOUSE WORKFLOW
;; ==============================================================================

(after! rustic
  (setq rustic-lsp-client 'eglot
        rustic-format-on-save nil
        rustic-format-display-method 'pop-to-buffer))

;; Inlay hints disabled by default (no annoying inline text clutter)
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (when (fboundp 'eglot-inlay-hints-mode)
              (eglot-inlay-hints-mode -1))))

;; Leader key shortcut to toggle Inlay Hints on demand (SPC t i)
(map! :leader
      :desc "Toggle Inlay Hints" "t i" #'eglot-inlay-hints-mode)

;; Rust Keybindings (<leader> m / localleader in Rust buffers)
(map! :localleader
      :map (rustic-mode-map rust-mode-map rust-ts-mode-map)
      :desc "Cargo Run"          "r" #'rustic-cargo-run
      :desc "Cargo Build"        "b" #'rustic-cargo-build
      :desc "Cargo Check"        "c" #'rustic-cargo-check
      :desc "Cargo Clippy"       "k" #'rustic-cargo-clippy
      :desc "Cargo Test (all)"   "t" #'rustic-cargo-test
      :desc "Test under cursor"  "T" #'rustic-cargo-current-test
      :desc "Rustdoc Open"       "d" #'rustic-doc
      :desc "Expand Macro"       "e" #'rustic-expand
      :desc "Format Buffer"      "=" #'rustic-format-buffer)

;; ==============================================================================
;; 14. DOTNET / C# WORKFLOW & CONTROLS
;; ==============================================================================

(defvar my/dotnet-executable
  (or (executable-find "dotnet")
      (expand-file-name "~/.dotnet/dotnet")
      (expand-file-name "~/.local/bin/dotnet")
      "dotnet")
  "Path to the dotnet binary.")

(defun my/dotnet-new (name template)
  "Create a new .NET project with NAME and TEMPLATE and open Program.cs."
  (interactive
   (list (read-string "Project name: " "PracticalLab1")
         (completing-read "Template (default: console): " '("console" "webapi" "classlib" "webapp" "xunit") nil t nil nil "console")))
  (let* ((dotnet-bin my/dotnet-executable)
         (target-dir (expand-file-name name default-directory))
         (buf (get-buffer-create "*dotnet-create*")))
    (message "Scaffolding .NET project %s (%s)..." name template)
    (with-current-buffer buf
      (erase-buffer)
      (let ((exit-code (call-process dotnet-bin nil buf t "new" template "-n" name "-o" target-dir)))
        (if (zerop exit-code)
            (let ((entry-file (expand-file-name "Program.cs" target-dir)))
              (message "✓ Created project %s successfully!" name)
              (if (file-exists-p entry-file)
                  (find-file entry-file)
                (dired target-dir)))
          (display-buffer buf)
          (user-error "Failed to create project: check *dotnet-create* buffer"))))))

(defun my/dotnet-run ()
  "Run the current .NET project."
  (interactive)
  (compile (format "%s run" my/dotnet-executable)))

(defun my/dotnet-build ()
  "Build the current .NET project."
  (interactive)
  (compile (format "%s build" my/dotnet-executable)))

(defun my/dotnet-test ()
  "Run dotnet tests."
  (interactive)
  (compile (format "%s test" my/dotnet-executable)))

(defun my/dotnet-watch ()
  "Run dotnet watch run with live hot-reloading."
  (interactive)
  (compile (format "%s watch run" my/dotnet-executable)))

(defun my/dotnet-add-package (pkg)
  "Add a NuGet package to the current project."
  (interactive "sNuGet package name: ")
  (compile (format "%s add package %s" my/dotnet-executable pkg)))

;; Global Leader: SPC d (Dotnet)
(define-prefix-command 'my/dotnet-keymap)
(define-key doom-leader-map "d" 'my/dotnet-keymap)
(define-key my/dotnet-keymap (kbd "c") #'my/dotnet-new)
(define-key my/dotnet-keymap (kbd "n") #'my/dotnet-new)
(define-key my/dotnet-keymap (kbd "r") #'my/dotnet-run)
(define-key my/dotnet-keymap (kbd "b") #'my/dotnet-build)
(define-key my/dotnet-keymap (kbd "t") #'my/dotnet-test)
(define-key my/dotnet-keymap (kbd "w") #'my/dotnet-watch)
(define-key my/dotnet-keymap (kbd "a") #'my/dotnet-add-package)

(map! :leader
      (:prefix ("d" . "dotnet")
       :desc "Create New Project" "c" #'my/dotnet-new
       :desc "Create New Project" "n" #'my/dotnet-new
       :desc "Dotnet Run"         "r" #'my/dotnet-run
       :desc "Dotnet Build"       "b" #'my/dotnet-build
       :desc "Dotnet Test"        "t" #'my/dotnet-test
       :desc "Dotnet Watch (Hot)" "w" #'my/dotnet-watch
       :desc "Add NuGet Package"  "a" #'my/dotnet-add-package))

;; Localleader inside C# buffers (SPC m ...)
(map! :localleader
      :map (csharp-mode-map csharp-ts-mode-map)
      :desc "Dotnet Run"         "r" #'my/dotnet-run
      :desc "Dotnet Build"       "b" #'my/dotnet-build
      :desc "Dotnet Test"        "t" #'my/dotnet-test
      :desc "Dotnet Watch"       "w" #'my/dotnet-watch
      :desc "Add NuGet Package"  "a" #'my/dotnet-add-package
      :desc "New Project"        "n" #'my/dotnet-new)

;; ==============================================================================
;; 15. C / C++ RUNNER & WORKFLOW (SPC m r / SPC m b)
;; ==============================================================================

(defun my/c-cpp-run ()
  "Compile and run the current C/C++ file or run CMake build."
  (interactive)
  (let* ((file (buffer-file-name))
         (out (file-name-sans-extension (or file "a.out")))
         (is-cpp (and file (string-match-p "\\.\\(cpp\\|cc\\|cxx\\)$" file)))
         (compiler (if is-cpp "g++ -std=c++20 -O2 -Wall" "gcc -O2 -Wall")))
    (if (file-exists-p "CMakeLists.txt")
        (compile "cmake -B build && cmake --build build && ./build/$(basename $PWD)")
      (compile (format "%s %s -o %s && %s"
                       compiler
                       (shell-quote-argument file)
                       (shell-quote-argument out)
                       (shell-quote-argument out))))))

(defun my/c-cpp-build ()
  "Compile the current C/C++ file without running."
  (interactive)
  (let* ((file (buffer-file-name))
         (out (file-name-sans-extension (or file "a.out")))
         (is-cpp (and file (string-match-p "\\.\\(cpp\\|cc\\|cxx\\)$" file)))
         (compiler (if is-cpp "g++ -std=c++20 -O2 -Wall" "gcc -O2 -Wall")))
    (if (file-exists-p "CMakeLists.txt")
        (compile "cmake -B build && cmake --build build")
      (compile (format "%s %s -o %s"
                       compiler
                       (shell-quote-argument file)
                       (shell-quote-argument out))))))

(map! :localleader
      :map (c-mode-map c++-mode-map c-ts-mode-map c++-ts-mode-map)
      :desc "Compile & Run" "r" #'my/c-cpp-run
      :desc "Build Only"    "b" #'my/c-cpp-build)

;; ==============================================================================
;; 16. PYTHON RUNNER & WORKFLOW (SPC m r)
;; ==============================================================================

(defun my/python-run ()
  "Run the current Python file."
  (interactive)
  (compile (format "python3 %s" (shell-quote-argument (buffer-file-name)))))

(map! :localleader
      :map (python-mode-map python-ts-mode-map)
      :desc "Run Python Script" "r" #'my/python-run)

;; ==============================================================================
;; 17. TYPESCRIPT / JAVASCRIPT RUNNER (SPC m r)
;; ==============================================================================

(defun my/ts-js-run ()
  "Run current TypeScript or JavaScript file using ts-node/bun/node."
  (interactive)
  (let* ((file (buffer-file-name))
         (runner (cond
                  ((executable-find "bun") "bun run")
                  ((string-match-p "\\.ts$" (or file "")) "npx ts-node")
                  (t "node"))))
    (compile (format "%s %s" runner (shell-quote-argument file)))))

(map! :localleader
      :map (typescript-mode-map typescript-ts-mode-map js-mode-map js-ts-mode-map tsx-ts-mode-map)
      :desc "Run TS/JS Script" "r" #'my/ts-js-run)

;; ==============================================================================
;; 18. GO WORKFLOW & POWERHOUSE CONTROLS
;; ==============================================================================

(defun my/go-run ()
  "Run the current Go package or single file."
  (interactive)
  (let ((default-directory (or (doom-project-root) default-directory)))
    (compile "go run .")))

(defun my/go-build ()
  "Build the current Go project."
  (interactive)
  (let ((default-directory (or (doom-project-root) default-directory)))
    (compile "go build ./...")))

(defun my/go-test ()
  "Run all Go unit tests."
  (interactive)
  (let ((default-directory (or (doom-project-root) default-directory)))
    (compile "go test -v ./...")))

(defun my/go-test-current ()
  "Run the Go test under cursor."
  (interactive)
  (let* ((fn (which-function))
         (cmd (if (and fn (string-match-p "^Test" fn))
                  (format "go test -v -run '^%s$'" fn)
                "go test -v .")))
    (compile cmd)))

(defun my/go-lint ()
  "Run golangci-lint on the current Go module."
  (interactive)
  (let ((default-directory (or (doom-project-root) default-directory)))
    (compile "golangci-lint run")))

(defun my/go-mod-tidy ()
  "Run go mod tidy."
  (interactive)
  (let ((default-directory (or (doom-project-root) default-directory)))
    (compile "go mod tidy")))

(defun my/go-doc ()
  "Look up Go documentation for symbol under cursor."
  (interactive)
  (let ((sym (thing-at-point 'symbol t)))
    (if sym
        (compile (format "go doc %s" sym))
      (user-error "No symbol under cursor"))))

(defun my/go-organize-imports ()
  "Organize Go imports using Eglot/gopls."
  (interactive)
  (if (bound-and-true-p eglot--managed-mode)
      (eglot-code-action-organize-imports (point-min) (point-max))
    (user-error "Eglot is not active in this buffer")))

(defun my/go-before-save-hook ()
  "Automatically organize imports and format Go buffers before saving."
  (when (and (bound-and-true-p eglot--managed-mode)
             (derived-mode-p 'go-mode 'go-ts-mode))
    (ignore-errors
      (eglot-code-action-organize-imports (point-min) (point-max)))
    (ignore-errors
      (eglot-format-buffer))))

(add-hook 'before-save-hook #'my/go-before-save-hook)

(map! :localleader
      :map (go-mode-map go-ts-mode-map)
      :desc "Go Run"                "r" #'my/go-run
      :desc "Go Build"              "b" #'my/go-build
      :desc "Go Test (All)"         "t" #'my/go-test
      :desc "Go Test (Current)"     "T" #'my/go-test-current
      :desc "Golangci-lint (Check)" "c" #'my/go-lint
      :desc "Go Mod Tidy"           "g" #'my/go-mod-tidy
      :desc "Go Doc"                "d" #'my/go-doc
      :desc "Organize Imports"      "i" #'my/go-organize-imports
      :desc "Format Buffer"         "=" #'eglot-format-buffer)

;; ==============================================================================
;; 12. SAFE RELOAD OVERRIDE (Fixes broken SPC h r r)
;; ==============================================================================
(defun my/safe-reload-config ()
  "Safely reload Doom private config without breaking memory/profiles."
  (interactive)
  (load-file (expand-file-name "config.el" doom-user-dir))
  (message "✓ Config reloaded safely!"))

(map! :leader
      :desc "Safe reload config" "h r r" #'my/safe-reload-config)

;; ==============================================================================
;; 13. PI AGENT INTEGRATION
;; ==============================================================================
;; 13. PI AGENT INTEGRATION (CYBERPUNK EDGERUNNER AI ASSISTANT)
;; ==============================================================================
(require 'vterm nil t)

(defun +pi--project-root ()
  "Get current project root or default directory."
  (or (and (fboundp 'doom-project-root) (doom-project-root))
      default-directory))

(defun +pi-buffer-for-project ()
  "Get or create a project-specific Pi buffer."
  (let* ((root (+pi--project-root))
         (proj-name (file-name-nondirectory (directory-file-name (expand-file-name root))))
         (buf-name (format "*pi:%s*" proj-name))
         (buf (get-buffer buf-name)))
    (if (and buf (buffer-live-p buf) (get-buffer-process buf))
        buf
      (when (and buf (buffer-live-p buf))
        (kill-buffer buf))
      (let* ((default-directory root)
             (new-buf (get-buffer-create buf-name)))
        (with-current-buffer new-buf
          (unless (derived-mode-p 'vterm-mode)
            (vterm-mode))
          (vterm-send-string "pi\n"))
        new-buf))))

(defun +pi/toggle ()
  "Toggle the Pi coding agent side-panel popup for the current project."
  (interactive)
  (let* ((root (+pi--project-root))
         (proj-name (file-name-nondirectory (directory-file-name (expand-file-name root))))
         (buf-name (format "*pi:%s*" proj-name))
         (buf (get-buffer buf-name)))
    (if (and buf (get-buffer-window buf))
        (delete-window (get-buffer-window buf))
      (pop-to-buffer (+pi-buffer-for-project)))))

(defun +pi/send-region (start end)
  "Send selected region to the active Pi session with buffer context."
  (interactive "r")
  (let* ((text (buffer-substring-no-properties start end))
         (file (or (buffer-file-name) (buffer-name)))
         (mode (symbol-name major-mode))
         (payload (format "File: %s\n```%s\n%s\n```\n" file mode text))
         (buf (+pi-buffer-for-project)))
    (with-current-buffer buf
      (vterm-send-string payload))
    (pop-to-buffer buf)))

(defun +pi/ask (prompt)
  "Send an interactive prompt to the current Pi agent."
  (interactive "sAsk Pi: ")
  (let ((buf (+pi-buffer-for-project)))
    (with-current-buffer buf
      (vterm-send-string (concat prompt "\n")))
    (pop-to-buffer buf)))

;; Popup rule for Pi Agent window (docked right, clean width)
(set-popup-rule! "^\\*pi:.*\\*" :side 'right :size 0.42 :select t :quit nil :ttl nil)

;; ==============================================================================
;; 14. QUICK FONT / TEXT ZOOM SHORTCUTS
;; ==============================================================================
(map! :leader
      :desc "Zoom text in"    "=" #'text-scale-increase
      :desc "Zoom text out"   "-" #'text-scale-decrease
      :desc "Reset text zoom" "0" (cmd! (text-scale-set 0)))

;; ==============================================================================
;; 15. INSERT & VISUAL MODE UNDO / REDO (Ctrl+Z / Ctrl+Y)
;; ==============================================================================
(map! :i "C-z"   #'undo-fu-only-undo
      :i "C-S-z" #'undo-fu-only-redo
      :i "C-y"   #'undo-fu-only-redo
      :v "C-z"   #'undo-fu-only-undo
      :v "C-S-z" #'undo-fu-only-redo)

;; ==============================================================================
;; 16. MEMORY MANAGEMENT & UNDO TUNING
;; ==============================================================================
(after! gcmh
  (setq gcmh-high-cons-threshold (* 256 1024 1024)  ; 256MB during editing
        gcmh-idle-delay 1.0))

(setq undo-limit (* 32 1024 1024)         ; 32MB
      undo-strong-limit (* 64 1024 1024)  ; 64MB
      undo-outer-limit (* 128 1024 1024)) ; 128MB

;; Suppress disruptive popup when undo history exceeds boundary
(add-to-list 'warning-suppress-types '(undo discard-info))








