;;; early init.el -*- lexical-binding: t; -*-
; eval: (local-set-key (kbd "C-c i") #'consult-outline); outline-regexp: ";;;";

; Author: Douglas Jackson
;;; Commentary:
; Emacs 27.1 introduced early-init.el, which is run before init.el, before
; package and UI initialization happens, and before site files are loaded.
;;; Code:

;; ideasman_42's suggestion
;; https://www.reddit.com/r/emacs/comments/msll0j/do_any_of_you_have_some_tips_on_speeding_up_emacs/
;; default of gc-cons-threshold is 800k
(defvar default-gc-cons-threshold 16777216 ; 16mb
  "my default desired value of `gc-cons-threshold' during normal emacs operations.")

;; make garbage collector less invasive
(setq
  gc-cons-threshold
  most-positive-fixnum
  gc-cons-percentage 0.6)

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early.
;(menu-bar-mode -1)
(tool-bar-mode -1)     ; comment to test emacs 29.1 mac hang
;(toggle-scroll-bar -1) ; comment to test emacs 29.1 mac hang

;;; Temporarily disable the file name handler.
(setq default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
  (lambda (&rest _)
    (setq
      gc-cons-threshold
      default-gc-cons-threshold
      gc-cons-percentage 0.1
      file-name-handler-alist default-file-name-handler-alist)

    ;; delete no longer necessary startup variable
    (makunbound 'default-file-name-handler-alist)))

;; Package initialize occurs automatically, before `user-init-file' is loaded, but after
;; `early-init-file'. We handle package initialization, so we must prevent Emacs from doing it
;; early!
(setq package-enable-at-startup nil)
(advice-add #'package--ensure-init-file :override #'ignore)

;;; and site-run-file
(setq site-run-file nil)

;; Avoid the pitfall of “loading old bytecode instead of newer source”
(setq load-prefer-newer t)

;; Profile emacs startup
;; https://raw.githubusercontent.com/daviwil/dotfiles/master/Emacs.org
(add-hook 'emacs-startup-hook
  (lambda ()
    (message "*** Emacs loaded in %s with %d garbage collections."
      (format "%.2f seconds"
         (float-time
            (time-subtract after-init-time before-init-time)))
      gcs-done)))

;; Disable ad-redefinition-action messages on startup
;; Caused by third party functions redefining defadvice
;; https://andrewjamesjohnson.com/suppressing-ad-handle-definition-warnings-in-emacs/
(setq ad-redefinition-action 'accept)

;;; Ignore byte-compile warning
;; ex. for Emacs 27: Warning: cl package required at runtime
(setq byte-compile-warnings '(not nresolved
                                  free-vars
                                  callargs
                                  redefine
                                  obsolete
                                  noruntime
                                  cl-functions
                                  interactive-only
                                  ))

;; Also suppress extraneous package-initialize errors
(setq warning-suppress-log-types '((package reinitialization)))

;; silence warnings?
(setq comp-async-report-warnings-errors nil)

;; Load org-mode from src before using it
;; https://askubuntu.com/questions/348999/how-to-use-the-latest-stable-version-of-org-mode
;; NOTE: run 'make autoloads && make compile' in org-mode dir after updating
;(add-to-list 'load-path "~/.emacs.d/src/org-mode/lisp")
;require 'org-loaddefs)
;; and org-contrib
;add-to-list 'load-path "~/.emacs.d/src/org-contrib/lisp")

;; org-python removed in org-mode 9.7, fix: https://gitlab.com/jackkamm/ob-python-mode-mode
;; missing python-mode, commented out until we add that
;(add-to-list 'load-path "~/.emacs.d/src/ob-python-mode-mode")
;(require 'ob-python-mode-mode)
;(ob-python-mode-mode 1)

;; allow remembering risky variables, needed for init.org
(defun risky-local-variable-p (sym &optional _ignored) nil)

(provide 'early-init)
