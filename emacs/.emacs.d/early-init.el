;;; early-init.el --- Early Emacs Initialization -*- lexical-binding: t; -*-

;;; Commentary:
;;; This file runs *before* init.el. It configures UI defaults, startup optimizations,
;;; and GC tuning in a safe way compatible with packages like Magit, TRAMP, and help-mode.
;;; Fine tuned my initial early-init.el with AI LLM help.

;;; Code:

;; -----------------------------
;; 1. Package system control
;; -----------------------------
;; Disable automatic package initialization; we'll do it manually in init.el
(setq package-enable-at-startup nil)

;; -----------------------------
;; 2. Garbage Collection
;; -----------------------------
;; Temporarily raise GC threshold to speed up startup without breaking runtime
(setq gc-cons-threshold 100000000   ; 100 MB
      gc-cons-percentage 0.6)

;; Restore normal GC after startup (16 MB threshold)
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; use idle timer to ensure help/Magit/etc can run safely
            (run-with-idle-timer
             1 nil
             (lambda ()
               (setq gc-cons-threshold (* 16 1024 1024)  ; 16 MB
                     gc-cons-percentage 0.1)))))


;; -----------------------------
;; 3. Native Compilation
;; -----------------------------
;; suppress verbose logs from native compilation
(setq native-comp-verbose nil)

;; -----------------------------
;; 4. UI tweaks (prevent flicker)
;; -----------------------------
(dolist (param '((menu-bar-lines . 0)
                 (tool-bar-lines . 0)
                 (vertical-scroll-bars . nil)))
  (push param default-frame-alist))

;; Optional: prevent implicit frame resize during startup
;(setq frame-inhibit-implied-resize t)  ;; not sure needed

;; -----------------------------
;; 5. Post-startup reporting
;; -----------------------------
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f") gcs-done)))

(provide 'early-init)
;;; early-init.el ends here
