(setq
 gc-cons-threshold most-positive-fixnum  ; motto: clean later
 large-file-warning-threshold (* 100 1024 1024)
 inhibit-splash-screen t
 ;;
 backup-directory-alist `(("." . "~/.emacs.d/backup/"))
 backup-by-copying t
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
 ;;
 c-default-style "linux"
 c-basic-offset 4
 tab-width 4
 indent-tabs-mode nil
 ;;
 ido-enable-flex-matching t
 ido-case-fold t
 )

(defalias 'yes-or-no-p 'y-or-n-p)

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(scroll-bar-lines . 0) default-frame-alist)

(defvar big-face-state 't)
(defun big-face ()
  (interactive)
  (setq big-face-state (not big-face-state))
  (set-face-attribute
   'default nil
   :family (if big-face-state "Spleen 32x64" "Spleen 16x32")
   :height (if big-face-state 250 100)))
(mapc
 (lambda (face)
   (set-face-attribute face nil :weight 'normal :underline nil))
 (face-list))
(set-face-attribute 'default nil :weight 'normal)
(big-face)

(add-hook 'after-init-hook 'ido-mode)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)

;; end of vanilla section

(setq
 company-idle-delay 0.0
 company-minimum-prefix-length 1
 )

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

(mapc
 'straight-use-package
 '(use-package
   company
   doom-modeline
   dracula-theme
   magit
   meow
   rustic
   tree-sitter
   tree-sitter-langs
   vterm
   vterm-toggle))

(load-theme 'dracula t)

(add-hook 'after-init-hook 'meow-global-mode)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'doom-modeline-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

(require 'meow)

(defconst meow-cheatsheet-layout-qwerty-swedish
  '((<TLDE> "§" "½") (<AE01> "1" "!") (<AE02> "2" "\"") (<AE03> "3" "#") (<AE04> "4" "¤") (<AE05> "5" "%") (<AE06> "6" "&")
    (<AE07> "7" "/") (<AE08> "8" "(") (<AE09> "9" ")") (<AE10> "0" "=") (<AE11> "+" "?") (<AE12> "´" "`") (<AD01> "q" "Q")
    (<AD02> "w" "W") (<AD03> "e" "E") (<AD04> "r" "R") (<AD05> "t" "T") (<AD06> "y" "Y") (<AD07> "u" "U") (<AD08> "i" "I")
    (<AD09> "o" "O") (<AD10> "p" "P") (<AD11> "å" "Å") (<AD12> "¨" "^") (<AC01> "a" "A") (<AC02> "s" "S") (<AC03> "d" "D")
    (<AC04> "f" "F") (<AC05> "g" "G") (<AC06> "h" "H") (<AC07> "j" "J") (<AC08> "k" "K") (<AC09> "l" "L") (<AC10> "ö" "Ö")
    (<AC11> "ä" "Ä") (<BKSL> "'" "*") (<LSGT> "<" ">") (<AB01> "z" "Z") (<AB02> "x" "X") (<AB03> "c" "C") (<AB04> "v" "V")
    (<AB05> "b" "B") (<AB06> "n" "N") (<AB07> "m" "M") (<AB08> "," ";") (<AB09> "." ":") (<AB10> "-" "_")))

(defun meow-setup ()
  (setq
   meow-cheatsheet-physical-layout meow-cheatsheet-physical-layout-iso
   meow-cheatsheet-layout meow-cheatsheet-layout-qwerty-swedish)
  (meow-motion-overwrite-define-key
   '("j" . meow-next) '("k" . meow-prev) '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j") '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument) '("2" . meow-digit-argument)      '("3" . meow-digit-argument)
   '("4" . meow-digit-argument) '("5" . meow-digit-argument)      '("6" . meow-digit-argument)
   '("7" . meow-digit-argument) '("8" . meow-digit-argument)      '("9" . meow-digit-argument)
   '("0" . meow-digit-argument) '("/" . meow-keypad-describe-key) '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0) '("9" . meow-expand-9) '("8" . meow-expand-8)
   '("7" . meow-expand-7) '("6" . meow-expand-6) '("5" . meow-expand-5)
   '("4" . meow-expand-4) '("3" . meow-expand-3) '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)   '(";" . meow-reverse)
   '("," . meow-inner-of-thing) '("." . meow-bounds-of-thing)
   '("a" . meow-append)    '("A" . meow-open-below)
   '("b" . meow-back-word) '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)    '("D" . meow-backward-delete)
   '("e" . meow-next-word) '("E" . meow-next-symbol)
   '("f" . meow-find)      '("F" . meow-goto-line)
   '("g" . meow-cancel-selection) '("G" . meow-grab)
   '("h" . meow-left)      '("H" . meow-left-expand)
   '("i" . meow-insert)    '("I" . meow-open-above)
   '("j" . meow-next)      '("J" . meow-next-expand)
   '("k" . meow-prev)      '("K" . meow-prev-expand)
   '("l" . meow-right)     '("L" . meow-right-expand)
   '("m" . meow-join)      '("M" . display-line-numbers-mode)
   '("n" . meow-search)
   '("o" . meow-block)     '("O" . meow-to-block)
   '("p" . meow-yank)      '("P" . previous-buffer)
   '("q" . meow-quit)      '("Q" . meow-goto-line)
   '("r" . meow-replace)   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)      '("T" . vterm-toggle)
   '("u" . meow-undo)      '("U" . meow-undo-in-selection)
   '("v" . meow-visit)     '("V" . big-face)
   '("w" . meow-mark-word) '("W" . meow-mark-symbol)
   '("x" . meow-line)      '("X" . meow-goto-line)
   '("y" . meow-save)      '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   ;'("å" . nil)
   '("ä" . meow-end-of-thing)       '("Ä" . eglot-find-declaration)
   '("ö" . meow-beginning-of-thing) '("Ö" . eglot-find-implementation)
   '("'" . repeat)
   '("§" . ido-find-file)
   '("<escape>" . ignore))
  (meow-define-keys 'insert '("C-c" . meow-normal-mode)))

(meow-setup)

(add-hook
 'after-init-hook
 (lambda ()
   (setq gc-cons-threshold (* 32 1024 1024))))  ; motto: keep your word
