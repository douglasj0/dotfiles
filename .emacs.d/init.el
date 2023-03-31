;;; -*- lexical-binding: t -*-

;; from https://github.com/danielmai/.emacs.d/blob/master/init.el
;; https://www.reddit.com/r/emacs/comments/5d4hqq/using_babel_to_put_your_init_file_in_org/
;; https://www.reddit.com/r/emacs/comments/673wek/emacs_bankruptcy_and_structure/

;;; Don't show the startup screen, disable startup msg in scratch
(setq inhibit-startup-message t)
(setq-default initial-scratch-message nil)

;;; Set up package
;; Use M-x Package-refresh-contents to reload the list of packages after initial run
(require 'package)
(setq package-archives
  '(("gnu"   . "https://elpa.gnu.org/packages/") ; default package archive
    ("melpa" . "https://melpa.org/packages/")))  ; milkypostman's pkg archive
(package-initialize)

;;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
;; diminish info : https://github.com/emacsmirror/diminish
(unless (or (package-installed-p 'use-package)
            (package-installed-p 'diminish))
  (package-refresh-contents)
  (package-install 'use-package)
  ;(package-install 'diminish)
)

;; From use-package README
(eval-when-compile
  (require 'use-package))
;(require 'diminish)                ;; if you use :diminish
(require 'bind-key)

;;; Load the config (will re-tangle on org file change)
(org-babel-load-file (concat user-emacs-directory "config.org"))
