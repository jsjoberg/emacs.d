(setq gc-cons-threshold (* 32 1024 1024)
      large-file-warning-threshold (* 100 1024 1024)
      inhibit-splash-screen t)

(setq backup-directory-alist `(("." . "~/.emacs.d/backup/"))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq c-default-style "linux"
      c-basic-offset 4
      tab-width 4
      indent-tabs-mode nil)

(setq ido-enable-flex-matching t
      ido-case-fold t)

(defalias 'yes-or-no-p 'y-or-n-p)

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(scroll-bar-lines . 0) default-frame-alist)
(push '(fullscreen . maximized) default-frame-alist)

(set-face-attribute 'default nil :family "Fantasque Sans Mono" :height 100 :weight 'normal)

(add-hook 'after-init-hook 'ido-mode)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)

(blink-cursor-mode -1)


(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(use-package straight :custom (straight-use-package-by-default t))

(use-package company
  :config
  (setq company-idle-delay 0.0
	company-minimum-prefix-length 1)
  (global-company-mode +1))

(use-package doom-modeline :config (doom-modeline-mode +1))
(use-package dracula-theme :config (load-theme 'dracula t))
(use-package magit)
(use-package rustic)
(use-package tree-sitter :config (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
(use-package tree-sitter-langs :after tree-sitter)
(use-package vterm)
(use-package vterm-toggle :after vterm)

(use-package meow
  :config
  (defun meow-setup ()
    (defconst meow-cheatsheet-layout-qwerty-swedish
      '((<TLDE> "??" "??") (<AE01> "1" "!") (<AE02> "2" "\"") (<AE03> "3" "#") (<AE04> "4" "??") (<AE05> "5" "%") (<AE06> "6" "&")
	(<AE07> "7" "/") (<AE08> "8" "(") (<AE09> "9" ")") (<AE10> "0" "=") (<AE11> "+" "?") (<AE12> "??" "`") (<AD01> "q" "Q")
	(<AD02> "w" "W") (<AD03> "e" "E") (<AD04> "r" "R") (<AD05> "t" "T") (<AD06> "y" "Y") (<AD07> "u" "U") (<AD08> "i" "I")
	(<AD09> "o" "O") (<AD10> "p" "P") (<AD11> "??" "??") (<AD12> "??" "^") (<AC01> "a" "A") (<AC02> "s" "S") (<AC03> "d" "D")
	(<AC04> "f" "F") (<AC05> "g" "G") (<AC06> "h" "H") (<AC07> "j" "J") (<AC08> "k" "K") (<AC09> "l" "L") (<AC10> "??" "??")
	(<AC11> "??" "??") (<BKSL> "'" "*") (<LSGT> "<" ">") (<AB01> "z" "Z") (<AB02> "x" "X") (<AB03> "c" "C") (<AB04> "v" "V")
	(<AB05> "b" "B") (<AB06> "n" "N") (<AB07> "m" "M") (<AB08> "," ";") (<AB09> "." ":") (<AB10> "-" "_")))
    (setq meow-cheatsheet-physical-layout meow-cheatsheet-physical-layout-iso)
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty-swedish)
    (meow-define-keys 'insert '("C-c" . meow-normal-mode))
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))
    (meow-leader-define-key
     ;; SPC j/k will run the original command in MOTION state.
     '("j" . "H-j")
     '("k" . "H-k")
     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("??" . ido-find-file)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-delete)
     '("D" . meow-backward-delete)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("M" . magit)
     '("n" . meow-search)
     '("N" . display-line-numbers-mode)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("P" . previous-buffer)
     '("q" . meow-quit)
     '("Q" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-kill)
     '("S" . text-scale-decrease)
     '("t" . meow-till)
     '("T" . vterm-toggle)
     '("u" . meow-undo)
     '("U" . meow-undo-in-selection)
     '("v" . meow-visit)
     '("V" . text-scale-increase)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . meow-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("??" . ido-find-file)
     '("??" . meow-end-of-thing)
     '("??" . eglot-find-declaration)
     '("??" . meow-beginning-of-thing)
     '("??" . eglot-find-implementation)
     '("'" . repeat)
     '("<escape>" . ignore)))
  (meow-setup)
  (meow-global-mode +1))
