;;; init.el --- Emacs init -*- lexical-binding: t; -*-

;; Commentary:
;;

;; Problems:


;;; * Package repo setup and quickstart-----
(require 'package) ; needed for package-archive variable
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-quickstart t)


;; Load custom configuration file
(setq custom-file (expand-file-name "custom.el" "~/org/emacs_d/"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Append personal info directory to list
(with-eval-after-load 'info
  (add-to-list 'Info-additional-directory-list
               "~/org/emacs_d/info"))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/")) ;; elisp packages not in pkg mgr


;;; * Basic Emacs options -----
;; Force default socket-dir "/tmp/emacs{uid}"
(use-package server
  :defer 1
  :if (display-graphic-p)
  :config
  (setq server-client-instructions nil) ; don't display disconnect instrs
  (setq server-socket-dir (format "/tmp/emacs%d" (user-uid)))
  (unless (server-running-p) (server-start)))

(use-package emacs
  :init
  (setq use-short-answers t            ; use 'y" and "n"
        confirm-kill-emacs 'yes-or-no-p
        scroll-conservatively 101      ; don't jump scroll at window bottom
        help-window-select t
        backup-by-copying t
        backup-directory-alist '((cons "."
          (file-name-concat user-emacs-directory "backup/")))
        create-lockfiles nil
        initial-scratch-message ""
        initial-major-mode 'text-mode
        custom-safe-themes t           ; treat all themes as safe
        initial-buffer-choice t)       ; open scratch buffer at startup
  :config
  (setq-default truncate-lines t
                display-line-numbers-width 3
                indent-tabs-mode nil   ; use spaces instead of tabs
                fill-column 100
                tab-width 4)

  (auto-save-visited-mode 1)
  ;(tool-bar-mode -1)
  ;(menu-bar-mode -1)
  (xterm-mouse-mode 1)
  (setq x-select-enable-primary t) ; use primary X selection mechanism
  (setq mouse-drag-copy-region t)  ; copy selection to kill ring immediately
  (show-paren-mode 1)
  (global-display-line-numbers-mode 1)
  (fringe-mode '(8 . 8))

  (setq user-full-name "Douglas Jackson" ; whoami
        user-mail-address "hpotter@hogworts.edu")

  ;;; Customize Modeline -----
  ;; make the read-only and modified indicators more noticeable.
  (setq-default mode-line-modified        ; not customizable
                '((:eval (if buffer-read-only
                             (propertize "R" 'face 'warning) ;; was %
                           "-"))
                  (:eval (if (buffer-modified-p)
                             (propertize "*" 'face 'error) ;; was *
                           "-"))))
  ;;(setopt mode-line-compact 'long)

  ;;; Enable disabled functions
  (global-unset-key (kbd "C-x C-u")) ; default is `upcase-region'-region'
  (global-unset-key (kbd "C-x C-l")) ; default is `downcase-region'
  (global-set-key (kbd "C-x C-u") #'upcase-dwim)   ; was M-u
  (global-set-key (kbd "C-x C-l") #'downcase-dwim) ; was M-l

  ;; Goal Column, enter C-x C-n, at point to set column that C-n should go to
  ;; to clear enter C-u C-x C-n
  (put 'set-goal-column 'disabled nil)

  ;;; Global key bindings
  ;; Show a summery of all registers with content
  (global-set-key (kbd "C-x r v") 'list-registers)

  ;; Move through windows in reverse order of (other-window), C-x o
  (global-set-key (kbd "C-x O") 'previous-multiframe-window)

  ;; Invoke M-x without the Alt key (from Steve Yegge's blog)
  (global-set-key (kbd "C-x C-m") 'execute-extended-command)
  ;(global-set-key (kbd "C-c C-m") 'execute-extended-command) ; remapped by org to org-ctrl-c-ret

  ;; Enable line-numbers-mode for all programming languages
  ;(add-hook 'prog-mode-hook 'display-line-numbers-mode)

  ;; Disable line numbers for some modes
  (dolist (mode '(org-mode-hook
                  term-mode-hook
                  shell-mode-hook
                  eshell-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))

  ;; enable delete selection mode, so pasting overwrites selection
  (delete-selection-mode 1)

  ;; set default shell to zsh
  (setq explicit-shell-file-name "/bin/zsh")
  (setq shell-file-name "zsh")
  (setq explicit-bash.exe-args '("--noediting" "--login" "-i"))
  (setenv "SHELL" shell-file-name)

  ;; Remove trailing whitespace on save
  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  ;; automatically follow symlinks to files under version control without prompting
  (setq vc-follow-symlinks t)

  ;; Enable holidays in Calendar and week-start-day
  (setq mark-holidays-in-calendar t
        calendar-week-start-day 0)

  ;; Emacs 24.4 and later now include something similar: Rectangle Mark mode. After a region is active, type ‘C-x SPC’ to toggle it on and off.
  ;;; http://emacs-fu.blogspot.com/2010/01/rectangles-and-cua.html
  (global-unset-key "\C-z")
  ;(setq cua-rectangle-mark-key (kbd "C-z '"))
  (setq cua-rectangle-mark-key (kbd "C-z C-SPC"))  ;; instead of Ctrl-Enter
  (cua-selection-mode t)

  ;; Alias to change apropos to ap
  (defalias 'ap 'apropos)

  ;; hl-line: highlight the current line
  (when (fboundp 'global-hl-line-mode)
    (global-hl-line-mode t)) ;; turn it on for all modes by default

  ;;; Highlight regions and add special behaviors to regions.
  ;;; "C-h d transient" for more info.  transient-mark-mode is a toggle.
  ;;; also in Emacs 22 and greater, C-SPC twice to temp enable transient mark
  ;(setq transient-mark-mode nil)
  (setq transient-mark-mode t)

  ;; Display line and column numbers in the mode line
  (setq line-number-mode t
        column-number-mode t)

  ;; Stop blinking cursor
  (blink-cursor-mode 0)

  ;; Explicitly show the end of a buffer (indicated on left fringe of window)
  (set-default 'indicate-empty-lines t)

  ;; Goal Column, enter C-x C-n, at point to set column that C-n should go to
  ;; to clear enter C-u C-x C-n
  (put 'set-goal-column 'disabled nil)
  ;; Restrict buffer editing to a region
  (put 'narrow-to-region 'disabled nil)
  (global-unset-key (kbd "C-x n n"))

  ;;; Functions
  ;; ---------------------------------------------------------------------------
  ;; https://gist.github.com/mwfogleman/95cc60c87a9323876c6c
  ;; http://endlessparentheses.com/emacs-narrow-or-widen-dwim.html
  (defun narrow-or-widen-dwim ()
    "If the buffer is narrowed, it widens. Otherwise, it narrows to region, or Org subtree."
    (interactive)
    (cond ((buffer-narrowed-p) (widen))
          ((region-active-p) (narrow-to-region (region-beginning) (region-end)))
          ((equal major-mode 'org-mode) (org-narrow-to-subtree))
          (t (error "Please select a region to narrow to"))))
  (global-set-key (kbd "C-x n n") 'narrow-or-widen-dwim)  ; was: C-c n then C-c x then C-x n n
  ;; I bind this key to C-c n, using the bind-key function that comes with use-package.
  ;(bind-key "C-c n" 'narrow-or-widen-dwim)
  ;; I also bind it to C-x t n, using Artur Malabarba's toggle map idea:
  ;; http:://www.endlessparentheses.com/the-toggle-map-and-wizardry.html

  ;; ---------------------------------------------------------------------------
  ;; Move lines up or down (can't easily use C-S on MacOS)
  ;; http://whattheemacsd.com//editing-defuns.el-02.html
  (defun move-line-down ()
    (interactive)
    (let ((col (current-column)))
      (save-excursion
        (forward-line)
        (transpose-lines 1))
      (forward-line)
      (move-to-column col)))

  (defun move-line-up ()
    (interactive)
    (let ((col (current-column)))
      (save-excursion
        (forward-line)
        (transpose-lines -1))
      (move-to-column col)))

  ;(global-set-key (kbd "<C-S-down>") 'move-line-down)
  ;(global-set-key (kbd "<C-S-up>") 'move-line-up)
  (global-set-key (kbd "<M-S-down>") 'move-line-down)
  (global-set-key (kbd "<M-S-up>") 'move-line-up)

  ;; ---------------------------------------------------------------------------
  ;;Stolen from http://www.dotemacs.de/dotfiles/BenjaminRutt.emacs.html."
  ;;This method, when bound to C-x C-c, allows you to close an emacs frame the
  ;;same way, whether it's the sole window you have open, or whether it's
  ;;a "child" frame of a "parent" frame.  If you're like me, and use emacs in
  ;;a windowing environment, you probably have lots of frames open at any given
  ;;time.  Well, it's a pain to remember to do Ctrl-x 5 0 to dispose of a child
  ;;frame, and to remember to do C-x C-x to close the main frame (and if you're
  ;;not careful, doing so will take all the child frames away with it).  This
  ;;is my solution to that: an intelligent close-frame operation that works in
  ;;all cases (even in an emacs -nw session).
  (defun intelligent-close ()
    "quit a frame the same way no matter what kind of frame you are on"
    (interactive)
    (if (eq (car (visible-frame-list)) (selected-frame))
        ;;for parent/master frame...
        (if (> (length (visible-frame-list)) 1)
            ;;close a parent with children present
     (delete-frame (selected-frame))
        ;;close a parent with no children present
   (save-buffers-kill-emacs))
      ;;close a child frame
      (delete-frame (selected-frame))))
  (global-set-key "\C-x\C-c" 'intelligent-close) ;forward reference
)


;;; * Windows, MacOS, Linux specific settings -----
;; https://github.com/purcell/exec-path-from-shell
;(use-package exec-path-from-shell
;  :ensure t
;  :config
;  ;; exec-path-from-shell, sometimes needed for GUI launch
;  ;; Only load this package on macOS and Linux GUI Emacs
;  (when (and (memq system-type '(darwin gnu/linux))
;           (display-graphic-p)
;           (require 'exec-path-from-shell nil t))
;  ;; Variables you want imported from the shell
;  (setq exec-path-from-shell-variables
;        '("PATH" "MANPATH" "LANG" "LC_ALL" "SHELL"))
;  ;; Don’t warn about non-interactive shells
;  (setq exec-path-from-shell-check-startup-files nil)
;  ;; Initialize environment variables and exec-path
;  (exec-path-from-shell-initialize)))

(use-package emacs
  :init
  ;; Common settings across all OSes
  (setq inhibit-startup-screen t
        sentence-end-double-space nil
        scroll-margin 4
        ring-bell-function 'ignore)

  :config
  (cond
    ;; - Windows -
    ((eq system-type 'windows-nt)
     (setq default-directory "C:/Users/YourName/"
           w32-get-true-file-attributes nil))

    ;; - macOS -
    ((eq system-type 'darwin)
     ;; set keys for Apple keyboard, for emacs in OS X
     (setq mac-command-modifier 'meta) ; make cmd key do Meta
     (setq mac-option-modifier 'super) ; make opt key do Super
     (setq mac-control-modifier 'control) ; make Control key do Control
     ;(setq ns-function-modifier 'hyper)  ; make Fn key do Hyper

     ;; Use macOS default shortscuts for Cut/Copy/Paste/Select All
     ;; https://www.emacswiki.org/emacs/EmacsForMacOS#h5o-37
     (global-set-key (kbd "M-c") 'kill-ring-save) ; ⌘-c = Copy
     ;(global-set-key (kbd "M-x") 'kill-region) ; ⌘-x = Cut (interferes with term extended cmd)
     ;(global-set-key (kbd "M-v") 'yank) ; ⌘-v = Paste (interfers with cua-scroll-down)
     (global-set-key (kbd "M-a") 'mark-whole-buffer) ; ⌘-a = Select all
     (global-set-key (kbd "M-z") 'undo) ; ⌘-z = Undo
     (global-set-key (kbd "s-x") 'execute-extended-command) ; Replace ≈ with whatever your option-x produces

     ;; mac 'ls' doesn't support --dired
     (when (string= system-type "darwin")
       (setq dired-use-ls-dired nil))

     ;; Use meta +/- to change text size
     (bind-key "M-+" 'text-scale-increase)
     (bind-key "M-=" 'text-scale-increase)
     (bind-key "M--" 'text-scale-decrease)

     ;; This is copied from
     ;; https://zzamboni.org/post/my-emacs-configuration-with-commentary/
     (defun my/text-scale-reset ()
       "Reset text-scale to 0."
       (interactive)
       (text-scale-set 0))
     (bind-key "M-g 0" 'my/text-scale-reset)

     ;;; Font:  set font size to 15, overriding default 12
     ;; M-x describe-font:
     ;; Monaco:pixelsize=12:weight=normal:slant=normal:width=normal:spacing=100:scalable=true
     ;; M-: (face-attribute 'default :font)
     ;; #<font-object "-*-Monaco-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1">
     ;; geist mono - https://vercel.com/font - switched from:
     ;(set-face-attribute 'default nil :font "Monaco-16" :weight 'regular)
     (set-face-attribute 'default nil :font "Geist Mono-16" :weight 'regular) ; Or "Geist Sans-12"

     ;; Don't open up new frames for files dropped on icon, use active frame
     (defvar ns-pop-up-frames)
     (setq ns-pop-up-frames nil)

     ;; Drag and drop on the emacs window opens the file in a new buffer instead of
     ;; appending it to the current buffer
     ;; http://stackoverflow.com/questions/3805658/how-to-configure-emacs-drag-and-drop-to-open-instead-of-append-on-osx
     (if (fboundp 'ns-find-file)
         (global-set-key [ns-drag-file] 'ns-find-file))

     ;; Macbook Pro has no insert key.
     ;; http://lists.gnu.org/archive/html/help-gnu-emacs/2006-07/msg00220.html
     (global-set-key (kbd "C-c I") (function overwrite-mode))

     ;; Open up URLs in mac browser
     (setq browse-url-browser-function 'browse-url-default-macosx-browser)
     ; (setq browse-url-browser-function 'browse-url-default-windows-browser)

     ;; Copy and paste into Emacs Terminal
     ;; stack overflow, pasting text into emacs on Macintosh
     ;; Copy - C-x M-w
     ;; Paste - C-x C-y
     (defun pt-pbpaste ()
       "Paste data from pasteboard."
       (interactive)
       (shell-command-on-region
         (point)
         (if mark-active (mark) (point))
         "pbpaste" nil t))

     (defun pt-pbcopy ()
       "Copy region to pasteboard."
       (interactive)
       (print (mark))
       (when mark-active
         (shell-command-on-region
           (point) (mark) "pbcopy")
         (kill-buffer "*Shell Command Output*")))
     (global-set-key [C-x C-y] 'pt-pbpaste)
     (global-set-key [C-x M-w] 'pt-pbcopy))

   ;; - Linux -
   ((eq system-type 'gnu/linux)
    (setq default-directory "~/"
          x-ctrl-keysym 'control)
    (defvar browse-url-browser-function)
    (defvar browse-url-browser-program)

    ;; http://stackoverflow.com/questions/15277172/how-to-make-emacs-open-all-buffers-in-one-window-debian-linux-gnome
    ;(setq pop-up-frames 'graphic-only)
    (setq pop-up-frames nil)

    ;; Open up URLs in browser using gnome-open (errors on bytecompile)
    ;(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "gnome-open")
    (setq browse-url-browser-function 'browse-url-firefox))
))


;;; * Saving + Recent -----
(use-package recentf
  :hook (after-init . recentf-mode)
  :custom (recent-max-saved-items 60))

;; Persist minibuffer history over Emacs restarts
(use-package savehist :hook (after-init . savehist-mode))


;;; * Themes + Visuals -----
;; https://github.com/catppuccin/emacs
(use-package catppuccin-theme
  :ensure t
  :config
  (load-theme 'catppuccin :no-confirm) ; Emacs in own window
)

(use-package diminish :ensure t)

(use-package centered-cursor-mode
  :commands (centered-cursor-mode)
  :diminish centered-cursor-mode)

;(use-package golden-ratio
;  :ensure t
;  :diminish golden-ratio-mode
;  :hook (after-init . golden-ratio-mode)
;  :config
;  (golden-ratio-toggle-widescreen)
;  (dolist (command '(evil-window-down evil-window-up evil-window-left evil-window-right))
;    (add-to-list 'golden-ratio-extra-commands command)))

;; nerd-icons.el - A Library for Nerd Font icons
;; https://github.com/rainstormstudio/nerd-icons.el#installing-fonts
;; To finish, run: M-x nerd-icons-install-fonts ; installs to ‘~/Library/Fonts'
(use-package nerd-icons
  :ensure t
  ;:defer 5
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is   ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono")
)


;;; * Completions -----
;; vertico.el - VERTical Interactive COmpletion
;; https://github.com/minad/vertico
(use-package vertico
  :ensure t
  :bind (:map vertico-map
              ("<backspace>" . vertico-directory-delete-char)
              ("C-h" . vertico-directory-delete-word))
  :init
  (vertico-mode)
  (vertico-multiform-mode)
  :custom
  ;(vertico-multiform-commands ; customize display per-command
  ; '(;(execute-extended-command flat) ; I prefer the vert list
  ;   (consult-line reverse)
  ;   (consult-recent-file reverse)
  ;   (find-file reverse)))
  (vertico-resize t)
  (vertico-count 15))

;; marginalia.el - Marginalia in the minibuffer
;; https://github.com/minad/marginalia
(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; https://github.com/oantolin/orderless
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)))

;; consult.el - Consulting completing-read
;; https://github.com/minad/consult
(use-package consult
  :ensure t
  :bind
  ;("M-b" . consult-buffer)
  ("M-b" . switch-to-buffer)                ;; remap to access switch-to-buffer
  ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
  ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
  ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
  ("C-s" . consult-line)  ;; replace I-search
  ("C-x C-r" . consult-recent-file)         ;; added for recentf
  :hook (completion-list-mode . consult-preview-at-point-mode)
)

;; corfu.el - Completion Overlay Region FUnction
;; https://github.com/minad/corfu
(use-package corfu
  :ensure t
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  :custom
  (corfu-auto t)
  (corfu-count 8)
  (corfu-auto-prefix 2))

(use-package corfu-terminal
  :ensure t
  :hook
  (corfu-mode . corfu-terminal-mode))


;;; * RMail  -----
;; Load programing settings from programming.el
(let ((rmail-conf (expand-file-name "rmail-cpt.el" user-emacs-directory)))
  (when (file-exists-p rmail-conf)
    (load-file rmail-conf)))


;;; * Programming Modes  -----
;; Load programing settings from programming.el
;(let ((prog-conf (expand-file-name "programming.el" user-emacs-directory)))
;  (when (file-exists-p prog-conf)
;    (load-file prog-conf)))


;;; * Org and Denote -----
;; Load org config
;; org and denote are huge and messy, load for now until cleaned up
(let ((org-conf (expand-file-name "org-denote.el" user-emacs-directory)))
  (when (file-exists-p org-conf)
    (load-file org-conf)))

;;; * ElFeed -----
(let ((elfeed-conf (expand-file-name "elfeed.el" user-emacs-directory)))
  (when (file-exists-p elfeed-conf)
    (load-file elfeed-conf)))

;;; * daily-log
(defun daily-log ()
  "Automatically opens my daily log file and positions cursor at end of
last sentence."
  (interactive)
  ;(diary)
  (find-file "~/org/DailyLogs/+current") ;symlink to current log
  (goto-char (point-max))  ;go to the maximum accessible value of point
  (search-backward "* Notes") ;search to Notes section first to bypass notes
  (if (re-search-backward "[.!?]") ;search for punctuation from end of file
      (forward-char 1))
  )
(global-set-key (kbd "<f9>") 'daily-log)


;;; * Keybindings -----
(use-package which-key
  :diminish which-key-mode
  :init
  (which-key-mode)
  (which-key-setup-minibuffer)
  :config
  (setq which-key-idle-delay 0.3
        which-key-prefix-prefix "◉ "
        which-key-sort-order 'which-key-key-order-alpha
        which-key-min-display-lines 3
        which-key-max-display-columns nil))


;;; * IBuffer -----
;; ibuffer - *Nice* buffer switching
(use-package ibuffer
  :bind ("C-x C-b" . ibuffer) ; replaces electric-buffer-list
  :custom
  (ibuffer-expert t) ; Enable expert mode for more ibuffer features.
  (ibuffer-display-summary nil) ; Hide the summary line at the top of the ibuffer list.
  (ibuffer-use-other-window nil)
  (ibuffer-show-empty-filter-groups nil) ; Don't show empty filter groups in the ibuffer list.
  (ibuffer-default-sorting-mode 'filename/process) ; Set the default sorting mode for ibuffer, for example, by filename/process.
  (ibuffer-title-face 'font-lock-doc-face) ; Set the face for the ibuffer title.
  (ibuffer-use-header-line t)
  :config
  (setq ibuffer-formats
        '((mark modified read-only locked " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " name)
          (mark modified read-only locked " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " filename-and-process)
          (mark modified read-only locked " " name " " filename))))


;;; * dired / dired+ -----
;; Enable dwim - Dired tries to guess a default target directory.
(setq dired-dwim-target t)

;; Move deleted files to the System's trash can
;; set trash-directory otherwise uses freedesktop.org-style
;(setq trash-directory "~/.Trash") ;; macOS trash
;(setq trash-directory "~/.local/share/Trash") ;; linux trash
(setq delete-by-moving-to-trash t)

;; ls-lisp
;; OSX/BSD ls doesn't sort directories first, ls-lisp can
(use-package ls-lisp
  :custom
  ;(ls-lisp-emulation 'MacOS)
  (ls-lisp-ignore-case t)
  (ls-lisp-verbosity nil)
  (ls-lisp-dirs-first t)
  (ls-lisp-use-insert-directory-program nil)
)

;; dired+
;; https://www.gnu.org/software/emacs/manual/dired-x.html
;; https://www.emacswiki.org/emacs/DiredExtra#Dired_X
;; http://xahlee.info/emacs/emacs/emacs_diredplus_mode.html
;; provides extra functionality for Dired Mode.
;; Hide file detail toggle `(`
;; Make clicking on files in Dired buffers open in the current window:
;; (This works thanks to mouse-1-click-follows-link.)
;(define-key dired-mode-map [mouse-2] #'dired-mouse-find-file)
(use-package dired-x
  :bind
  ("C-x C-j"   . dired-jump) ; to previous level
  ("C-x 4 C-j" . dired-jump-other-window)
  ("s->"       . dired-omit-mode) ;; toggle using Option-Shift-.  same as macOS Finder
  :config
  ;; on macOS, ls doesn't support --dired option linux does
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired nil))
  (setq-default dired-omit-files-p t)
  (setq dired-listing-switches "-alhv")
  ;(setq dired-use-ls-dired nil)
  ;(setq dired-listing-switches "-agho --group-directories-first") ; errors
  ;(define-key dired-mode-map (kbd "/") #'dired-narrow-fuzzy) ; requires dired-hacks
  (define-key dired-mode-map (kbd "e") #'read-only-mode)

  ;; omit-mode
  (setq dired-omit-files "^\\.\\|^#.#$\\|.~$") ; omit dot and backup files
  (define-key dired-mode-map (kbd "h") #'dired-omit-mode) ; overriding h:describe-mode
  (add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1))) ; start in omit-mode

  ;; Auto-refresh dired on file change
  (add-hook 'dired-mode-hook 'auto-revert-mode)

  ;; disable line wrapping in dired mode
  (add-hook 'dired-mode-hook (lambda () (setq truncate-lines t)))

  ;; enable side-by-side dired buffer targets
  ;; Split your window, split-window-vertically & go to another dired directory.
  ;; When you will press C to copy, the other dir in the split pane will be
  ;; default destination.
  (setq dired-dwim-target t) ;; suggest copying/moving to other dired buffer in split view

  ;; Dired functions (find-alternate 'a' reuses dired buffer)
  (put 'dired-find-alternate-file 'disabled nil))


;;; * Terminals -----
;; keymaps terminal (C-c t)
(defvar term-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "t") #'eat)
    (define-key map (kbd "m") #'term)
    (define-key map (kbd "a") #'ansi-term)
    (define-key map (kbd "s") #'shell)
    (define-key map (kbd "e") #'eshell)
    map)
  "Keymap for org-mode commands after `org-keymap-prefix'.")
(fset 'term-command-map term-command-map)
(global-set-key (kbd "C-c t") '("terminals" . term-command-map))

;; shell
(setq explicit-shell-file-name "zsh")
(setq shell-file-name "zsh")
(setq explicit-zsh-args '("--login" "--interactive"))
(defun zsh-shell-mode-setup ()
  (setq-local comint-process-echoes t))
(add-hook 'shell-mode-hook #'zsh-shell-mode-setup)

;; eshell
;; Guide to mastering eshell
;; https://www.masteringemacs.org/article/complete-guide-mastering-eshell

;; https://github.com/xuchunyang/eshell-git-prompt
(use-package eshell-git-prompt
  :ensure t
  :after eshell
  :config
  (eshell-git-prompt-use-theme 'robbyrussell)
)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config
  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("top" "htop" "zsh" "vi" "vim")))

  (defun efs/configure-eshell ()
    ;; Save command history when commands are entered
    (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (setq eshell-history-size         1000
        eshell-buffer-maximum-lines 1000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t)))

;; eat - eat stands for "Emulate A Terminal"
;; https://codeberg.org/akib/emacs-eat
;; https://www.reddit.com/r/emacs/comments/1gdp0fk/i_just_installed_the_eat_terminal_package_to_give/
(use-package eat
  :ensure t
  :preface
  (defun my--eat-open (file)
      "Helper function to open files from eat terminal."
      (interactive)
      (if (file-exists-p file)
              (find-file-other-window file t)
          (warn "File doesn't exist")))
  :config
  (add-to-list 'eat-message-handler-alist (cons "open" 'my--eat-open))
  (setq process-adaptive-read-buffering nil) ; makes EAT a lot quicker!
  (setq eat-term-name "xterm-256color") ; https://codeberg.org/akib/emacs-eat/issues/119"
  (setq eat-kill-buffer-on-exit t)
  (setq eat-shell-prompt-annotation-failure-margin-indicator "")
  (setq eat-shell-prompt-annotation-running-margin-indicator "")
  (setq eat-shell-prompt-annotation-success-margin-indicator ""))

;; TRAMP
;; https://www.reddit.com/r/emacs/comments/uto1uv/magit_and_authentication/
;(require 'tramp)
;(require 'auth-source)

(use-package tramp
  :config
  (setq tramp-default-method "ssh") ; Set the default TRAMP method
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path) ; Add own remote path

  ;; Enable TRAMP's support for authentication information from `auth-source'
  (setq auth-sources '("~/.authinfo.gpg" "~/.authinfo" "~/.netrc"))

  ;; https://coredumped.dev/2025/06/18/making-tramp-go-brrrr./
  ;; prevent TRAMP from creating a bunch of extra files and use scp directly when moving files.
  (setq remote-file-name-inhibit-locks t
        tramp-use-scp-direct-remote-copying t
        remote-file-name-inhibit-auto-save-visited t)

  ;; TRAMP uses 2 ways to copy files, OOB and Inline (base64 over ssh)
  ;; inline is usually faster all the way up until about 2MB.  Also, rsync
  ;; can update faster, but can also break remote shells (fixed in 30.3?), use scp
  (setq tramp-copy-size-limit (* 1024 1024) ;; 1MB
        tramp-verbose 2)

  ;; Use Direct Async (faster then before in Tramp 2.7+)
  ;; now magit and git-gutter work better
  (connection-local-set-profile-variables
   'remote-direct-async-process
   '((tramp-direct-async-process . t)))

  ;; change 'server' to remote host
  ;(connection-local-set-profiles
  ; '(:application tramp :machine "server")
  ; 'remote-direct-async-process)

  (setq magit-tramp-pipe-stty-settings 'pty)

  ;; Fix remote compile
  ;; tramp will use ssh connection sharing, but compile command disables, turn back on
  (with-eval-after-load 'tramp
    (with-eval-after-load 'compile
      (remove-hook 'compilation-mode-hook #'tramp-compile-disable-ssh-controlmaster-options)))
)

;; end init.el
