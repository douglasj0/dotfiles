;;; early-init.el --- Early Emacs Initialization -*- lexical-binding: t; -*-

;; Garbage Collections
(setq gc-cons-percentage 0.6)

;; Compile warnings
(setq native-comp-async-report-warnings-errors 'silent) ;; native-comp warning
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq fast-but-imprecise-scrolling t)
(setq inhibit-compacting-font-caches t)

;; Prevent the glimpse of un-styled Emacs by disabling UI elements early.
;; These values are read when the frame is created.
(add-to-list 'default-frame-alist '(menu-bar-height . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))

;; Post-Startup Cleanup and Reporting
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f") gcs-done)))

;; end early-init.el
