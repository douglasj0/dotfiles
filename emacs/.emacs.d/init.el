;;; init.el --- Emacs init -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;;;; * Startup
;;; * Package repo setup and quickstart-----
(require 'package) ; needed for package-archive variable
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-quickstart t)
;; initialize the packge system
(package-initialize)

;; Load custom configuration file
(setq custom-file (expand-file-name "custom.el" "~/sync/org/emacs_d/"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Append personal info directory to list
(with-eval-after-load 'info
  (add-to-list 'Info-additional-directory-list
               "~/org/emacs_d/info"))

;; (add-to-list 'load-path (locate-user-emacs-file "elisp/"))  ;; elisp packages not in pkg mgr, changing in 32.0
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/"))


;;; add lisp directory for split init.el packages
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;;;; * esup - startupprofiler
;(use-package esup
                                        ;  :ensure t
;  ;; To use MELPA Stable use ":pin melpa-stable",
;  :pin melpa
;  :config
;  (setq esup-depth 0)
;)
;;; enable use-package profiling (M-x use-package-report)
;(setq use-package-compute-statistics t)


;;; * Basic Emacs options -----
;; Start server in GUI mode only, if not already running
(when window-system
  (require 'server)
  ;; (setq server-socket-dir (format "/tmp/emacs%d" (user-uid))) ;; default
  (unless (server-running-p)
    (server-start)))

;;; move use-package emacs back to init settings
;; Basic Emacs settings
(setopt scroll-conservatively 101  ;; don't jump scroll at window bottom
        help-window-select t
        vc-follow-symlinks t
        use-short-answers t
        inhibit-startup-message t
        initial-scratch-message nil
        initial-major-mode 'text-mode
        custom-safe-themes t       ;; treat all themes as safe
        backup-by-copying t
        tab-always-indent 'complete
        backup-directory-alist
          `(("." . ,(expand-file-name "backup/" user-emacs-directory))))

;; * initialization
(setq user-full-name "Douglas Jackson"
      user-mail-address "hpotter@hogworts.edu")

;; * enable or disabled functions
;; Upcase and downcase regions, default also works on inactive region, use dwim
;(put 'upcase-region 'disabled nil)  ; C-x C-u
;(put 'downcase-region 'disabled nil)  ; C-x C-l
(global-unset-key (kbd "C-x C-u")) ; default is `upcase-region'-region'
(global-unset-key (kbd "C-x C-l")) ; default is `downcase-region'
;(global-unset-key (kbd "M-c"))     ; default is `kill-ring-save', didn't work
;(global-set-key (kbd "M-c") #'capitalize-region) ; was M-c
(global-set-key (kbd "C-x C-u") #'upcase-dwim)   ; was M-u
(global-set-key (kbd "C-x C-l") #'downcase-dwim) ; was M-l

;; Restrict buffer editing to a region
;; Text Narrowing commands:
;;   Region: C-x n n, Page: C-x n p
;;   Funct: C-x n p, Widen: C-x n w
;;   Subtree in Org-Mode:   C-x n s
(put 'narrow-to-region 'disabled nil)
(global-unset-key (kbd "C-x n n"))

;; Goal Column, enter C-x C-n, at point to set column that C-n should go to
;; to clear enter C-u C-x C-n
(put 'set-goal-column 'disabled nil)

;; https://www.emacswiki.org/emacs/ZapUpToChar
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.")
(global-set-key (kbd "M-z") 'zap-up-to-char)

;; disable electric-indent if active, added in Emacs 24.4
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; * global key bindings
;; Show a summery of all registers with content
(global-set-key (kbd "C-x r v") 'list-registers)

;; Move through windows in reverse order of (other-window), C-x o
(global-set-key (kbd "C-x O") 'previous-multiframe-window)

;; Invoke M-x without the Alt key (from Steve Yegge's blog)
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
;(global-set-key (kbd "C-c C-m") 'execute-extended-command) ; remapped by org to org-ctrl-c-ret

;; * global settings
;; Compilation buffer scrolls to follow output.
;; set to first-error to stop when the first error appers and set point
(with-eval-after-load 'compile
  (setq compilation-scroll-output t))

;; Enable line-numbers-mode for all programming languages
;(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; enable delete selection mode, pasting overwrites selection
(delete-selection-mode 1)

;; expand text before point - M-/ default is dabbrev-expand
(global-set-key (kbd "M-/") 'hippie-expand)

;; Tear off window into a new frame
(bind-key "C-x 5 t" #'tear-off-window) ; into a new frame

;; Remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Kill line backwards
;; http://emacsredux.com/blog/2013/04/08/kill-line-backward/
(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))

;;; Ping settings (from net-util.el)
;; http://www.masteringemacs.org/articles/2011/03/02/network-utilities-emacs/
(setq ping-program-options '("-c" "4"))

;;; Enable whitespace-mode for diff buffers
;;; http://stackoverflow.com/questions/11805584/automatically-enable-whitespace-mode-in-diff-mode
(add-hook 'diff-mode-hook
          (lambda ()
            (whitespace-mode 1)))

;;; Make tooltips appear in the echo area (checks if function exists)
(tooltip-mode nil)

;;; Don't create new lines when pressing 'arrow-down key' at end of the buffer
(setq next-line-add-newlines nil)

;;; Fix delete key working as backspace and not forward deleting
;;; (This only worked in window mode, not terminal. C-d works in both)
(when window-system (normal-erase-is-backspace-mode 1))

;;; Alias to change apropos to ap
(defalias 'ap 'apropos)

;;; hl-line: highlight the current line
(when (fboundp 'global-hl-line-mode)
  (global-hl-line-mode t)) ;; turn it on for all modes by default

;;; Make text mode default major mode with auto-fill enabled
;;setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode) ;replaces longlines in 23

;;; Ask before quitting the last Emacs frame
(setq confirm-kill-emacs 'y-or-n-p)

;;; Display (line:column) numbers in the mode-line (else L### only)
(setq line-number-mode    t
      column-number-mode  t)

;;; Stop blinking cursor
(blink-cursor-mode 0)

;;; Explicitly show the end of a buffer (indicated on left fringe of window)
(set-default 'indicate-empty-lines t)

;;; Line-wrapping
(set-default 'fill-column 78)

;; Truncate lines
(setq truncate-lines t
      truncate-partial-width-windows nil)

;; Create new scratch buffer if needed
;;(run-with-idle-timer 1 t
;;    (lambda () (get-buffer-create "*scratch*")))
(unless (get-buffer "*scratch*")
  (get-buffer-create "*scratch*"))

;; allow scroll-down/up-command to move point to buffer end/beginning
;(setq scroll-error-top-bottom 'true)

;; disable visual-bell /!\
;; you really only need one of these
(setq visible-bell nil)
;(setq ring-bell-function 'ignore)

;; repl alias for lisp -- read-eval-print-loop
;(defun repl() (interactive) (ielm))
(defalias 'repl 'ielm)


;; * other
;;; Customize Modeline -----
;; make the read-only and modified indicators more noticeable.
;;(setq-default mode-line-modified        ; not customizable
;;              '((:eval (if buffer-read-only
;;                           (propertize "R" 'face 'warning) ;; was %
;;                         "-"))
;;                (:eval (if (buffer-modified-p)
;;                           (propertize "*" 'face 'error) ;; was *
;;                         "-"))))
;;;;(setopt mode-line-compact 'long)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; Enable holidays in Calendar and week-start-day
(setq calendar-mark-holidays-flag t
      calendar-week-start-day 0)


;;; \/\/\/ recheck
(setq-default display-line-numbers-width 3
              indent-tabs-mode nil   ; use spaces instead of tabs
              tab-width 4)

;(xterm-mouse-mode 1)
;(setq select-enable-primary t) ; use primary X selection mechanism
;(global-display-line-numbers-mode 1)
;(fringe-mode '(8 . 8))

;;; make Emacs always indent using SPC characters and never TABs
;;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Just-Spaces.html
(setq-default indent-tabs-mode nil)
(show-paren-mode 1)
(savehist-mode 1)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      require-final-newline t
      delete-old-versions t
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain)

;; Emacs 30 and newer: Disable Ispell completion function. As an alternative,
;; try `cape-dict'.
;(setq text-mode-ispell-word-completion nil)

;; Emacs 28 and newer: Hide commands in M-x which do not apply to the current
;; mode.  Corfu commands are hidden, since they are not used via M-x. This
;; setting is useful beyond Corfu.
(setq read-extended-command-predicate #'command-completion-default-include-p)
;;; ^^^ recheck


;; * function definations
;; ---------------------------------------------------------------------------
(defun daily-log ()
  "Opens my daily log file and positions cursor at end of last sentence."
  (interactive)
  ;(diary)
  (find-file "~/org/DailyLogs/+current") ;symlink to current log
  (goto-char (point-max))  ;go to the maximum accessible value of point
  (search-backward "* Notes") ;search to Notes section first to bypass notes
  (if (re-search-backward "[.!?]") ;search for punctuation from end of file
      (forward-char 1))
  (message "Daily log opened!"))
(global-set-key (kbd "<f9>") 'daily-log)

;; ---------------------------------------------------------------------------
;; Use C-c r to start rectangle selection
;;| Key       | Action                            |
;;| --------- | --------------------------------- |
;;| `C-x r t` | Insert text on each line          |
;;| `C-x r k` | Kill rectangle                    |
;;| `C-x r y` | Yank rectangle                    |
;;| `C-x r o` | Open rectangle (shift text right) |
;;| `C-x r c` | Clear rectangle                   |
;;| `C-x TAB' | Indent Ridigdly                   |
;; Use C-c r to start rectangle selection
;;
;;  (defvar my/rectangle-region-cookie nil
;;    "Face remapping cookie for rectangle region.")
;;
;;  (defun my/rectangle-region-on ()
;;    (setq my/rectangle-region-cookie
;;          (face-remap-add-relative
;;           'region
;;           '(:background "red" :foreground "black"))))
;;
;;  (defun my/rectangle-region-off ()
;;    (when my/rectangle-region-cookie
;;      (face-remap-remove-relative my/rectangle-region-cookie)
;;      (setq my/rectangle-region-cookie nil)))
;;
;;  (add-hook 'rectangle-mark-mode-hook
;;            (lambda ()
;;              (if rectangle-mark-mode
;;                  (my/rectangle-region-on)
;;                (my/rectangle-region-off))))
;;
;;  (global-set-key (kbd "C-c r") #'rectangle-mark-mode)

;;; Emacs 24.4 and later now include something similar: Rectangle Mark mode.
;;; After a region is active, type ‘C-x SPC’ to toggle it on and off.
;;; Use CUA mode for rectangles (C-RET to select, normal emacs keys to copy)
;;; http://emacs-fu.blogspot.com/2010/01/rectangles-and-cua.html
(global-unset-key (kbd "C-z"))
(setq cua-rectangle-mark-key (kbd "C-c C-d"))  ;; Ctrl-Enter, used by org-mode
;(setq cua-rectangle-mark-key (kbd "C-z C-SPC"))  ;; Ctrl-Enter, used by org-mode
;(setq cua-enable-cua-keys nil)  ;; only for rectangles, keeps (C-c, C-v, C-x).
(cua-mode 1)
(cua-selection-mode t)

;; ---------------------------------------------------------------------------
(defun toggle-indent-tabs-mode ()
  "Toggle indent-tabs-mode in the current buffer."
  (interactive)
  (setq indent-tabs-mode (not indent-tabs-mode))
  (message "indent-tabs-mode is now %s" (if indent-tabs-mode "on" "off")))

(global-set-key (kbd "C-c b") 'toggle-indent-tabs-mode)

;; ---------------------------------------------------------------------------
;; electric-pair
(defun my/electric-pair-conservative-inhibit (char)
  (or
   ;; I (u/sandinmyjoints) find it more often preferable not to pair
   ;; when the same char is next.
   (eq char (char-after))
   ;; Don't pair up when we insert the second of "" or of ((.
   (and (eq char (char-before))
        (eq char (char-before (1- (point)))))
   ;; I also find it often preferable not to pair next to a word.
   (eq (char-syntax (following-char)) ?w)
   ;; Don't pair at the end of a word, unless parens.
   (and
    (eq (char-syntax (char-before (1- (point)))) ?w)
    (eq (preceding-char) char)
    (not (eq (char-syntax (preceding-char)) 40) ;; 40 is open paren
         ))))
(setq-default electric-pair-inhibit-predicate
              'my/electric-pair-conservative-inhibit)
  (electric-pair-mode)

;; ---------------------------------------------------------------------------
;; https://www.reddit.com/r/emacs/comments/1mrqi6p/emacs_toggle_transparency_with_interactive/
(defun my/toggle-frame-transparency ()
"Toggle frame transparency with user-specified opacity value.
Prompts user whether to enable transparency. If yes, asks for opacity
value (0-100). If no, restore full opacity. Only affects active frame."
  (interactive)
  (if (y-or-n-p "Enable frame transparency? ")
      (let ((alpha-value (read-number "Enter transparency value (0-100, default 90): " 90)))
        (if (and (>= alpha-value 0) (<= alpha-value 100))
            (progn
              (set-frame-parameter nil 'alpha alpha-value)
              (message "Frame transparency set to %d%%" alpha-value))
          (message "Invalid transparency value. Please enter a number between 0 and 100.")))
    (progn
      (set-frame-parameter nil 'alpha 100)
      (message "Frame transparency disabled (opacity restored to 100%)"))))

;; Global keybinding for transparency toggle
;(global-set-key (kbd "C-c T") 'my/toggle-frame-transparency)

;; ---------------------------------------------------------------------------
;; https://www.reddit.com/r/emacs/comments/un4wf8/weekly_tips_tricks_c_thread/
;; toggle between two most recent buffers in a window
(defun back-and-forth-buffer ()
    (interactive)
    (switch-to-buffer (other-buffer (current-buffer))))
(global-set-key (kbd "<f7>") 'back-and-forth-buffer)

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
;; Match Paren / based on the vim command using %
;; emacs for vi users: http://grok2.tripod.com
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'match-paren)

;; ---------------------------------------------------------------------------
(defun intelligent-close ()
  "quit a frame the same way no matter what kind of frame you are on.

This method, when bound to C-x C-c, allows you to close an emacs frame the
same way, whether it's the sole window you have open, or whether it's
a \"child\" frame of a \"parent\" frame.  If you're like me, and use emacs in
a windowing environment, you probably have lots of frames open at any given
time.  Well, it's a pain to remember to do Ctrl-x 5 0 to dispose of a child
frame, and to remember to do C-x C-x to close the main frame (and if you're
not careful, doing so will take all the child frames away with it).  This
is my solution to that: an intelligent close-frame operation that works in
all cases (even in an emacs -nw session).

Stolen from http://www.dotemacs.de/dotfiles/BenjaminRutt.emacs.html."
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

;; ---------------------------------------------------------------------------
;; It’s useful to have a scratch buffer around, and more useful to have a key chord to switch to it.
(declare-function switch-to-scratch-buffer "init.el" ()) ;; tell byte-compiler abt function
(defun switch-to-scratch-buffer ()
  "Switch to the current session's scratch buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))
(with-eval-after-load 'bind-key
  (bind-key "C-c f s" #'switch-to-scratch-buffer))


;;; * Windows, MacOS, Linux specific settings -----
;; Common settings across all OSes
(setq inhibit-startup-screen t
      sentence-end-double-space nil
      scroll-margin 4
      ring-bell-function 'ignore)

;; OS-specific settings
(cond
  ((eq system-type 'windows-nt)
   (setopt w32-lwindow-modifier 'super)
   (set-face-attribute 'default nil :font "Consolas-12"))

  ((eq system-type 'darwin)
   (setopt mac-option-modifier  'meta
           mac-command-modifier 'super
           mac-control-modifier 'control)
;;   (setopt mac-option-modifier  'super    ;; Opt key do Super
;;           mac-command-modifier 'meta     ;; Cmd key do Meta
;;           mac-control-modifier 'control) ;; Control key do Control


   (set-face-attribute 'default nil :font "Monaco-13")

   ;;(setq trash-directory "~/.Trash") ;; macOS trash
   ;; set keys for Apple keyboard, for emacs in OS X

   ;(setq ns-function-modifier 'hyper)  ; make Fn key do Hyper

   ;; Use macOS default shortscuts for Cut/Copy/Paste/Select All
   ;; https://www.emacswiki.org/emacs/EmacsForMacOS#h5o-37
   (global-set-key (kbd "M-c") 'kill-ring-save) ; ⌘-c = Copy
   ;(global-set-key (kbd "M-x") 'kill-region) ; ⌘-x = Cut (interferes with term extended cmd)
   ;(global-set-key (kbd "M-v") 'yank) ; ⌘-v = Paste (interfers with cua-scroll-down)
   (global-set-key (kbd "M-a") 'mark-whole-buffer) ; ⌘-a = Select all
   (global-set-key (kbd "M-z") 'undo) ; ⌘-z = Undo
   (global-set-key (kbd "s-x") 'execute-extended-command) ; Replace ≈ with whatever your option-x produces

   ;; ;; Restrict exec-path-from-shell to macOS
   ;; (when (display-graphic-p)
   ;;    ;; A known problem with GUI Emacs on MacOS: it runs in an isolated
   ;;    ;; environment, so envvars will be wrong. That includes the PATH
   ;;    ;; Emacs picks up. `exec-path-from-shell' fixes this. This is slow
   ;;    ;; and benefits greatly from compilation.
   ;;    ;; orig vars: "PATH" "MANPATH" "GOPATH" "GOROOT" "PYTHONPATH" "LC_TYPE" "LC_ALL" "LANG" "SSH_AGENT_PID" "SSH_AUTH_SOCK" "SHELL" "JAVA_HOME"
   ;;    (when (require 'exec-path-from-shell nil t)
   ;;      ;; Don’t check shell startup files (faster)
   ;;      (setq exec-path-from-shell-check-startup-files nil)
   ;;      ;; List of env vars to import
   ;;      (setq exec-path-from-shell-variables
   ;;            '("PATH" "MANPATH" "LANG" "SHELL"))
   ;;      ;; Initialize exec-path and env vars from the shell
   ;;      (exec-path-from-shell-initialize)))

   (when (and (display-graphic-p)
              (require 'exec-path-from-shell nil t))
     (setq exec-path-from-shell-check-startup-files nil
           exec-path-from-shell-variables
           '("PATH" "MANPATH" "LANG" "SHELL"))
     (exec-path-from-shell-initialize))


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
   (set-face-attribute 'default nil :font "Monaco-16" :weight 'regular)
   ;(set-face-attribute 'default nil :font "Geist Mono-16" :weight 'regular) ; Or "Geist Sans-12"

   ;; Don't open up new frames for files dropped on icon, use active frame
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
     ;;(print (mark))
     (when mark-active
       (shell-command-on-region
         (point) (mark) "pbcopy")
       (kill-buffer "*Shell Command Output*")))
   (global-set-key [C-x C-y] 'pt-pbpaste)
   (global-set-key [C-x M-w] 'pt-pbcopy))


   ;; - Linux -
   ((eq system-type 'gnu/linux)
    ;;(setq trash-directory "~/.local/share/Trash")

    ;; http://stackoverflow.com/questions/15277172/how-to-make-emacs-open-all-buffers-in-one-window-debian-linux-gnome
    ;(setq pop-up-frames 'graphic-only)
    (setq pop-up-frames nil)

    ;; Open up URLs in browser using gnome-open (errors on bytecompile)
    ;(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "gnome-open")
    (setq browse-url-browser-function 'browse-url-firefox))
) ;; end os cond


;;; * Saving + Recent -----
;;; Accidently disabled when moved out init.el?
(use-package recentf
  :hook (after-init . recentf-mode)
  :custom
  (recent-max-saved-items 60)
  (recentf-max-menu-items 15)
  (recentf-exclude '(".*/.emacs.d/" ".*/.git/" ".*tmp/"))  ; Exclude certain directories
  (recentf-auto-cleanup 'never) ; Adjust cleanup behavior
  :config
  ;; Add recent files to a keybinding for easy access
  (global-set-key (kbd "C-x C-t") 'recentf-open-files))  ;; testing

;; Persist minibuffer history over Emacs restarts
(use-package savehist
  :hook (after-init . savehist-mode)
  :custom
  (savehist-additional-variables
   '(search-ring regexp-search-ring))  ; Save additional variables
  (savehist-max-length 1000)            ; Store up to 1000 history items
  (savehist-file (expand-file-name "~/.emacs.d/savehist"))) ; Persist to file

;;; * Split config into sections
;; Completion
(require 'completion)

;; UI
(require 'tools-ui)

;; dired
(require 'tools-dired)

;; Shell
(require 'tools-shell)

;; TRAMP
(require 'tools-tramp)

;; org-mode, denote
;;; * Org and Denote -----
;; org and denote are huge and messy, load for now until cleanup
;;(let ((org-conf (expand-file-name "org-denote.el" user-emacs-directory)))
;;  (load org-conf 'noerror))
(require 'org-denote)

;;; * Programming Modes  -----
;;(let ((prog-conf (expand-file-name "programming.el" user-emacs-directory)))
;;  (load prog-conf 'noerror))
(require 'programming)

;;; * Load Local configs
(let ((config-dir "~/.emacs.d/local/"))
  (dolist (file (directory-files config-dir t "\\.el$"))
    (condition-case err
        (load file)
      (error (message "Error loading %s: %s" file err)))))

(provide 'init)
;;; init.el ends here
