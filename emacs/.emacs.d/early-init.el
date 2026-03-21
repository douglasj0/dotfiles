;;; early-init.el --- Early Emacs Initialization -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:


;; Garbage Collection, fast startup, normal settings afterwards
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

;; Compile warnings
(setq native-comp-verbose nil) ;; hide internal memory compile logs
;(setq native-comp-async-report-warnings-errors 'silent) ;; native-comp warning
;(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))

;; Prevent initialize packages before config
(setq package-enable-at-startup nil)

;; Disable UI elements early, safely
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

;; Prevernt fram resise jitter
(setq frame-inhibit-implied-resize t)

;; Post-Startup Cleanup and Reporting
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f") gcs-done)))

(provide 'early-init)
;;; early-init.el ends here
