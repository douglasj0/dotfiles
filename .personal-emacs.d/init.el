;;; init.el --- -*- lexical-binding: t -*-
;;; lexical scope: https://nullprogram.com/blog/2016/12/22/

;; NOTE: Moved back to init.el due to topgrade issues with early-init.el
;; set elpa directory name based on emacs major version
;(setq package-user-dir (format "~/.emacs.d/elpa-%d" emacs-major-version)) ;ex. elpa-27
;(setq package-user-dir (concat "~/.emacs.d/elpa-" emacs-version)) ;ex. elpa-27.1

;; To refresh package list, run:  M-x package-refresh-contents
;; To manually update installed packages:  M-x package-list-packages U x
;(require 'package)
;(setq package-enable-at-startup nil) ; moved to early-init
;(setq package-archives
;  '(
;    ("melpa" . "https://melpa.org/packages/")     ; milkypostman's pkg archive
;    ("org"   . "https://orgmode.org/elpa/")       ; provides org-plus-contrib
;    ("elpa"  . "https://elpa.gnu.org/packages/"))); default package archive
;
;(package-initialize)
;(unless package-archive-contents
;  (package-refresh-contents))
;
;; Initialize use-package on non-linux platforms
;; install use-package early, needed for org-plus-contrib
;; https://github.com/jwiegley/use-package
;(unless (package-installed-p 'use-package)
;  (package-install 'use-package))

;; Boostrap straight.el package manager
;; https://github.com/raxod502/straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Use straight.el for use-package expressions
(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

;; Load the helper package for commands like `straight-x-clean-unused-repos'
(require 'straight-x)

;; install no-littering as early as possible
; Help keeping ~/.emacs.d clean
; https://github.com/emacscollective/no-littering/
(use-package no-littering               ; Keep .emacs.d clean
  :config
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
)

;; Install and load the latest org-mode version via org-plus-contrib
;; changed to org-contrib, https://orgmode.org/list/87blb3epey.fsf@gnu.org
;; update repos and rebuild: straight-pull-all, then straight-rebuild-all?
(use-package org
  :straight org-contrib
  :hook
  ;(org-mode . variable-pitch-mode)
  (org-mode . visual-line-mode)
  ;(org-mode . org-num-mode)
  :custom
  (org-src-tab-acts-natively t))

;; Simplify tangling, on emacs startup check
(when (file-exists-p "~/.emacs.d/emacs-init.org")
  (org-babel-load-file (expand-file-name "emacs-init.org"
                       user-emacs-directory))
)

;; disable org-roam v2 alert message
;(setq org-roam-v2-ack t)
