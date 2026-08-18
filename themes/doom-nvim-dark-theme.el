;;; doom-nvim-dark-theme.el --- Neovim 0.10 Dark theme for Doom Emacs -*- lexical-binding: t; no-byte-compile: t; -*-

(require 'doom-themes)

;;
;;; Theme definition

(def-doom-theme doom-nvim-dark
  "Neovim 0.10 default dark color palette for Doom Emacs."

  ;; name        default   256       16
  ((bg         '("#14161b" "#14161b" nil))
   (bg-alt     '("#1c1f26" "#1c1f26" nil))
   (base0      '("#0f1115" "#0f1115" "black"))
   (base1      '("#14161b" "#14161b" "brightblack"))
   (base2      '("#1c1f26" "#1c1f26" "brightblack"))
   (base3      '("#232731" "#232731" "brightblack"))
   (base4      '("#2e3440" "#2e3440" "brightblack"))
   (base5      '("#3f4758" "#3f4758" "brightblack"))
   (base6      '("#545f76" "#545f76" "brightblack"))
   (base7      '("#8c97aa" "#8c97aa" "brightblack"))
   (base8      '("#f4f5f8" "#f4f5f8" "white"))
   (fg         '("#e0e2ea" "#e0e2ea" "brightwhite"))
   (fg-alt     '("#8c97aa" "#8c97aa" "white"))

   (grey base7)
   (red          '("#ff657a" "#ff657a" "red"))
   (orange       '("#ff9e64" "#ff9e64" "brightred"))
   (green        '("#85dacc" "#85dacc" "green"))
   (teal         '("#49d0c5" "#49d0c5" "brightgreen"))
   (yellow       '("#f1cf8a" "#f1cf8a" "brightyellow"))
   (blue         '("#6c99bb" "#6c99bb" "brightblue"))
   (dark-blue    '("#2a324b" "#2a324b" "blue"))
   (magenta      '("#e0a3ff" "#e0a3ff" "brightmagenta"))
   (violet       '("#cf9bc2" "#cf9bc2" "magenta"))
   (cyan         '("#8cf8f7" "#8cf8f7" "brightcyan"))
   (dark-cyan    '("#2c5d63" "#2c5d63" "cyan"))

   ;; face categories
   (highlight      cyan)
   (vertical-bar   base4)
   (selection      dark-blue)
   (builtin        magenta)
   (comments       base7)
   (doc-comments   base6)
   (constants      orange)
   (functions      cyan)
   (keywords       blue)
   (methods        cyan)
   (operators      cyan)
   (type           teal)
   (strings        green)
   (variables      fg)
   (numbers        orange)
   (region         dark-blue)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    yellow)
   (vc-added       green)
   (vc-deleted     red)

   ;; modeline
   (modeline-bg     base2)
   (modeline-bg-alt base0)
   (modeline-fg     fg)
   (modeline-fg-alt base7))

  ;;;; Base theme face overrides
  ((lazy-highlight :background base4 :foreground fg :weight 'bold)
   (mode-line
    :background modeline-bg :foreground modeline-fg)
   (mode-line-inactive
    :background modeline-bg-alt :foreground modeline-fg-alt)
   (mode-line-emphasis
    :foreground cyan :weight 'bold)
   (line-number :foreground base6 :background bg)
   (line-number-current-line :foreground cyan :background bg-alt :weight 'bold)
   (doom-modeline-bar :background cyan)))

;;; doom-nvim-dark-theme.el ends here
