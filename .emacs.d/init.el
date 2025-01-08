;;; init.el -*- lexical-binding: t; -*-

;;;; * --- Init ---
;;;; * init
;; The init.el portion of the init.el/config.org from before

;; init.el
;; from https://github.com/danielmai/.emacs.d/blob/master/init.el
;; https://www.reddit.com/r/emacs/comments/5d4hqq/using_babel_to_put_your_init_file_in_org/
;; https://www.reddit.com/r/emacs/comments/673wek/emacs_bankruptcy_and_structure/

;; Don't show the startup screen, disable startup msg in scratch
(setq inhibit-startup-message t)
(setq-default initial-scratch-message nil)

;; Set up package
;; Use M-x Package-refresh-contents to reload the list of packages after initial run
(require 'package)
(setq package-archives
  '(("gnu"    . "https://elpa.gnu.org/packages/") ; default package archive, secure
    ("gnu1"   .  "http://elpa.gnu.org/packages/") ; default package archive
    ("melpa"  . "https://melpa.org/packages/")    ; milkypostman's pkg archive
    ("nongnu" . "https://elpa.nongnu.org/nongnu/"))) ; eat terminal and others
(package-initialize)

;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
;; diminish info : https://github.com/emacsmirror/diminish
(unless (or (package-installed-p 'use-package)
            (package-installed-p 'diminish))
  (package-refresh-contents)
  (package-install 'use-package)
  ;(package-install 'diminish)
)

;; enable use-package profiling (M-x use-package-report)
(setq use-package-compute-statistics t)

;; Allow loading from the package cache
;(defvar package-quickstart)
(setq package-quickstart t)
;; package-quickstart-file is a variable defined in ‘package.el’.
;; Its value is "~/.emacs.d/package-quickstart.el"
(setq package-quickstart-file (expand-file-name "var/package-quickstart.el"
                          user-emacs-directory))

;; From use-package README
(eval-when-compile
  (require 'use-package))
;(require 'diminish)                ;; if you use :diminish
(require 'bind-key)

;; Load the config (will re-tangle on org file change)
;(org-babel-load-file (concat user-emacs-directory "config.org"))

;;;; * --- Housekeeping ---
;;;; * initialization
; whoami?
(setq
 user-full-name "Douglas Jackson"
 user-mail-address "hpotter@hogworts.edu")

;; more useful frame title that shows either a file or a
;; buffer name (if the buffer isn't visiting a file)
;; commented out to see if its causing emacs 29.1 mac hang
;(setq frame-title-format
;      '((:eval (if (buffer-file-name)
;                   (abbreviate-file-name (buffer-file-name))
;                 "%b"))))

;; Load Customizations if they exist
;; https://lupan.pl/dotemacs/
(setq custom-file "~/Sync/my_homedir_files/emacs.d/custom.el")
(if (file-exists-p custom-file)
    (load custom-file))

;; Add 'info' and 'elisp' to load-path (C-h v load-path RET)
;; NOTE: comment out to avoid error on fresh setup:
;; "Symbol's value as variable is void: Info-additional-directory-list"
;; Found in auctex, use eval-after-load
(eval-after-load 'info
   '(add-to-list 'Info-additional-directory-list
                 "~/Sync/my_homedir_files/emacs.d/info"))

(add-to-list 'load-path "~/.emacs.d/elisp/") ;; elisp packages not in pkg mgr

;; Start server if not currently running and in gui
(when window-system
     (load "server")
     (setq server-socket-dir "~/.emacs.d/var/tmp")
     (unless (server-running-p) (server-start)))

;;;; * enable disabled functions
;;; enable or disable functions

;; Upcase and downcase regions, default also works on inactive region, use dwim
;(put 'upcase-region 'disabled nil)  ; C-x C-u
;(put 'downcase-region 'disabled nil)  ; C-x C-l
(global-unset-key (kbd "C-x C-u")) ; default is `upcase-region'-region'
(global-unset-key (kbd "C-x C-l")) ; default is `downcase-region'
;(global-unset-key (kbd "M-c"))     ; default is `kill-ring-save', didn't work
;(global-set-key (kbd "M-c") #'capitalize-region) ; was M-c
(global-set-key (kbd "C-x C-u") #'upcase-dwim)   ; was M-u
(global-set-key (kbd "C-x C-l") #'downcase-dwim) ; was M-l
;;--
;(bind-key [remap just-one-space] #'cycle-spacing)
;(bind-key [remap upcase-word] #'upcase-dwim)
;(bind-key [remap downcase-word] #'downcase-dwim)
;(bind-key [remap capitalize-word] #'capitalize-dwim)
;(bind-key [remap count-words-region] #'count-words)

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

;;;; * global key bindings
;;; global key bindings

;; Show a summery of all registers with content
(global-set-key (kbd "C-x r v") 'list-registers)

;; Move through windows in reverse order of (other-window), C-x o
(global-set-key (kbd "C-x O") 'previous-multiframe-window)

;; Invoke M-x without the Alt key (from Steve Yegge's blog)
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
;(global-set-key (kbd "C-c C-m") 'execute-extended-command) ; remapped by org to org-ctrl-c-ret

;; ace-window allows switching to window by number, bind to 'C-x o'
;; not installed by default
(use-package ace-window
  :ensure t)
(global-set-key (kbd "C-x o") 'ace-window)
;(setq aw-keys '(?a ?b ?c ?d ?e ?f ?g ?h ?i)) ;; letters instead of numbers

;;;; * global settings
;;; global settings

;; Compilation buffer scrolls to follow output.
;; set to first-error to stop when the first error appers and set point
(setq compilation-scroll-output t)

;; Enable line-numbers-mode for all programming languages
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; enable delete selection mode, so pasting overwrites selection
(delete-selection-mode 1)

;; add org-roam-directory to safe variables
;(add-to-list 'safe-local-variable-values '(org-roam-directory . "."))

;; set default shell to zsh
(setq explicit-shell-file-name "/bin/zsh")
(setq shell-file-name "zsh")
(setq explicit-bash.exe-args '("--noediting" "--login" "-i"))
(setenv "SHELL" shell-file-name)

;; Remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; automatically follow symlinks to files under version control without prompting
(setq vc-follow-symlinks t)

;;; Kill line backwards
;;; http://emacsredux.com/blog/2013/04/08/kill-line-backward/
(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))

;;; Ping settings (from net-util.el)
;;; http://www.masteringemacs.org/articles/2011/03/02/network-utilities-emacs/
(defvar ping-program-options)
(setq ping-program-options '("-c" "4"))

;;; Enable whitespace-mode for diff buffers
;;; http://stackoverflow.com/questions/11805584/automatically-enable-whitespace-mode-in-diff-mode
(add-hook 'diff-mode-hook
          (lambda ()
            (whitespace-mode 1)))

;;; Enable holidays in Calendar
(setq mark-holidays-in-calendar t)

;; w/o-man mode (elisp man page formater for systems without 'man')
(defvar woman-show-log)
(defvar woman-cache-filename)
(setq woman-show-log nil)
(autoload 'woman "woman"
  "Decode and browse a Unix man page." t)
(setq woman-cache-filename "~/.emacs.d/var/woman_cache.el")

;;; Make tooltips appear in the echo area (checks if function exists)
(tooltip-mode nil)

;;; Emacs 24.4 and later now include something similar: Rectangle Mark mode. After a region is active, type ‘C-x SPC’ to toggle it on and off.
;;; Use CUA mode for rectangles (C-RET to select, normal emacs keys to copy)
;;; http://emacs-fu.blogspot.com/2010/01/rectangles-and-cua.html
;(setq cua-rectangle-mark-key (kbd "C-^"))
(global-unset-key "\C-z")
;(setq cua-rectangle-mark-key (kbd "C-z '"))
(setq cua-rectangle-mark-key (kbd "C-z C-SPC"))  ;; instead of Ctrl-Enter
(cua-selection-mode t)
;(setq cua-enable-cua-keys nil)  ;; only for rectangles, keeps (C-c, C-v, C-x).
;(cua-mode t)

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
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode) ;replaces longlines in 23

;;; Auto-scroll in *Compilation* buffer
(setq compilation-scroll-output t)

;;; make Emacs always indent using SPC characters and never TABs
;;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Just-Spaces.html
(setq-default indent-tabs-mode nil)

;;; "y or n" instead of "yes or no", use-short-answers added in Emacs 28.1
;; if odd pop-up vs minibuffer prompt issues, examine us-dialog-box?
;(fset 'yes-or-no-p 'y-or-n-p) ;emacs < 28
(setq use-short-answers t)

;;; Ask before quitting the last Emacs frame
(setq confirm-kill-emacs 'y-or-n-p)

;;; Highlight regions and add special behaviors to regions.
;;; "C-h d transient" for more info.  transient-mark-mode is a toggle.
;;; also in Emacs 22 and greater, C-SPC twice to temp enable transient mark
;(setq transient-mark-mode nil)
(setq transient-mark-mode t)

;;; Display line and column numbers in the mode line
(setq line-number-mode    t
      column-number-mode  t)

;;; Stop blinking cursor
(blink-cursor-mode 0)

;;; Explicitly show the end of a buffer (indicated on left fringe of window)
(set-default 'indicate-empty-lines t)

;;; Line-wrapping
(set-default 'fill-column 78)

;; Don't truncate lines
(setq truncate-lines t
      truncate-partial-width-windows nil)

;; Create new scratch buffer if needed
(run-with-idle-timer 1 t
    (lambda () (get-buffer-create "*scratch*")))

;; allow scroll-down/up-command to move point to buffer end/beginning
;(setq scroll-error-top-bottom 'true)

;; New json-mode - disabled, testing json-ts-mode
;(setq auto-mode-alist (cons '("\\.json\\'" . js-mode) auto-mode-alist))
;(setq auto-mode-alist
;      (append '(("\\.json\\'" . json-mode)  ; note these are encapsulated in a '() list
;        	("\\.jsn\\'" . json-mode))
;               auto-mode-alist))

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

;; repl alias for lisp -- read-eval-print-loop
;(defun repl() (interactive) (ielm))
(defalias 'repl 'ielm)

;; desktop-save
;(desktop-save-mode 1)
;(setq desktop-save 'ask)
;; can do 'desktop-clear' for cleanup, add files to NOT close here
;(dolist (file
;        '("+current" "+Last" "work.org" "init.org"))
;  (add-to-list 'desktop-clear-preserve-buffers file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bookmarks
;;    ‘C-x r m’ – set a bookmark at the current location (e.g. in a file)
;;    ‘C-x r b’ – jump to a bookmark
;;    ‘C-x r l’ – list your bookmarks
;;    ‘M-x bookmark-delete’ – delete a bookmark by name
(setq
  bookmark-default-file "~/.emacs.d/var/bookmarks" ;; bookmark file location
  bookmark-save-flag 1)                   ;; autosave each change)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; * functions
;;; function definations
;; ---------------------------------------------------------------------------
;; https://www.reddit.com/r/emacs/comments/un4wf8/weekly_tips_tricks_c_thread/
;; toggle between two most recent buffers in a window
(defun back-and-forth-buffer ()
	(interactive)
	(switch-to-buffer (other-buffer (current-buffer))))
(global-set-key (kbd "<f7>") 'back-and-forth-buffer)

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
(defun switch-to-scratch-buffer ()
  "Switch to the current session's scratch buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))
(bind-key "C-c f s" #'switch-to-scratch-buffer)

;;;; * daily-log
;;; -- daily log -

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

;; ---------------------------------------------------------------------------
;(diary)

;; Email 1
;; I have been using a simple system for writing notes day by day.  Kind of
;; like a diary.  It's really very unsophisticated but helpful.  It will allow
;; you to make notes into a template file.  Weeks, Months (etc...) later, you
;; can refer to them.
;;
;; For those who have never seen it
;; http://aonws01/unix-admin/Daily_Logs/Jerry_Sievers/
;;
;; Many of you new guys' questions to me have been answered from these notes
;; (eg, license keys info, who's who and so forth).
;;
;; John Sconiers asked about this and I set him up with it.  Whole procedure
;; takes only a few minutes to install and probably about fifteen minutes per
;; day to keep up to date.  An investment in time that pays off later.  Other
;; admins who have left Aon used this and liked it too.
;;
;; It also comes with a CGI program which, if your home directory is
;; accessible to aonws01, can allow others to browse your diary (I hear
;; cheering and booing...)
;;
;; Please let me know.  It would be nice to have everyone using this thing at
;; least minimally.

;; Email 2
;; Chris, I have installed the package in your home directory.  Files are in
;; Aon/DailyLogs.  The current log has a symbolic link named +Current.  You
;; also have an alias 'diary' which you can type at the shell.  Doing so will
;; invoke vi on the +Current file and position the cursor on the very last '.'
;; character in the file.  I have added the $HOME/bin directory to your path
;; and created one cron job to stamp the 'monday' file weekly.
;;
;; You should run the command 'new-daily-log' once per week to start a new
;; file.  Optionally, the previous file can be emailed to the destination of
;; your choice.  See the Aon/DailyLogs/.config file for details.
;;
;; Please call if you have any questions.

;;;; * --- Utilities ---
;;;; * maximize-window
;; JDRiverRun
;; One capability I use every day that I never see mentioned is vertical/horizontal window maximization. That is, no matter where my selected window is placed in some complicated frame layout, make it occupy the full height(/width) of the frame. Here's a small gist with the code (to which I've also added a natural binding to tear-off-window, thanks!).
;; gist: https://gist.github.com/jdtsmith/75d76bee292357cbfe18d7eb4a25c9a9
;;
;; Maximize a window vertically or horizontally within its frame
(defun maximize-window-in-direction (&optional horizontally)
  "Maximize window.
Default vertically, unless HORIZONTALLY is non-nil."
  (interactive)
  (unless (seq-every-p
	   (apply-partially #'window-at-side-p nil)
	   (if horizontally '(left right) '(top bottom)))
    (let* ((buf (window-buffer))
	   (top-size (window-size (frame-root-window) (not horizontally)))
	   (size (min (/ top-size 2) (window-size nil (not horizontally))))
	   (dir (if horizontally
		    (if (window-at-side-p nil 'top) 'above 'below)
		  (if (window-at-side-p nil 'right) 'right 'left))))
      (delete-window)
      (set-window-buffer
       (select-window (split-window (frame-root-window) (- size) dir))
       buf))))

(bind-key "C-x 7 1" #'tear-off-window) ; into a new frame
(bind-key "C-x 7 2" #'maximize-window-in-direction) ; vertically
(bind-key "C-x 7 3" (lambda () (interactive (maximize-window-in-direction 'horizontal))))

;;;; * ibuffer
;; https://www.emacswiki.org/emacs/IbufferMode
;; ibuffer - *Nice* buffer switching
;;
;; Search all marked buffers
;;   ‘M-s a C-s’ - Do incremental search in the marked buffers.
;;   ‘M-s a C-M-s’ - Isearch for regexp in the marked buffers.
;;   ‘U’ - Replace by regexp in each of the marked buffers.
;;   ‘Q’ - Query replace in each of the marked buffers.
;;   ‘I’ - As above, with a regular expression.

;;; ibuffer

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer) ; replaces electric-buffer-list
  :config
    ;; Don't show empty buffer groups
    (setq ibuffer-show-empty-filter-groups nil)

    ;; work groups for ibuffer
    (setq ibuffer-saved-filter-groups
          '(("default"
             ("version control" (or (mode . svn-status-mode)
                       (mode . svn-log-edit-mode)
                       (name . "^\\*svn-")
                       (name . "^\\*vc\\*$")
                       (name . "^\\*Annotate")
                       (name . "^\\*vc-")
                       (name . "^\\*git-")
                       (name . "^\\*magit")))
             ("emacs" (or (name . "^\\*scratch\\*$")
                          (name . "^\\*Messages\\*$")
                          (name . "^TAGS\\(<[0-9]+>\\)?$")
                          (name . "^\\*info\\*$")
                          (name . "^\\*Occur\\*$")
                          (name . "^\\*grep\\*$")
                          (name . "^\\*Compile-Log\\*$")
                          (name . "^\\*Backtrace\\*$")
                          (name . "^\\*Process List\\*$")
                          (name . "^\\*gud\\*$")
                          (name . "^\\*Man")
                          (name . "^\\*WoMan")
                          (name . "^\\*Kill Ring\\*$")
                          (name . "^\\*Completions\\*$")
                          (name . "^\\*tramp")
                          (name . "^\\*shell\\*$")
                          (name . "^\\*compilation\\*$")))
             ("Helm" (or (name . "\*helm\*")))
             ("Help" (or (name . "\*Help\*")
                         (name . "\*Apropos\*")
                         (name . "\*info\*")))
             ("emacs-source" (or (mode . emacs-lisp-mode)
                                 (filename . "/Applications/Emacs.app")
                                 (filename . "/bin/emacs")))
             ("emacs-config" (or (filename . ".emacs.d")
                                 (filename . "emacs-config")))
            ("org" (or (name . "^\\*org-")
                        (name . "^\\*Org")
                        (mode . org-mode)
                        (mode . muse-mode)
                        (name . "^\\*Calendar\\*$")
                        (name . "^+current$")
                        (name . "^diary$")
                        (name . "^\\*Agenda")))
             ("latex" (or (mode . latex-mode)
                          (mode . LaTeX-mode)
                          (mode . bibtex-mode)
                          (mode . reftex-mode)))
             ("dired" (or (mode . dired-mode)))
             ("perl" (mode . cperl-mode))
             ("erc" (mode . erc-mode))
             ("shell" (or (mode . shell-mode)
                            (name . "^\\*terminal\\*$")
                            (name . "^\\*ansi-term\\*$")
                            (name . "^\\*shell\\*$")
                            (name . "^\\*eshell\\*$")))
             ("gnus" (or (name . "^\\*gnus trace\\*$")
                            (mode . message-mode)
                            (mode . bbdb-mode)
                            (mode . mail-mode)
                            (mode . gnus-group-mode)
                            (mode . gnus-summary-mode)
                            (mode . gnus-article-mode)
                            (name . "^\\.bbdb$")
                            (name . "^\\.newsrc-dribble"))))))

    ;; Order the groups so the order is : [Default], [agenda], [emacs]
    (defadvice ibuffer-generate-filter-groups (after reverse-ibuffer-groups ()
                                                     activate)
      (setq ad-return-value (nreverse ad-return-value)))

    ;; Hide the following buffers
    ;;(setq ibuffer-never-show-predicates
    ;;      (list "\\*Completions\\*"
    ;;            "\\*vc\\*"))

    ;; Enable ibuffer expert mode, don't prompt on buffer deletes
    (setq ibuffer-expert t)

    ;; Load the 'work' group, can set to load groups by location
    ;; ibuffer-auto-mode is a minor mode that automatically keeps the buffer
    ;; list up to date. I turn it on in my ibuffer-mode-hook:
    (add-hook 'ibuffer-mode-hook
              (lambda ()
                 (ibuffer-auto-mode 1)
                 (ibuffer-switch-to-saved-filter-groups "default")))
)

;;;; * recentf
;; a minor mode that builds a list of recently opened files
;; https://www.emacswiki.org/emacs/RecentFiles
;;
;; NOTE: wasn't able to move the savefile to any other directory
;; recentf
(use-package recentf
  ;:after consult
  ;:bind ("C-x C-r" . recentf-open-files) ;moved binding to consult
  :config
  (setq recentf-save-file "~/.emacs.d/recentf"
        ;recentf-save-file (expand-file-name "recentf" "~/.emacs.d/var/")
	recentf-max-saved-items 500
	recentf-max-menu-items 15
	;; disable recentf-cleanup on Emacs start, because it can cause
	;; problems with remote files
	recentf-auto-cleanup 'never)
  ;(add-to-list 'recentf-exclude '(".*-autoloads\\.el\\'"
  ;				  "[/\\]\\.elpa/"))
  :init
  (recentf-mode 1)
)

;;;; * projectile
;; Projectile - a project interaction library for Emacs
;; https://github.com/bbatsov/projectile
;; Docs: https://docs.projectile.mx/projectile/index.html
;;; projectile
(use-package projectile
  :ensure t
  :defer t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :custom
  (projectile-cache-file (expand-file-name "var/projectile.cache"
                          user-emacs-directory))
  (projectile-known-projects-file (expand-file-name "var/projectile-bookmarks.eld"
                          user-emacs-directory))
)

;;;; * dired
;; Enable dwim - Dired tries to guess a default target directory.
(setq dired-dwim-target t)

;;;; * helpful
;; alternative to the built-in Emacs help provideing more contextual information.
;; https://github.com/Wilfred/helpful
(use-package helpful
  :defer 10
  :ensure t
  :bind
  (("C-h f" . helpful-function)
   ("C-h x" . helpful-command)
   ("C-h h" . helpful-key)
   ("C-h v" . helpful-variable)))

;;;; * --- OS ---
;; From Doom Emacs, look into
;; (:if IS-MAC macos)  ; improve compatibility with macOS

;;;; * macOS
;;; === macOS specific settings
(use-package emacs
  :if (eq system-type 'darwin)
  :config
  ;(setq mac-command-modifier 'meta
  ;      mac-option-modifier 'alt
  ;      mac-right-option-modifier 'super)

  ;; enable srgb mode if compiled in
  ;(setq ns-use-srgb-colorspace t)
  ;; or turn off if causing problems
  ;(setq ns-use-srgb-colorspace nil)

  ;; set keys for Apple keyboard, for emacs in OS X
  (setq mac-command-modifier 'meta) ; make cmd key do Meta
  (setq mac-option-modifier 'super) ; make opt key do Super
  (setq mac-control-modifier 'control) ; make Control key do Control
  ;(setq ns-function-modifier 'hyper)  ; make Fn key do Hyper

  ;; force mac modifier keys
  ;(setq mac-command-modifier	 'super
  ;      ns-command-modifier	 'super
  ;      mac-option-modifier	 'meta
  ;      ns-option-modifier	 'meta
  ;      mac-right-option-modifier 'meta
  ;      ns-right-option-modifier	 'meta)

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

  ;;; set font size to 15, overriding default 12
  ;; M-x describe-font:
  ;; Monaco:pixelsize=12:weight=normal:slant=normal:width=normal:spacing=100:scalable=true
  ;; M-: (face-attribute 'default :font)
  ;; #<font-object "-*-Monaco-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1">
  ;;(set-face-attribute 'default (selected-frame) :height 150)
  ;;(set-face-attribute 'default nil :height 150)
  (set-frame-font "Monaco 15" nil t)
  ;;(set-frame-font "Menlo 15" nil t) ; fit more lines per frame

  ;; FantasqueSansMono-Normal
  ;; https://github.com/belluzj/fantasque-sans
  ;(set-frame-font "Fantasque Sans Mono 18" nil t)

  ;;; this works the same as set-frame-font above?
  ;;(set-face-attribute 'default nil
  ;;  :font "Monaco"
  ;;  :height 150
  ;;  :weight 'regular)
  ;;(set-face-attribute 'italic nil :slant 'italic :underline nil)

  ;; Testing jetbrains mono font, not sure I like it
  ;; https://www.jetbrains.com/lp/mono/
  ;; "JetBrains Mono-13:spacing=100"
  ;;(set-face-attribute 'default nil :font "JetBrains Mono-15" :height 150)
  ;(set-frame-font "JetBrains Mono 15" nil t)

  ;; Osx-trash
  ;; Make Emacs' delete-by-moving-to-trash do what you expect it to do on OS X.
  ;; https://github.com/lunaryorn/osx-trash.el
  ;(use-package osx-trash
  ;   :ensure t
  ;   :config
  ;   (setq delete-by-moving-to-trash t)
  ;   (osx-trash-setup)
  ;)

  ;; Disable railwaycat's tab bar
  ;; https://github.com/railwaycat/homebrew-emacsmacport/issues/123
  (defvar mac-frame-tabbing)
  (setq mac-frame-tabbing nil)

  ;; Don't open up new frames for files dropped on icon, use active frame
  (defvar ns-pop-up-frames)
  (setq ns-pop-up-frames nil)

  ;; Drag and drop on the emacs window opens the file in a new buffer instead of
  ;; appending it to the current buffer
  ;; http://stackoverflow.com/questions/3805658/how-to-configure-emacs-drag-and-drop-to-open-instead-of-append-on-osx
  (if (fboundp 'ns-find-file)
      (global-set-key [ns-drag-file] 'ns-find-file))

  ;; Move deleted files to the System's trash can
  ;; set trash-directory otherwise uses freedesktop.org-style
  (setq trash-directory "~/.Trash")
  (setq delete-by-moving-to-trash t)

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
  (global-set-key [C-x M-w] 'pt-pbcopy)

  ;; add the missing man page path for woman
  ;; https://www.reddit.com/r/emacs/comments/ig7zzo/weekly_tipstricketc_thread/
  ;(add-to-list 'woman-manpath
  ;	      "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man")
  ;(add-to-list 'woman-manpath
  ;	      "/Applications/Xcode.app/Contents/Developer/usr/share/man")
  ;(add-to-list 'woman-manpath
  ;	      "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man")

  ;; On a Mac: make Emacs detect if you have light or dark mode enabled system wide.
  ;;If you have two themes, a light one and a dark one, and you want the dark theme by default unless you have light mode enabled, add this to your init.el:

  ;; If we're on a Mac and the file "~/bin/get_dark.osascript" exists
  ;; and it outputs "false", activate light mode. Otherwise activate
  ;; dark mode.
  ;(cond ((and (file-exists-p "~/bin/get_dark.osascript")
  ;	     (string> (shell-command-to-string "command -v osascript") "")
  ;	     (equal "false\n"
  ;		    (shell-command-to-string "osascript ~/bin/get_dark.osascript")))
  ;	(mcj/theme-set-light))
  ;      (t (mcj/theme-set-dark)))

  ;; (mcj/theme-set-light and mcj/theme-set-light are functions that enable the light and the dark theme, respectively).

  ;;~/bin/get_dark.osascript contains the following:
  ;;
  ;;tell application "System Events"
  ;;	  tell appearance preferences
  ;;		get dark mode
  ;;	  end tell
  ;;end tell
)


;A GNU Emacs library to ensure environment variables inside Emacs look the same as in the user's shell
;https://github.com/purcell/exec-path-from-shell
;Needed to find aspell and probably others
(use-package exec-path-from-shell
  :ensure t
  :defer t
  ;:if (memq window-system '(mac ns x))
  :if (memq (window-system) '(mac ns))
  :config
  ;(setq exec-path-from-shell-arguments nil) ; was '("-l"), breaks aspell?
  ;(setq exec-path-from-shell-debug 1)	; enable debugging
  ;(setq exec-path-from-shell--debug 1) ; print msg if debug enabled
  ;(setq exec-path-from-shell-variables '("PATH" "MANPATH")) ; or use dolist instead
  (dolist (var '("PATH"
                 "MANPATH"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize))

;;;; * linux
;;; === Linux specific settings
(use-package emacs
  :if (eq system-type 'gnu/linux)
  :config
  (defvar browse-url-browser-function)
  (defvar browse-url-browser-program)

  ;; http://stackoverflow.com/questions/15277172/how-to-make-emacs-open-all-buffers-in-one-window-debian-linux-gnome
  ;(setq pop-up-frames 'graphic-only)
  (setq pop-up-frames nil)

  ;; Open up URLs in browser using gnome-open (errors on bytecompile)
  ;(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "gnome-open")
  (setq browse-url-browser-function 'browse-url-firefox)

  ;; Problems with minibuffer font size display in KDE/Crunchbang/Unity(?), fix explictily set font
  ;; List fonts with M-x descript-font
  ;(set-default-font "Monospace-10")
)

;;;; * --- Completion ---
;;(company +childframe) ; the ultimate code completion backend
;;(vertico +icons)      ; the search engine of the future

;; vertico.el - VERTical Interactive COmpletion
;; https://github.com/minad/vertico
;;
;; corfu.el - Completion Overlay Region FUnction
;; https://github.com/minad/corfu
;;
;; marginalia.el - Marginalia in the minibuffer
;; https://github.com/minad/marginalia
;;
;; consult.el - Consulting completing-read
;; https://github.com/minad/consult
;;
;; company-mode - same niche as corfu, staying with corfu for now
;; Modular in-buffer completion framework for Emacs
;; https://company-mode.github.io/
;;
;; NOTE: emacs in a terminal settings to use backspace in minibuffer:
;;  terminal- Preferences, Profiles, Advanced, check Delete sends C-h
;;  iTerm- Preferences, Profiles, Keys, Delete sensd ^H

;;;; * vertico
;; vertico.el - VERTical Interactive COmpletion
;;; vertico

;; https://config.daviwil.com/emacs
;; add similar behavior to ivy, (doesn't work in cli mode?)
; But... kills entire word when trying to fix one, disabling for backspace in vertico
(defun dw/minibuffer-backward-kill (arg)
  "When minibuffer is completing a file name delete up to parent
folder, otherwise delete a word"
  (interactive "p")
  (if minibuffer-completing-file-name
      ;; Borrowed from https://github.com/raxod502/selectrum/issues/498#issuecomment-803283608
      (if (string-match-p "/." (minibuffer-contents))
          (zap-up-to-char (- arg) ?/)
        (delete-minibuffer-contents))
      (backward-kill-word arg)))

;; Enable vertico
(use-package vertico
  :ensure t
  :bind (:map minibuffer-local-map
         ;("<backspace>" . dw/minibuffer-backward-kill) ; works in gui (maybe cli?)
         ("C-h" . dw/minibuffer-backward-kill) ; this works in cli and gui
         ;("M-h" . dw/minibuffer-backward-kill)
         :map vertico-map
         ("C-n" . vertico-next)
         ("C-p" . vertico-previous)
         ("C-v" . vertico-scroll-up)
         ("M-v" . vertico-scroll-down))
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :config
  (setq savehist-file "~/.emacs.d/var/history")
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Support opening new minibuffers from inside existing minibuffers.
  (setq enable-recursive-minibuffers t)

  ;; Emacs 28 and newer: Hide commands in M-x which do not work in the current
  ;; mode.  Vertico commands are hidden in normal buffers. This setting is
  ;; useful beyond Vertico.
  (setq read-extended-command-predicate #'command-completion-default-include-p))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :ensure t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;;;; * corfu
;; corfu.el - Completion Overlay Region FUnction
;; Completions in Regions
;;; corfu

(use-package corfu
  :ensure t
  ;:defer t
  ;; Optional customizations
  :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  ;; (setq completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function. As an alternative,
  ;; try `cape-dict'.
  (setq text-mode-ispell-word-completion nil)

  ;; Emacs 28 and newer: Hide commands in M-x which do not apply to the current
  ;; mode.  Corfu commands are hidden, since they are not used via M-x. This
  ;; setting is useful beyond Corfu.
  (setq read-extended-command-predicate #'command-completion-default-include-p))

;; Use Dabbrev with Corfu! (expand previous word dynamically)
;; Use Dabbrev with Corfu!
(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  ;; Since 29.1, use `dabbrev-ignored-buffer-regexps' on older.
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

;;;; * marginalia
;; marginalia.el - Marginalia in the minibuffer
;; Helpful M-x annotations, think of as a replacement for ivy-rich
;;
;;   :custom
;;   (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
;;; marginalia

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

;;;; * consult
;; consult.el - Consulting completing-read
;;; consult

;; Example configuration for Consult
(use-package consult
  :ensure t
  :defer t
  ;:hook (completion-list-mode . consult-preview-at-point-mode)
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ("C-x C-r" . consult-recent-file)         ;; added for recentf
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("C-s" . consult-line)  ;; replace I-search
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 3. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  ;;;; 4. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 5. No project support
  ;; (setq consult-project-function nil)
)

;;;; * which-key
;; Emacs package that displays available keybindings in popup
;; https://github.com/justbur/emacs-which-key
;;
;; Paging: C-h
;;     Cycle through the pages forward with n (or C-n)
;;     Cycle backwards with p (or C-p)
;;     Undo the last entered key (!) with u (or C-u)
;;     Call the default command bound to C-h, usually describe-prefix-bindings, with h (or C-h)
;;; which-key

(use-package which-key
  :ensure t
  :defer t
  :init (which-key-mode)
  :config
  ;(setq which-key-allow-imprecise-window-fit nil)
  ;(setq which-key-setup-side-window-bottom t) ; Default
  (setq which-key-idle-delay 1.0
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom
        which-key-side-window-max-height 0.50
        which-key-show-remaining-keys t)
)

;;;; * --- Emacs UI ---
;; Modern Emacs UI
;; https://www.youtube.com/watch?v=rwKTc4MNmt8
;; - x treemacs/neotree
;; - solair
;; - golden-ratio
;; - verico pos frame (ido/helm)
;; - x doom modeline
;; - x doom themes (ish)
;; - mac-specific in init.el
;; - padding
;; - x all-the-icons
;; - dashboard
;; - pair programming

;;;; * better defaults
;; A small number of better defaults for Emacs
;; Some taken from:
;;   https://github.com/technomancy/better-defaults
;;   https://git.sr.ht/~technomancy/better-defaults
;;; better defaults

(require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)

;; When you visit a file, point goes to the last place where it was when you previously visited the same file.
;; https://www.emacswiki.org/emacs/SavePlace
(save-place-mode 1)
;(setq save-place-file (locate-user-emacs-file "places" ".emacs-places"))
(setq save-place-file (concat user-emacs-directory "var/places"))
(setq save-place-forget-unreadable-files nil)

(global-set-key (kbd "M-/") 'hippie-expand)

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(savehist-mode 1)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      ;mouse-yank-at-point t
      require-final-newline t
      visible-bell t
      delete-old-versions t
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "var/backups"))))

(setq auto-save-list-file-prefix "~/.emacs.d/var/auto-save-list/") ; set prefix for auto-saves
(setq transient-history-file "~/.emacs.d/var/transient/history.el")

;;;; * treemacs
;; Treemacs - a tree layout file explorer for Emacs
;; https://github.com/Alexander-Miller/treemacs
(use-package treemacs
  :ensure t
  :bind ("<f8>" . treemacs)
  :custom
  (treemacs-is-never-other-window t)
  :hook
  (treemacs-mode . treemacs-project-follow-mode))

;;;; * themes
;; disable all themes
;; Disable all themes before loading a theme
;;; disable themes

(defadvice load-theme (before disable-themes-first activate)
  (fk/disable-all-themes))

(defun fk/disable-all-themes ()
  "Disable all active themes."
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))

;;; dracula-theme
;; dracula-theme with telephone line status bar
;; https://draculatheme.com/
;; https://github.com/dracula/dracula-theme
;; https://www.reddit.com/r/emacs/comments/he55jl/whats_the_funky_character_on_the_mode_line/
(use-package dracula-theme
  :ensure t
  ;:defer t  ;doesn't load when needed
  ;:init
  ;(setq dracula-enlarge-headings nil)
  :config
  ;; Don't change the font size for some headings and titles (default t)
  (setq dracula-enlarge-headings nil)
  (if (display-graphic-p)
      (load-theme 'dracula :no-confirm)	  ; Emacs in own window
    (load-theme 'wheatgrass :no-confirm)  ; Emacs in tty
  )
)

;;;; * icons and glyphs
;; All-the-icons
;; https://github.com/domtronn/all-the-icons.el
;; NOTE: Install the fonts as well: M-x all-the-icons-install-fonts
;(use-package all-the-icons
;  :ensure t)

;; nerd-icons
;; nerd-icons.el - A Library for Nerd Font icons
;; https://github.com/rainstormstudio/nerd-icons.el#installing-fonts
;; To finish, run: M-x nerd-icons-install-fonts
;; # Successfully installed ‘nerd-icons’ fonts to ‘~/Library/Fonts
(use-package nerd-icons
  :ensure t
  ;:defer t
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono")
)

;;;; * doom-modeline
;; A fancy and fast mode-line inspired by minimalism design.
;; https://seagle0128.github.io/doom-modeline/
;; NOTE: Run (all-the-icons-install-fonts) one time after installing
;;; doom modline

(use-package doom-modeline
  :ensure t
  ;:defer t
  :hook (after-init . doom-modeline-mode) ;; removed for envrc hook
  :init (doom-modeline-mode 1)
  :config
  ;; Fix? for Height below 25 not working anymore #187
  ;; https://github.com/seagle0128/doom-modeline/issues/187
  (defun my-doom-modeline--font-height ()
    "Calculate the actual char height of the mode-line."
    (+ (frame-char-height) 1))
  (advice-add #'doom-modeline--font-height :override #'my-doom-modeline--font-height)
)

;;;; * --- Version Control ---
;; :tools - from doom emacs
;; ansible
;; docker
;; (eval +overlay)     ; run code, run (also, repls)
;; lookup              ; navigate your code and its documentation
;; (lsp +eglot)        ; M-x vscode
;; magit               ; a git porcelain for Emacs

;;;; * keymaps versioning (C-c v)
;; Based on projectile's
;; vc-<functions> also under C-x v

(defvar versioning-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "R") '("Git revert file"       . vc-revert))
    (define-key map (kbd "y") '("Kill link to remote"   . +vc/browse-at-remote-kill))
    (define-key map (kbd "Y") '("Kill link to homepage" . +vc/browse-at-remote-kill-homepage))
    (define-key map (kbd "r") '("Git revert hunk"       . +vc-gutter/revert-hunk))
    (define-key map (kbd "s") '("Git stage hunk"        . +vc-gutter/stage-hunk))
    (define-key map (kbd "r") '("Git time machine"      . git-timemachine-toggle))
    (define-key map (kbd "n") '("Jump to next hunk"     . +vc-gutter/next-hunk))
    (define-key map (kbd "p") '("Jump to previous hunk" . +vc-gutter/previous-hunk))
    (define-key map (kbd "/") '("Magit dispatch"        . magit-dispatch))
    (define-key map (kbd ".") '("Magit file dispatch"   . magit-file-dispatch))
    (define-key map (kbd "'") '("Forge dispatch"        . forge-dispatch))
    (define-key map (kbd "g") '("Magit status"          . magit-status))
    (define-key map (kbd "G") '("Magit status here"     . magit-status-here))
    (define-key map (kbd "x") '("Magit file delete"     . magit-file-delete))
    (define-key map (kbd "B") '("Magit blame"           . magit-blame-addition))
    (define-key map (kbd "C") '("Magit clone"           . magit-clone))
    (define-key map (kbd "F") '("Magit fetch"           . magit-fetch))
    (define-key map (kbd "L") '("Magit buffer log"      . magit-log-buffer-file))
    (define-key map (kbd "S") '("Git stage file"        . magit-stage-file))
    (define-key map (kbd "U") '("Git unstage file"      . magit-unstage-file))
    map)
  "Keymap for version commands after `versioning-keymap-prefix'.")
(fset 'versioning-command-map versioning-command-map)
(global-set-key (kbd "C-c v") '("versioning" . versioning-command-map))

    ;; sub-menues (c+create, f+find, l+list, o+open in browser
(defvar vc-find-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "f") '("Find file"           . magit-find-file))
    (define-key map (kbd "g") '("Find gitconfig file" . magit-find-git-config-file))
    (define-key map (kbd "c") '("Find commit"         . magit-show-commit))
    (define-key map (kbd "i") '("Find issue"          . forge-visit-issue))
    (define-key map (kbd "p") '("Find pull request"   . forge-visit-pullreq))
    map)
  "Keymap for vc find commands after `vc-find-keymap-prefix'.")
(fset 'vc-find-command-map vc-find-command-map)
(global-set-key (kbd "C-c v f") '("vc-find" . vc-find-command-map))

(defvar vc-open-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd ".") '("Browse file or region" . +vc/browse-at-remote))
    (define-key map (kbd "h") '("Browse homepage"       . +vc/browse-at-remote-homepage))
    (define-key map (kbd "r") '("Browse remote"         . forge-browse-remote))
    (define-key map (kbd "c") '("Browse commit"         . forge-browse-commit))
    (define-key map (kbd "i") '("Browse an issue"       . forge-browse-issue))
    (define-key map (kbd "p") '("Browse a pull request" . forge-browse-pullreq))
    (define-key map (kbd "I") '("Browse issues"         . forge-browse-issues))
    (define-key map (kbd "P") '("Browse pull requests"  . forge-browse-pullreqs))
    map)
  "Keymap for vc open commands after `vc-open-keymap-prefix'.")
(fset 'vc-open-command-map vc-open-command-map)
(global-set-key (kbd "C-c v o") '("vc-open" . vc-open-command-map))


(defvar vc-list-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "g") '("List gists"          . gist-list))
    (define-key map (kbd "r") '("List repositories"   . magit-list-repositories))
    (define-key map (kbd "s") '("List submodules"     . magit-list-submodules))
    (define-key map (kbd "i") '("List issues"         . forge-list-issues))
    (define-key map (kbd "p") '("List pull requests"  . forge-list-pullreqs))
    (define-key map (kbd "n") '("List notifications"  . forge-list-notifications))
    map)
  "Keymap for vc list commands after `vc-list-keymap-prefix'.")
(fset 'vc-list-command-map vc-list-command-map)
(global-set-key (kbd "C-c v l") '("vc-list" . vc-list-command-map))

(defvar vc-create-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "r") '("Initialize repo" . magit-init))
    (define-key map (kbd "R") '("Clone repo"      . magit-clone))
    (define-key map (kbd "c") '("Commit"          . magit-commit-create))
    (define-key map (kbd "f") '("Fixup"           . magit-commit-fixup))
    (define-key map (kbd "i") '("Issue"           . forge-create-issue))
    (define-key map (kbd "p") '("Pull request"    . forge-create-pullreq))
    map)
  "Keymap for vc create commands after `vc-creaet-keymap-prefix'.")
(fset 'vc-create-command-map vc-create-command-map)
(global-set-key (kbd "C-c v c") '("vc-create" . vc-create-command-map))

;;;; * magit
;; It's Magit! A Git porcelain inside Emacs. https://magit.vc
;; https://github.com/magit/magit

;; Fixes for emacs 27
;; Magit Error: Warning (with-editor): Cannot determine a suitable Emacsclient
(setq-default with-editor-emacsclient-executable "emacsclient")

(use-package magit
  :ensure t
  :defer t
  :commands magit
  ;:bind
  ;  (("C-x g" . magit-status)
  ;   ("C-x G" . magit-status-with-prefix)
  ;   ("C-x M-g" . magit-dispatch)
  ;   ("C-c M-g" . global-magit-file-mode))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :config
  (setq magit-log-section-commit-count 25
        magit-copy-revision-abbreviated t)
)

;; Notes from Reddit
;; PriorOutcome
;;
;; I often find myself wanting to be able to switch between master and a feature branch in magit quickly:
;;
;; (defun lw-magit-checkout-last (&optional start-point)
;;     (interactive)
;;     (magit-branch-checkout "-" start-point))
;; (transient-append-suffix 'magit-branch "w"
;;   '("-" "last branch" lw-magit-checkout-last))
;;
;; So that C-x g b - switches to the last branch I was on, similar to cd -.

;;;; * diff-hl / git-gutter
;; diff-hl: https://github.com/dgutov/diff-hl
(use-package diff-hl
  :ensure t
  ;:defer t
  :config
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

  ;; Highlight changes to the current file in the fringe
  ;(add-hook 'prog-mode-hook #'diff-hl-mode)
  ;(add-hook 'org-mode-hook #'diff-hl-mode)
  ;; Highlight changed files in the fringe of Dired
  ;(add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  ;; Fall back to the display margin, if the fringe is unavailable
  ;(unless (display-graphic-p) (diff-hl-margin-mode))
  ;(setq diff-hl-fringe-bmp-function 'diff-hl-fringe-bmp-from-type)
  ;(setq diff-hl-margin-side 'right)
  ;(diff-hl-margin-mode)

  (diff-hl-mode)
  ;(global-diff-hl-mode)
  ;(diff-hl-margin-mode)
  ;(diff-hl-flydiff-mode)
)

;(use-package git-gutter
;  :ensure t
;  :init
;  (global-git-gutter-mode 1)
;)

;;;; * git-timemachine
;; Copied file to elisp directory
;; https://github.com/emacsmirror/git-timemachine
;;
;; Usage:
;;
;; Visit a git-controlled file and issue M-x git-timemachine (or bind it to a keybinding of your choice). If you just need to toggle the time machine you can use M-x git-timemachine-toggle.
;;
;; Use the following keys to navigate historic version of the file
;; - p Visit previous historic version
;; - n Visit next historic version
;; - w Copy the abbreviated hash of the current historic version
;; - W Copy the full hash of the current historic version
;; - g Goto nth revision
;; - t Goto revision by selected commit message
;; - q Exit the time machine.
;; - b Run magit-blame on the currently visited revision (if magit available).
;; - c Show current commit using magit (if magit available).

(use-package git-timemachine
  :defer t)

;;;; * --- Languages ---
;; emacs-lisp        ; drown in parentheses
;; json              ; At least it ain't XML
;; latex             ; writing papers in Emacs has never been so fun
;; markdown          ; writing docs for people to ignore
;; (org +roam2)      ; organize your plain life in plain text
;; (python +lsp +pyenv) ; beautiful is better than ugly
;; sh                ; she sells {ba,z,fi}sh shells on the C xor
;; yaml              ; JSON, but readable

;; Look at this for info about keybinds
;; https://www.reddit.com/r/emacs/comments/n1qyxt/how_to_set_prefix_names_to_appear_with_whichkey/

;;;; * smartparens
;; Smartparens is a minor mode for dealing with pairs in Emacs.
;; https://github.com/Fuco1/smartparens
;;
;; NOTE: changed smartparens-global-mode to show-smartparens-global-mode
;; https://github.com/Fuco1/smartparens/wiki/Show-smartparens-mode
;;
;; Cheatsheat
;; https://gist.github.com/pvik/8eb5755cc34da0226e3fc23a320a3c95

;(use-package smartparens
;  :ensure t
;  :defer t
;  :hook
;  (prog-mode . smartparens-mode)
;  (org-mode . smartparens-mode)
;)

;;;; * sh-script
;; shell-script-mode is a major mode for shell script editing.
; https://www.emacswiki.org/emacs/ShMode
(use-package sh-script
  :mode (("zshecl" . sh-mode)
         ("\\.zsh\\'" . sh-mode)
         ("\\.sh\\'" . sh-mode))
  :custom
  ;; zsh
  (system-uses-terminfo nil))

(use-package executable
  :hook
  (after-save . executable-make-buffer-file-executable-if-script-p))

;;;; * sed-mode
;; Mode for editing sed files
;; Look for Russ Cox solving advent-of-code using sed
;; /usr/bin/sed -f
(use-package sed-mode
  :ensure t
)

;;;; * markdown-mode
;; # Install pandoc for preview
;; $ brew install pandoc
(use-package markdown-mode
  :ensure t
  :mode ( ;("README\\.md'"   . gfm-mode) ;; github markdown mode?
         ("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc")
)

;;;; * json, yaml, toml, lua

;; json-mode https://github.com/joshwnj/json-mode
;; yaml-mode https://github.com/yoshiki/yaml-mode
;; lua-mode  https://github.com/immerrr/lua-mode
;; TOML [Tom's Obvious Minimal Language]
;; toml-mode https://github.com/dryman/toml-mode.el
;;
;; TODO: enable lsp for each type
(use-package json-mode
  :ensure t
  :defer t
  :mode ("\\.json\\'" . json-mode)
)

(use-package yaml-mode
  :ensure t
  :defer t
  :mode (("\\.yml\\'"  . yaml-mode)
         ("\\.yaml\\'" . yaml-mode))
  :config
  (add-hook 'yaml-mode-hook
      #'(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
)

(use-package toml-mode
  :ensure t
  :defer t
  :mode ("\\.toml\\'" . toml-mode)
)

(use-package lua-mode
  :ensure t
  :defer t
  :mode ("\\.lua\\'"  . lua-mode)
)

;;;; * terraform and hcl
;; terraform-mode - Major mode of Terraform configuration file
;; hcl-mode - Major mode for Hashicorp Configuration Language
;; https://github.com/hcl-emacs
;; Using locally download el files
;;
;; hcl-mode https://github.com/syohex/emacs-hcl-mode
(use-package hcl-mode
  :ensure t
  :defer t
  :mode ("\\.hcl\\'" . hcl-mode)
  :custom (hcl-indent-level 2))

(use-package terraform-mode
  :custom (terraform-indent-level 2)
  :config
  (defun my-terraform-mode-init ()
    ;; if you want to use outline-minor-mode
    ;; (outline-minor-mode 1)
    )
  (add-hook 'terraform-mode-hook 'my-terraform-mode-init))

;;;; * --- Terminals ---
;;;; * eat
;; eat stands for "Emulate A Terminal"
;; https://codeberg.org/akib/emacs-eat
(use-package eat
  :ensure t
  :config
  (eat-eshell-mode)
  (setq eshell-visual-commands '()))

;;;; * ---- Org ---
;;;; * keymaps org (C-c n)
;; Based on projectile's

(defvar org-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "l") #'org-store-link)
    (define-key map (kbd "a") #'org-agenda)
    (define-key map (kbd "c") #'org-capture)
    (define-key map (kbd "o") #'org-info)
    (define-key map (kbd "b") #'org-switchb) ; switch between org buffers
    map)
  "Keymap for org-mode commands after `org-keymap-prefix'.")
(fset 'org-command-map org-command-map)
(global-set-key (kbd "C-c n") '("org notes" . org-command-map))

;(defvar org-roam-command-map
;  (let ((map (make-sparse-keymap)))
;    (define-key map (kbd "l") #'org-roam-buffer-toggle)
;    (define-key map (kbd "f") #'org-roam-node-find)
;    (define-key map (kbd "i") #'org-roam-node-insert)
;    (define-key map (kbd "g") #'org-roam-graph)
;    (define-key map (kbd "c") #'org-roam-capture)
;    (define-key map (kbd "j") #'org-roam-dailies-capture-today)
;    (define-key map (kbd "r") #'bms/org-roam-rg-search)
;    map)
;  "Keymap for org-roam commands after `org-roam-keymap-prefix'.")
;(fset 'org-roam-command-map org-roam-command-map)
;(global-set-key (kbd "C-c n r") '("org-roam" . org-roam-command-map))

(defvar denote-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'denote)
    (define-key map (kbd "o") #'denote-open-or-create)
    (define-key map (kbd "r") #'denote-rename-file)
    (define-key map (kbd "i") #'denote-link) ; "insert" mnemonic
    (define-key map (kbd "b") #'denote-backlinks)
    (define-key map (kbd "f") #'consult-denote-find)
    (define-key map (kbd "g") #'consult-denote-grep)
    map)
  "Keymap for org-roam commands after `denote-keymap-prefix'.")
(fset 'denote-command-map denote-command-map)
(global-set-key (kbd "C-c n d") '("denote" . denote-command-map))

;;;; * org
;; emacs git repos: https://savannah.gnu.org/git/?group=emacs
;; Installation: https://orgmode.org/org.html#Installation
;; Manual: https://orgmode.org/org.html
;;
;; Checked out org git repo and load in early-init.el
;; $ cd ~/emacs.d/src/
;; $ git clone https://git.savannah.gnu.org/git/emacs/org-mode.git
;; $ cd org-mode/
;; $ make autoloads  (and maybe 'make compile' and 'make doc')
;;
;; org-contrib repo, now separate from org
;; git clone https://git.sr.ht/~bzg/org-contrib
;;
;; ob-python-mode-mode repo, for separate python functionality
;; git clone https://gitlab.com/jackkamm/ob-python-mode-mode.git

;; set calenar start of week to Sunday
(use-package calendar
  :custom
  (calendar-week-start-day 0))

;; Prevent inadvertently edits an the invisible part of the buffer (default: smart)
(setq-default org-catch-invisible-edits 'smart)

;; Set to the location of your Org files on your local system
(setq org-directory "~/org")

;; Open all txt files in org-mode
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))

;;; Agenda - Agenda window setup (default: reorganize-frame)
(setq org-agenda-window-setup 'current-window) ;; don't kill my window setup

;; Include emacs diary, not needed if using org-anniversary
;(setq org-agenda-include-diary t)

;; Custom agenda commands
;; http://members.optusnet.com.au/~charles57/GTD/mydotemacs.txt
(setq org-agenda-custom-commands
'(
("P" "Projects"
              ((tags "PROJECT")))

("H" "Office and Home Lists"
     ((agenda)
          (tags-todo "OFFICE")
          (tags-todo "HOME")
          (tags-todo "COMPUTER")
          (tags-todo "DVD")
          (tags-todo "READING")))

;("D" "Daily Action List"
;     ((agenda "" ((org-agenda-ndays 1)
;                     (org-agenda-sorting-strategy
;                        (quote ((agenda time-up priority-down tag-up))))
;                     (org-deadline-warning-days 0)
;                     ))))

("d" "Do today"
   ;; Show all todos and everything due today.
   ((agenda "" (
                ;; Limits the agenda to a single day
                (org-agenda-span 1)
                ))
    (todo "TODO")))

("D" "Deadline due"
     ((tags-todo "+TODO=\"TODO\"+DEADLINE<=\"<today>\""
                 ((org-agenda-overriding-header "Deadline today")))
      (tags-todo "+TODO=\"TODO\"+DEADLINE=\"\""
                 ((org-agenda-overriding-header "No deadline")))))

))


;;; Capture
;; NOTE:  Fibonacci format: 0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100
;; Setup default target for notes and a global hotkey for new ones
;; NOTE:  Need org-mode version 6.3.6 or later for this to work
;; http://stackoverflow.com/questions/3622603/org-mode-setup-problem-when-trying-to-use-capture
(setq org-default-notes-file (expand-file-name "~/org/notes.org"))

;; Capture templates - C-c c t
;; Based on Sacha Chua's org-capture-tempaltes
;; http://pages.sachachua.com/.emacs.d/Sacha.html
(defvar dbj/org-basic-task-template "* TODO %^{Task}
SCHEDULED: %^t

:PROPERTIES:
:Story: %^{story|2|0|0.5|1|2|3|5|8|13}
:END:
:LOGBOOK:
- State \"TODO\"       from \"\"           %U
:END:
%?" "Basic task data")

(defvar dbj/org-basic-jira-template "* TODO %^{Task}
SCHEDULED: %^t

:PROPERTIES:
:Story: %^{story|2|0|0.5|1|2|3|5|8|13}
:URL: %^{URL}
:END:
:LOGBOOK:
- State \"TODO\"       from \"\"           %U
:END:
%?" "Basic task data")

(defvar dbj/org-basic-someday-template "* %^{Task}
:PROPERTIES:
:Story: %^{story|2|0|0.5|1|2|3|5|8|13}
:END:
:LOGBOOK:
- State \"TODO\"       from \"\"           %U
:END:
%?" "Basic task data")

(setq org-capture-templates
      `(("t" "Tasks" entry
          (file "~/org/inbox.org"), dbj/org-basic-task-template)
          ;(file+headline "~/org/inbox.org" "Tasks"), dbj/org-basic-task-template)

        ("j" "Jira" entry
          (file "~/org/inbox.org"), dbj/org-basic-jira-template)

        ("s" "Someday task" entry
          (file "~/org/someday.org"), dbj/org-basic-someday-template)

        ("r" "Reference information" entry
          (file+headline "~/org/reference.org" "Inbox"))

        ("n" "Notes" entry
          (file+headline "~/org/notes.org"))

        ("o" "Journal" entry
          (file+olp+datetree "~/org/journal.org")
          "* %?\nEntered on %U\n  %i\n  %a")
))

;;; Other
;; When adding new heading below the current heading, the new heading is
;; Placed after the body instead of before it.  C-<RET>
(setq org-insert-heading-respect-content t)

;; Set Todo keywords, same as:
;; Shortcut key:  C-c C-t
;; #+TODO: TODO(t) INPROGRESS(p) WAITING(w) | DONE(d) CANCELED(c)
(setq org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "INPROGRESS(p)" "WAITING(w@/!)" "APPT(a)"
               "|"
               "DONE(d/!)" "CANCELED(c@/!)" "DEFERRED(f)")))

;; Set Tags, same as:
;; #+TAGS: home(h) work(w) @computer(c) @phone(p) errants(e)
(setq org-tag-alist '(("@office" . ?o) ("@home" . ?h) ("computer" . ?c)
                      ("phone" . ?p) ("reading" . ?r)))

;; Prevent C-k from killing whole subtrees and losing work (default: nil)
(setq org-special-ctrl-k t)

;; Fontify code buffers in org, instead of grey text
;; This is especially nice when you open an editing buffer with [Ctrl+c ']
;; to insert code into the #+begin_src ... #+end_src area.
(setq org-src-fontify-natively t)

;; org-refile (C-c C-w) settings from:
;; http://www.mail-archive.com/emacs-orgmode@gnu.org/msg34415.html
;; http://doc.norang.ca/org-mode.html#RefileSetup
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets '((org-agenda-files :maxlevel . 2)
                           (nil :maxlevel . 3)))

; Use full outline paths for refile targets - we file directly with IDO
;(setq org-refile-use-outline-path t)
;;(setq org-refile-use-outline-path 'file)

; Targets complete directly with IDO
;(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

;;; Strike-through finished todos
;; sachachua.com/blog/2012/12/emacs-strike-through-headlines-for-done-tasks-in-org/
(setq org-fontify-done-headline t)
(custom-set-faces
 '(org-done ((t (:foreground "PaleGreen"
                 :weight normal
                 :strike-through t))))
 '(org-headline-done
            ((((class color) (min-colors 16) (background dark))
               (:foreground "LightSalmon" :strike-through t)))))

;; Disable company-mode (word completions) in org using company conf var
;(setq company-global-modes '(not org-mode))

;;; Enable other org-babel languages
(org-babel-do-load-languages
  (quote org-babel-load-languages)
  (quote ((emacs-lisp . t)
          (C . t)         ;C
          ;(R . t)         ;R
          (awk . t)       ;Awk
          ;(calc . t)      ; Emacs Calc
          ;(clojure . t)   ;Clojure
          ;(comint . t)    ;
          ;(core . t)      l
          ;(css . t)       ;CSS
          ;(ditaa . f)     ;ditaa
          ;(dot . t)       ;Graphviz
          (emacs-lisp . t) ;Emacs Lisp
          ;(eshell . t)    ;
          ;(eval . t)      ;
          ;(exp . t)       ;
          ;(forth . t)     ;
          ;(fortran . t)   ;Fortran
          (gnuplot . t)   ;requires gnuplot installed
          ;(groovy . t)    ;
          ;(haskell . t)   ;Haskell
          (java . t)      ;Java
          (js . t)        ;Javascript
          ;(julia . t)     ;
          ;(latex . t)     ;LaTeX
          ;(lilypond . t)  ;Lilypond
          ;(lisp . t)      ;Lisp
          ;(lob . t)       ;lob
          ;(lua . t)       ;Lua
          ;(makefile . t)  ;
          ;(matlab . t)    ;MATLAB
          ;(maxima . t)    ;Maxima
          ;(ocaml . t)     ;Objective Caml
          ;(octave . t)    ;octave
          (org . t)       ;Org mode
          (perl . t)      ;Perl
          ;(plantuml . t)  ;Plantuml
          ;(processing . t) ;Processing.js
          (python . t)    ;Python
          ;(ref . t)       ;
          ;(ruby . t)      ;Ruby
          ;(sass . t)      ;Sass
          ;(scheme . t)    ;Scheme
          ;(screen . t)    ;GNU Screen
          (sed . t)       ;Sed
          (shell . t)     ;shell
          (sql . t)       ; SQL
          ;(sqlite .t)     ;SQLite
          ;(table . )      ;
          ;(tangle . t)    ;
)))

;;;; * denote

;; denote: Simple notes with an efficient file-naming scheme
;; https://github.com/protesilaos/denote
;; https://protesilaos.com/codelog/2024-09-04-emacs-denote-3-1-0/
;;
;; Manual: https://protesilaos.com/emacs/denote
;;
;; Notes from system crafters stream
;; https://systemcrafters.net/live-streams/october-6-2023/
;;
;; Note, for silos create a .dir-local.el file
;; M-x add-dir-local-variable
;;   denote-directory
;;   denote-known-keywords

;(defun dw/denote-rename-buffer-with-prefixed-title (&optional buffer)
;  (denote-rename-buffer-with-title)
;  (rename-buffer (concat "[D] " (buffer-name (or buffer (current-buffer) title :unique)))))

;; Set denote-directory via system-name to keep home/work separate
(if (string-match "\\`lothlorien" (system-name))
    (setq denote-directory "~/denote-home/")
  (setq denote-directory "~/denote/"))

;; override org front-matter to add startup overview
(defvar denote-org-front-matter
  "#+title:      %s
#+date:       %s
#+filetags:   %s
#+identifier: %s
#+startup:    overview
\n")

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
;  :bind
;  (("C-c n d n" . denote)
;   ("C-c n d o" . denote-open-or-create)
;   ("C-c n d r" . denote-rename-file)
;   ("C-c n d i" . denote-link) ; "insert" mnemonic
;   ("C-c n d b" . denote-backlinks))
  ;:custom
  ;(denote-directory "~/denote-home")
  ;;; No longer needed in denote 3+ to add [d]
  ;(denote-rename-buffer-function 'dw/denote-rename-buffer-with-prefixed-title)
  :config
  (denote-rename-buffer-mode)
  (require 'denote-org-extras)

  (with-eval-after-load 'org-capture
    (add-to-list 'org-capture-templates
                 '("d" "New note (with Denote)" plain
                   (file denote-last-path)
                   #'denote-org-capture
                   :no-save t
                   :immediate-finish nil
                   :kill-buffer t
                   :jump-to-captured t)))
)

;; consult-denot
;; Integrate denote package with Daniel Mendler's consult
;; https://github.com/protesilaos/consult-denote
;; https://protesilaos.com/emacs/consult-denote

(use-package consult-denote
  :ensure t
;  :bind
;  (("C-c n d f" . consult-denote-find)
;   ("C-c n d g" . consult-denote-grep))
  :config
  (consult-denote-mode 1)
)

;; Additionally, consult-notes could be useful
;; https://github.com/mclear-tools/consult-notes

;;;; * --- AI ---
;;;; * gptel
;; gptel: A simple LLM client for Emacs
;; https://github.com/karthink/gptel
;;
;; Usage: gptel-send C-c RET
(use-package gptel
  :ensure t
  :config
  (setq
   gptel-model 'llama3.2:3b-instruct-q8_0
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '(llama3.2:3b-instruct-q8_0)))
)

;;;; * --- End ---
;; https://www.reddit.com/r/emacs/comments/a6tu8y/outlineminormode_for_emacs_maybe_useful/
;; This makes outline-minor-mode operate a bit more like org-mode <tab> & S-<tab>
;; but you no longer have indent on <tab> so I use M-x indent-region or whatever.

(add-hook 'outline-minor-mode-hook
          (lambda ()
            (define-key
                outline-minor-mode-map
                (kbd "TAB")
                '(menu-item "" nil :filter
                            (lambda
                              (&optional _)
                              (when (outline-on-heading-p)
                                'outline-cycle))))))

;;; Local Variables:
;;; page-delimiter: ";;;; "
;;; outline-regexp: ";;;; "
;;; eval:(outline-minor-mode 1)
;;; eval:(while (re-search-forward "^;;;; \\* " nil t) (outline-toggle-children))
;;; End:

;; Fake the footer to avoid warnings
(provide 'init)
;;; init.el ends here