;; This is the official Emacs init file for the course IOOPM. It
;; uses English, not because anyone thinks it's cooler than
;; Swedish, but to avoid encoding problems with using Swedish
;; characters. Put it in `~/.emacs.d/init.el` to use it for your
;; own Emacs. You can use as many or as few of these settings as
;; you would like. Experiment and try to find a set-up that suits
;; you!
;;
;; Some settings in this file are commented out. They are the ones
;; that require some choice of parameter (such as a color) or that
;; might be considered more intrusive than other settings (such as
;; linum-mode).
;;
;; Whenever you come across something that looks like this
;;
;;    (global-set-key (kbd "C-e") 'move-end-of-line)
;;
;; it is a command that sets the keyboard shortcut for some
;; function. If you find a function that you like, whose keyboard
;; shortcut you don't like, you can (and should!) always change it to
;; something that you do like.

;; ===========
;; Appearance
;; ===========

;; Disable the menu bar
;; (if (fboundp 'menu-bar-mode)
;;   (menu-bar-mode -1))

;; Disable the tool bar
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

;; Disable the scroll bar
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

;; Turn off annoying splash screen
(setq inhibit-splash-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)

;; When in doubt, use text-mode
(setq default-major-mode 'text-mode)

;; Show time using Swedish format
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;; Set which colors to use
;; You can see a list of all the available colors by checking the
;; variable "color-name-rgb-alist" (Type "C-h v color-name-rgb-alist
;; <RET>"). Most normal color names work, like black, white, red,
;; green, blue, etc.
; (set-background-color "black")
; (set-foreground-color "white")
; (set-cursor-color "white")

;; Set a custom color theme
;; You can also try using a custom theme, which changes more colors
;; than just the three above. For a list of all available themes,
;; press "M-x customize-themes <RET>". You can also use a theme in
;; combination with the above set-color-commands.
;(if display-graphic-p
;    (progn
;      (load-theme 'wombat)))

;; =====
;; PATH
;; =====

;; This sets the Emacs "PATH" environment variable and the `exec-path`
;; variable to the same value your login shell sees. The reason this
;; is necessary is because of this:
;;
;; http://developer.apple.com/library/mac/#qa/qa1067/_index.html
;;
;; Basically apps launched from Finder inherit their environment from
;; a .plist file rather than the shell environment.

(setq extra-path
      (concat ":/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
              ":/opt/local/bin:/usr/texbin:/Users/Elias/shortcuts"
              ":/Users/Elias/Library/Haskell/bin:/Users/Elias/.cabal/bin"))

(defun set-exec-path-from-shell-PATH ()
  "Sets the exec-path to the same value used by the user shell"
  (let ((path-from-shell
         (replace-regexp-in-string
          "[[:space:]\n]*$" ""
          (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" (concat path-from-shell extra-path))
    (setq exec-path (split-string path-from-shell path-separator))))

;; call function now
(set-exec-path-from-shell-PATH)

;; =========
;; Packages
;; =========

;; Use more package-archives (M-x list-packages)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Tell Emacs where to look for packages
(let ((default-directory "~/.emacs.d/ioopm-packages/"))
  (normal-top-level-add-subdirs-to-load-path))

(let ((default-directory "~/.emacs.d/elpa/"))
  (normal-top-level-add-subdirs-to-load-path))

;; ===========
;; Navigation
;; ===========

;; Show both line and column number in the bottom of the buffer
(column-number-mode t)

;; Show parenthesis matching the one below the cursor
(show-paren-mode t)

;; Show line numbers to the left of all buffers
; (global-linum-mode t)

;; Sentences are not followed by two spaces
;; Makes navigating with M-e and M-a (forward/backward senctence)
;; behave like you would expect
(setq sentence-end-double-space nil)

;; C-SPC after C-u C-SPC cycles mark stack
(setq-default set-mark-command-repeat-pop t)

;; Move entire paragraph with M-n/M-p
(global-set-key "\M-n" 'forward-paragraph)
(global-set-key "\M-p" 'backward-paragraph)

;; Back to indentation with M-a
(global-set-key "\M-a" 'back-to-indentation)

;; Avy mode
;; Jump anywhere on screen in four keystrokes or less.
(require 'avy)
(define-key global-map (kbd "C-j") 'avy-goto-word-or-subword-1)
(define-key global-map (kbd "C-M-j") 'avy-goto-char)
(define-key global-map (kbd "C-M-l") 'avy-goto-line)

;; Ace window
;; Select which window to switch to, rather than shuffling through them all
(require 'ace-window)
;(global-set-key (kbd "C-x o") 'ace-window)


;; imenu
;; Language-aware navigation
(require 'imenu-anywhere)
(setq imenu-auto-rescan t)
(global-set-key (kbd "C-.") 'imenu-anywhere)

;; ===========
;; Editing
;; ===========

;; Allow deletion of selected text with <DEL>
(delete-selection-mode 1)

;; Use multiple spaces instead of tab characters
(setq-default indent-tabs-mode nil)

;; hippie-expand instead of dabbrev-expand
;; dabbrev-expand will try to expand the word under the cursor by
;; searching your open buffers for words beginning with the same
;; characters. For example, if you have written "printf" in an open
;; buffer you can just write "pr" and expand it to the full
;; word. hippie-expand does the same kind of search, plus some
;; additional searching, such as in your kill ring or the names of the
;; files you have open.
(global-set-key [(control tab)] 'hippie-expand)

;; Expand from everything!
(setq hippie-expand-try-functions-list
  '(try-expand-dabbrev
    try-expand-dabbrev-all-buffers
    try-complete-file-name-partially
    try-complete-file-name
    try-expand-all-abbrevs
    try-expand-list
    try-expand-dabbrev-from-kill
    try-expand-line
    try-complete-lisp-symbol-partially
    try-complete-lisp-symbol))

;; Auto complete mode
;; Always suggest completions.
 (require 'popup)
 (require 'auto-complete)
 (global-set-key (kbd "C-<return>")
                 (lambda () (interactive)
                   (progn (auto-complete-mode 1) (auto-complete))))
;; Alternate auto-complete (add-hook 'after-init-hook 'global-company-mode)

;; Visual Regexp
;; Replace normal query-replace with a better one
(require 'visual-regexp)
(global-set-key "\M-%" 'vr/query-replace)

;; Multiple cursors
;; What it sounds like
(require 'multiple-cursors)

;; Suggested bindings
; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
; (global-set-key (kbd "C-M-c") 'mc/edit-lines)

;; Expand region
;; Select the thing I'm currently inside
(require 'expand-region)
(global-set-key (kbd "M-h") 'er/expand-region)

;; ==========
;; Interface
;; ==========

;; Use alt for meta and cmd for super (interferes less with the OS)
(setq mac-command-modifier  'super)
(setq mac-option-modifier  'meta)

;; Teach Emacs Swedish keyboard layout
(define-key key-translation-map (kbd "M-8") (kbd "["))
(define-key key-translation-map (kbd "M-9") (kbd "]"))

(define-key key-translation-map (kbd "M-(") (kbd "{"))
(define-key key-translation-map (kbd "M-)") (kbd "}"))

(define-key key-translation-map (kbd "M-7") (kbd "|"))
(define-key key-translation-map (kbd "M-/") (kbd "\\"))

(define-key key-translation-map (kbd "M-2") (kbd "@"))
(define-key key-translation-map (kbd "M-4") (kbd "$"))

;; fn --> hyper
;; Allow using fn as modifier
; (setq mac-function-modifier 'hyper)
 
;; ido mode
;; Automatic auto-complete for many things, including opening files.
(ido-mode)

;; Don't automatically select things though...
(setq ido-auto-merge-delay-time 9999)

;; smex
;; M-x on steroids
(require 'smex)
(global-set-key "\M-x" 'smex)

;; Uniquify buffernames
;; Give better names to buffers of same name
(require 'uniquify)

;; Save-place
;; Remember the cursor position when you close a file, so that you
;; start with the cursor in the same position when opening it again
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

;; Recent files
;; Enable a command to list your most recently edited files. If you
;; know you are opening a file that you have edited recently, this
;; should be faster than using find-file ("C-x C-f"). The code below
;; binds this to the keyboard shortcut "C-x C-r", which replaces the
;; shortcut for the command find-file-read-only.
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(global-set-key "\C-x\C-r" 'recentf-ido-find-file)

(add-to-list 'load-path "/some/path/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; ============
;; Programming
;; ============

;; Flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(when (require 'flymake)
  (set-variable 'flymake-log-level 9)
  (setq flymake-start-syntax-check-on-newline nil)
  (setq flymake-no-changes-timeout 10)
  (add-hook 'java-mode-hook 'flymake-mode-on))
(defun my-java-flymake-init ()
  (list "javac" (list (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-with-folder-structure))))
(add-to-list 'flymake-allowed-file-name-masks '("\\.java$" my-java-flymake-init flymake-simple-cleanup))

;; Key binding for finding next error
(dolist (hook '(prog-mode-hook))
  (add-hook hook
            (lambda () (interactive)
              (local-set-key (kbd "C-c C-n")
                             'next-error))))

;; Key binding for finding previous error
(dolist (hook '(prog-mode-hook))
  (add-hook hook
            (lambda () (interactive)
              (local-set-key (kbd "C-c C-p")
                             'previous-error))))

;; Display flymake errors in minibuffer
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default)))
 '(help-at-pt-display-when-idle (quote (flymake-overlay)) nil (help-at-pt))
 '(help-at-pt-timer-delay 0.2))

;; YASnippets
;; Expand e.g. "for<tab>" to "for(int i = 0; i < N; i++) {}"
(require 'yasnippet)
(yas-global-mode 1)

;; Themes


  (require 'color-theme-sanityinc-tomorrow)
(load-theme 'sanityinc-tomorrow-eighties)
 (require 'doom-themes)
  ;;(load-theme 'doom-one t) ;; or doom-dark, etc.

  ;;; OPTIONAL
  ;; brighter source buffers
  (add-hook 'find-file-hook 'doom-buffer-mode)
  ;; brighter minibuffer when active
  (add-hook 'minibuffer-setup-hook 'doom-brighten-minibuffer)
  ;; Custom neotree theme
  (require 'doom-neotree)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
