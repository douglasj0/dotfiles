;;; programming.el --- Emacs programming -*- lexical-binding: t; -*-

;;; Commentary:
;;; programming modes, not core to Emacs functionality.

;;; Code:

;;; * magit
;; It's Magit! A Git porcelain inside Emacs. https://magit.vc
;; https://github.com/magit/magit

;(use-package magit
;  :ensure t
;  :defer t
;  :commands magit
;  :bind
;    (("C-x g"   . magit-status)
;     ("C-x G"   . magit-status-with-prefix)
;     ("C-x M-g" . magit-dispatch)
;     ("C-c M-g" . global-magit-file-mode))
;  :custom
;  ;(magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
;  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
;  (set-variable 'magit-emacsclient-executable "emacsclient")
;  :config
;  (add-to-list 'magit-status-sections-hook
;               'magit-insert-worktrees
;               t)
;  (setq magit-log-section-commit-count 25
;        magit-copy-revision-abbreviated t))

;;; Minimal magit setup for debugging
;;(use-package magit
;;  :ensure t
;;  :bind
;;  (("C-x g" . magit-status)))


;; Notes from Reddit- PriorOutcome
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

;;; try using vc-mode for git/svn
;; C-x v v  -> "Do next action" (e.g., stage and commit)
;; P        -> git push in vc-dir
;; G        -> git pull in vc-dir
;; C-x v l  -> Log of current file
;; C-x v =  -> Diff of current file
(setq vc-follow-symlinks t)


;;; * git-timemachine
;; https://github.com/emacsmirror/git-timemachine  # 4.18
;;
;; Usage:
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


;;; * Syntax checkers
;;; flycheck (external) - TODO getting errors half the time
;;; https://www.flycheck.org/en/latest/
;;;
;;; flymake (built-in)
;;(use-package flymake
;;  :ensure nil
;;  :hook (prog-mode . flymake-mode) ;; Enables flymake in programming modes
;;  :bind (("H-e" . flymake-show-project-diagnostics)) ;; Optional: bind a key to show diagnostics
;;  :custom
;;  (flymake-suppress-zero-counters t) ;; Optional: hide diagnostics count if zero
;;  :config
;;  ;; Additional custom configurations can go here
;;  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
;;  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
;;)


;;; * Languages

;;; * markdown-mode / gfm-mode
;; https://jblevins.org/projects/markdown-mode/
;; gfm-mode = github-markdown-mode
;; Install pandoc for preview
;; $ brew install pandoc
;(use-package markdown-mode
;  :ensure t
;  :commands (markdown-mode gfm-mode) ; Autoloads markdown-mode and gfm-mode
;  :mode (("README\\.md\\'" . gfm-mode) ; Use gfm-mode for README.md files
;         ("\\.md\\'" . markdown-mode) ; Use markdown-mode for .md files
;         ("\\.markdown\\'" . markdown-mode)) ; Use markdown-mode for .markdown files
;  :init
;  ;; Optional: Configure a specific Markdown processor (e.g., pandoc)
;  ;; (setq markdown-command "pandoc")
;  ;; Optional: Hide markup by default
;  ;; (setq-default markdown-hide-markup t)
;  :config
;  ;; Optional: Further configuration specific to markdown-mode
;  ;; For example, enable math support
;  ;; (setq markdown-enable-math t)
;)


;;;; * sed, awk, perl
;; Mode for editing sed files
;; Look for Russ Cox solving advent-of-code using sed
;; /usr/bin/sed -f
;(use-package sed-mode
;  :ensure t
;)

(use-package awk-mode
  :ensure nil
  :mode (("\\.awk\\'" . awk-mode))
)

(use-package perl-mode
  :ensure nil
  :mode ("\\.pl\\'" . perl-mode)
)


;;;; * json, yaml, toml, lua

;; json-mode https://github.com/joshwnj/json-mode
;; yaml-mode https://github.com/yoshiki/yaml-mode
;; lua-mode  https://github.com/immerrr/lua-mode
;; TOML [Tom's Obvious Minimal Language]
;; toml-mode https://github.com/dryman/toml-mode.el

;(use-package json-mode
;  :ensure t
;  :mode "\\.json\\'"
;  :config
;  (progn
;    (setq js-indent-level 2)
;
;    ;; Define custom keybindings for common actions
;    (define-key json-mode-map (kbd "C-c C-f") 'json-pretty-print-buffer) ; Format buffer
;    (define-key json-mode-map (kbd "C-c C-p") 'json-snatcher-display-path) ; Display path to object at point
;  )
;)

;(use-package jsonc-mode
;  :ensure nil
;  :mode "\\.jsonc\\'")

;(use-package yaml-mode
;  :ensure t
;  :mode ("\\.yaml\\'" "\\.yml\\'"))

;(use-package toml-mode
;  :ensure t
;  :mode ("\\.toml\\'" . toml-mode))

;(use-package lua-mode
;  :ensure t
;  :mode ("\\.lua$" . lua-mode)
;  :interpreter ("lua" . lua-mode)
;  :config
;  (setq lua-indent-level 2)
;  (setq lua-check-command "luacheck"))


;;;; * terraform and hcl
;; terraform-mode - Major mode of Terraform configuration file
;; hcl-mode - Major mode for Hashicorp Configuration Language
;; https://github.com/hcl-emacs
;; Using locally download el files
;;
;; hcl-mode https://github.com/syohex/emacs-hcl-mode
;;(use-package hcl-mode
;;  :ensure t
;;  :defer t
;;  :mode ("\\.hcl\\'" . hcl-mode)
;;  :custom (hcl-indent-level 2))
;;
;;(use-package terraform-mode
;;  :ensure t
;;  :defer t
;;  :custom (terraform-indent-level 2)
;;  :config
;;  (defun my-terraform-mode-init ()
;;    ;; if you want to use outline-minor-mode
;;    ;; (outline-minor-mode 1)
;;    )
;;  (add-hook 'terraform-mode-hook 'my-terraform-mode-init))

(provide 'programming)
;;; programming.el ends here
