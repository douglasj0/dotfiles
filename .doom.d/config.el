;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Douglas Jackson"
      user-mail-address "hpotter@hogworts.edu")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;; ---------------------------------------------------------------------------
;; My Customizations
;;; ---------------------------------------------------------------------------

;Info directories (INFOPATH):
(add-to-list 'Info-directory-list
   "~/Sync/my_homedir_files/emacs.d/info")

;; Create new scratch buffer if needed
(run-with-idle-timer 2 t
    '(lambda () (get-buffer-create "*scratch*")))

;; set font to 14, overriding default of 12
(set-face-attribute 'default nil :height 140)

;;;; Only start server if it is not currently running
;(require 'server) ;; Note: (start-server) is now mostly deprecated
(load "server")
(setq server-socket-dir "~/.emacs.d/var/tmp")
(unless (server-running-p) (server-start))

;; Upcase and downcase regions
(put 'upcase-region 'disabled nil)  ; C-x C-u
(put 'downcase-region 'disabled nil)  ; C-x C-l

;; Use CUA mode for rectangles (C-RET to select, normal emacs keys to copy)
;;; http://emacs-fu.blogspot.com/2010/01/rectangles-and-cua.html
;; fix org-return hogging C-RET for rectangles in doom emacs by remapping it
;; https://emacs.stackexchange.com/questions/37404/rebind-c-ret-in-cua-mode-to-a-different-key
;(setq cua-rectangle-mark-key (kbd "C-^"))
(global-unset-key "\C-z")
;(setq cua-rectangle-mark-key (kbd "C-z '"))
(setq cua-rectangle-mark-key (kbd "C-z C-SPC"))
(cua-selection-mode t)
(setq cua-enable-cua-keys nil)  ;; only for rectangles, keeps (C-c, C-v, C-x).
(cua-mode t)

;; Upcase and downcase regions
(put 'upcase-region 'disabled nil)  ; C-x C-u
(put 'downcase-region 'disabled nil)  ; C-x C-l

;; Goal Column, enter C-x C-n, at point to set column that C-n should go to
;; to clear enter C-u C-x C-n
(put 'set-goal-column 'disabled nil)

;; delete up to provided character
;; https://www.emacswiki.org/emacs/ZapUpToChar
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.")
(global-set-key (kbd "M-z") 'zap-up-to-char)

;; disable electric-indent if active, added in Emacs 24.4
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; dwim and narrow or widen
;; https://gist.github.com/mwfogleman/95cc60c87a9323876c6c
;; http://endlessparentheses.com/emacs-narrow-or-widen-dwim.html
(defun narrow-or-widen-dwim ()
  "If the buffer is narrowed, it widens. Otherwise, it narrows to region, or Org subtree."
  (interactive)
  (cond ((buffer-narrowed-p) (widen))
        ((region-active-p) (narrow-to-region (region-beginning) (region-end)))
        ((equal major-mode 'org-mode) (org-narrow-to-subtree))
        (t (error "Please select a region to narrow to"))))
(global-set-key (kbd "C-x n n") 'narrow-or-widen-dwim)  ; was: C-c n then C-c x

;; Match Paren / based on the vim command using %
;; emacs for vi users: http://grok2.tripod.com
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'match-paren)

;; from https://zzamboni.org/post/my-doom-emacs-configuration-with-commentary/
;; remap Mac Modifiers-
;; Change the Mac modifiers to my liking. I also disable passing Control characters to the system, to avoid that C-M-space launches the Character viewer instead of running mark-sexp.
;; (cond (IS-MAC
;;        (setq mac-command-modifier       'meta    ; make cmd key Meta
;;              mac-option-modifier        'super   ; make opt key Super
;;              mac-right-option-modifier  'super
;;              mac-control-modifier       'control ; leave Control alone
;;              ;ns-function-modifier       'hyper   ; make Fn key Hyper
;;              mac-pass-control-to-system nil)))

;; When at the beginning of the line, make Ctrl-K remove the whole line, instead of just emptying it.
;(setq kill-whole-line t) ;; deletes line too, not what I'm used to

;; Doom configures auth-sources by default to include the Keychain on macOS, but it puts it at the beginning of the list. This causes creation of auth items to fail because the macOS Keychain sources do not support creation yet. I reverse it to leave ~/.authinfo.gpg at the beginning.
(after! auth-source
  (setq auth-sources (nreverse auth-sources)))

;; Map C-c C-g to magit-status - I have too ingrained muscle memory for this keybinding. Doom maps to C-c v g
;(map! :after magit "C-c C-g" #'magit-status)


;;; ---------------------------------------------------------------------------
;; Daily Log
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


;;; lsp / python
(setenv "WORKON_HOME" "~/.pyenv/versions")
(setq pyvenv-workon "emacs-venv") ;; Set default venv from versions
;(pyvenv-mode t) ;; enable pyvenv-mode

;;; You don't need to do anything besides enable the :tools lsp module.
;; lsp-ui-mode is enabled for you.
;; However, Doom disables lsp-ui-doc-enable by default because it's redundant
;; with the +lookup/documentation command bound to the K key (in normal mode)
;; or C-c c k if you don't use evil. To enable it:
;;(after! lsp-ui
;;  (setq lsp-ui-doc-enable t))

;;; ---------------------------------------------------------------------------
;; org-mode
;; Disable line numbers in org files
;; https://github.com/hlissner/doom-emacs/issues/827
(add-hook! 'org-mode-hook #'doom-disable-line-numbers-h)

;; Disable company-mode (word completions) in org using company conf var
(setq company-global-modes '(not org-mode))

;; Disable org-mode first line indention
;; https://github.com/hlissner/doom-emacs/issues/3872
;(electric-indent-mode -1) ; globally
;; or
;(add-hook! 'org-mode-hook (electric-indent-local-mode -1))
(after! org
  (setq org-startup-indented nil)

;; Prevent C-k from killing whole subtrees and losing work
(setq org-special-ctrl-k t)

;; org-mode capture template testing
;; this worked and prepended, use as a tempalate
;; (after! org
;;   (add-to-list 'org-capture-templates
;;              '("d" "Dream" entry
;;                (file+headline +org-capture-todo-file "Dream")
;;                "* TODO %?\n :PROPERTIES:\n :CATEGORY: dream\n :END:\n %i\n"
;;                :prepend t :kill-buffer t))
;; )

;; org-capture templates (keys already used: t, n, j, p, o)
;; enter in reverse order to how it should be presented
;; NOTE:  Fibonacci sequence: 0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100
;(after! org
    (add-to-list 'org-capture-templates
      '("N" "Notes" entry
          (file+headline "~/org/notes.org" "Notes")))

    (add-to-list 'org-capture-templates
      '("r" "Reference" entry
          (file+headline "~/org/reference.org" "Inbox")))

    (add-to-list 'org-capture-templates
      '("s" "Someday task" entry
          (file "~/org/someday.org")
          "* TODO %^{Task}\n:PROPERTIES:\n:Story: %^{Story|2|0|0.5|1|2|3|5|8|13}\n:END:\n:LOGBOOK:\n- State \"TODO\"       from \"\"           %U\n:END:\n%?"))

    (add-to-list 'org-capture-templates
      '("J" "Jira" entry
          (file "~/org/inbox.org")
          "* TODO %^{Task}\nSCHEDULED: %^t\n\n:PROPERTIES:\n:Story: %^{story|2|0|0.5|1|2|3|5|8|13}\n:END:\n:LOGBOOK:\n- State \"TODO\"       from \"\"           %U\n:END:\n%?"))

    (add-to-list 'org-capture-templates
      '("T" "Tasks" entry
          (file "~/org/inbox.org")
          "* TODO %^{Task}\nSCHEDULED: %^t\n\n:PROPERTIES:\n:Story: %^{story|2|0|0.5|1|2|3|5|8|13}\n:END:\n:LOGBOOK:\n- State \"TODO\"       from \"\"           %U\n:END:\n%?"))
) ;; end org


;;; ---------------------------------------------------------------------------
;; org-roam
;; Set org-roam-directory based on system-name.
;; orig test: if (string= (system-name) "lothlorien.local")
;; https://stackoverflow.com/questions/8691398/how-to-test-if-system-name-matches-a-string-in-emacs-with-emacs-lisp
(if (string-match "\\`lothlorien" (system-name))
    (setq org-roam-directory "~/org-roam-home")
  (setq org-roam-directory "~/org-roam/")
)

;; Org Roam Capture Templates
(after! org-roam
  (setq org-roam-capture-templates
  '(("d" "default" plain "%?"
     :if-new (file+head "%<%Y%m%d>-${slug}.org"
                        "#+title: ${title}\n#+created: %u\n#+last_modified: %u\n#+roam_alias: \n#+startup: overview\n#+category: ${title}\n#+filetags: \n")
     :unnarrowed t))))

;; Update a field (#+LAST_MODIFIED: ) at save using bulit in time-stamp
;; https://org-roam.discourse.group/t/update-a-field-last-modified-at-save/321
;;
(add-hook 'org-mode-hook (lambda ()
                         (setq-local time-stamp-active t
                                     time-stamp-line-limit 18
                                     time-stamp-start "^#\\+LAST_MODIFIED: [ \t]*"
                                     time-stamp-end "$"
                                     time-stamp-format "\[%Y-%m-%d %a %H:%M\]")
                         (add-hook 'before-save-hook 'time-stamp nil 'local)))

;; Using consult-ripgrep with org-roam for searching notes
;; https://org-roam.discourse.group/t/using-consult-ripgrep-with-org-roam-for-searching-notes/1226
(defun bms/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-command "rg --null --ignore-case --type org --line-buffered --color=always --max-columns=500 --no-heading --line-number . -e ARG OPTS"))
    (consult-ripgrep org-roam-directory)))
(global-set-key (kbd "C-c n g") 'bms/org-roam-rg-search) ;;was C-c rr

;;;------------------------------ Testing -------------------------------------
;; dired-sidebar
;; https://github.com/jojojames/dired-sidebar
;; Added (packag! dired-sidebar) to .doom.d/packages.el
;(require 'dired-sidebar)

;; change toogle to match treemacs C-c o p
;(global-set-key (kbd "C-c o p") 'dired-sidebar-toggle-sidebar)
;;(global-set-key (kbd "C-x C-n") 'dired-sidebar-toggle-sidebar)

;(add-hook 'dired-sidebar-mode-hook
;          (lambda ()
;            (unless (file-remote-p default-directory)
;              (auto-revert-mode))))

;(push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
;(push 'rotate-windows dired-sidebar-toggle-hidden-commands)

;(setq dired-sidebar-subtree-line-prefix "__"
;      ;dired-sidebar-theme 'vscode
;      dired-sidebar-use-term-integration t
;      dired-sidebar-use-custom-font t)

;; fix g710 keyboard, seems right/left option are swapped? (-right was 'none)
;(cond (IS-MAC
;       (setq mac-command-modifier      'meta
;             mac-option-modifier       'alt
;             mac-right-option-modifier 'super)))

;; force mac modifier keys
(setq mac-command-modifier      'super
      ns-command-modifier       'super
      mac-option-modifier       'meta
      ns-option-modifier        'meta
      mac-right-option-modifier 'meta
      ns-right-option-modifier  'meta)

;; mac 'ls' doesn't support --dired
(when (string= system-type "darwin")       
  (setq dired-use-ls-dired nil))

;; switch to treemacs window
(global-set-key (kbd "C-x p") 'treemacs-select-window)
;; and enable treemacs-follow-mode
(after! treemacs
  (treemacs-follow-mode 1))

;; eglot
;; https://github.com/joaotavora/eglot
;;
;; install black, tox, flake8, pyflakes, isort   #pyright
;; $ pip install --upgrade black tox isort flake8
;;   black - reports code errors and also fixes them
;;   tox - automate standard testing in python
;;   flake8 - linter, python version specific
;;     "wrapper which verifies pep8, pyflakes and circular complexity"
;;   pyflakes - linter, faster then pylint (needed by flake8?)
;;   isort - sort imports alphabetically and by type
;;   pyright - another language server (like pylsp)
;;
;; Install langauge server pylsp
;; https://github.com/python-lsp/python-lsp-server
;; $ pip3 install python-lsp-server
;; Verify: pylsp --help
;; eglot doesn't seen able to find it, set as default
(set-eglot-client! 'python-mode '("pylsp"))
;(set-eglot-client! 'python-mode '("~/.asdf/shims/pylsp"))
;(set-eglot-client! 'python-mode '("~/.pyenv/shims/pylsp"))

;; ipython and jupyter args
(setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))
(setq +python-jupyter-repl-args '("--simple-prompt"))

;; paste into vterm when it is active
(defun dj-vterm-keys ()
  (local-set-key (kbd "C-y") 'vterm-yank))
(add-hook 'vterm-mode-hook #'dj-vterm-keys)

;; Using flymake https://discourse.doomemacs.org/t/moving-from-flycheck-checkers-syntax-to-flymake/2879
;; Start flymake in prog-modes.
(add-hook! prog-mode #'flymake-mode)

;; use flake8 with flymake
;; if pyflakes is installed, flymake uses it, but cli flake8 fails without it
;; seems to work now?
;(setq flymake-python-pyflakes-executable "flake8")
;(setq flymake-python-pyflakes-extra-arguments '("--ignore=W806"))
;(setq python-check-command "flake8")


;; Once you start using lsp, check the information in that link about telling flymake about lsp.
;(after! lsp-mode
;  (setq lsp-diagnostics-provider :flymake))


;; set other-window and ace-window
(global-set-key (kbd "C-x O") 'other-window)
(global-set-key (kbd "C-x o") 'ace-window)


;; It’s useful to have a scratch buffer around, and more useful to have a key chord to switch to it.
(defun switch-to-scratch-buffer ()
  "Switch to the current session's scratch buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))
(bind-key "C-c f s" #'switch-to-scratch-buffer)


;; disable global font lock and/or tree-sitter
;(global-font-lock-mode -1)
;(tree-sitter-hl-mode -1)

;;; -- Testing ---
;;; https://www.reddit.com/r/emacs/search?q=Weekly%20tips&restrict_sr=on&sort=new&t=all

;;; https://www.reddit.com/r/emacs/comments/11lqkbo/weekly_tips_tricks_c_thread/
(advice-add 'vertico--setup :before (lambda () (setq vertico-count 15)))
(define-key minibuffer-local-map (kbd "s-'") (lambda ()
  (interactive)
  (let ((vertico-resize t))
    (setq vertico-count (if (= vertico-count 15) (- (frame-height) 5) 15))
    (vertico--exhibit))))

;;;doom emacs Help info hidden behind at bottom minibuffer?
(setq which-key-allow-imprecise-window-fit nil)
