;;; -*- lexical-binding: t -*-

;; from https://github.com/danielmai/.emacs.d/blob/master/init.el
;; https://www.reddit.com/r/emacs/comments/5d4hqq/using_babel_to_put_your_init_file_in_org/
;; https://www.reddit.com/r/emacs/comments/673wek/emacs_bankruptcy_and_structure/

;; Turn off mouse interface early in startup to avoid momentary display
;(when window-system
;  (menu-bar-mode -2)
;  (tool-bar-mode -1)
;  (scroll-bar-mode -1)
;  (tooltip-mode -1))

;; time in the mode line
;(display-time-mode 1)

;;; Don't show the startup screen, disable startup msg in scratch
(setq inhibit-startup-message t)
(setq-default initial-scratch-message nil)

;;; Set up package
(require 'package)
(setq package-archives
  '(("gnu"   . "https://elpa.gnu.org/packages/") ; default package archive
    ("melpa" . "https://melpa.org/packages/")))  ; milkypostman's pkg archive
(package-initialize)


;; Add package sources
;(unless (assoc-default "melpa" package-archives)
;  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
;(unless (assoc-default "nongnu" package-archives)
;  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t))

;; Use M-x Package-refresh-contents to reload the list of packages after adding these for the first time.


;(add-to-list 'package-archives
;             '("melpa" . "http://melpa.org/packages/") t)
;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;(when (boundp 'package-pinned-packages)
;  (setq package-pinned-packages
;        '((org-plus-contrib . "org"))))
;(Package-initialize)

;;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
;; diminish: https://github.com/emacsmirror/diminish
(unless (or (package-installed-p 'use-package)
            (package-installed-p 'diminish))
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'diminish))

;; From use-package README
(eval-when-compile
  (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)

;;; Load the config (will re-tangle on org file change)
(org-babel-load-file (concat user-emacs-directory "config.org"))
