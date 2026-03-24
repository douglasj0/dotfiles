;;; early-init.el --- Early Emacs Initialization -*- lexical-binding: t; -*-

;;; Commentary:
; Emacs 27.1 introduced early-init.el, which is run before init.el, before
; package and UI initialization happens, and before site files are loaded.

;;; Code:

;;; 1. Startup Optimizations
;;; From: https://emacs.stackexchange.com/questions/34342/is-there-any-downside-to-setting-gc-cons-threshold-very-high-and-collecting-ga
;;; Set garbage collection threshold

;;; Print out values before they're changed for debugging
;;(message "gc-cons-threshold value: %s" gc-cons-threshold)
;;(message "file-name-handler-alist value: %s" file-name-handler-alist)

;;; From: https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
(setq gc-cons-threshold-original gc-cons-threshold)
(setq gc-cons-threshold (* 1024 1024 100))
;;; Set file-name-handler-alist - Q: does setting 'nil' prevents TRAMP from working?
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
;;; Set deferred timer to reset them
(run-with-idle-timer
 5 nil
 (lambda ()
   (setq gc-cons-threshold gc-cons-threshold-original
         file-name-handler-alist file-name-handler-alist-original)
   (makunbound 'gc-cons-threshold-original)
   (makunbound 'file-name-handler-alist-original)
   (message "gc-cons-threshold and file-name-handler-alist restored")))

;;; Avoid the pitfall of “loading old bytecode instead of newer source”
(setq load-prefer-newer t)

;;; Prevent the glimpse of un-styled Emacs by disabling UI elements early.
;;; These values are read when the frame is created.
(add-to-list 'default-frame-alist '(menu-bar-height . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))

;;; Prevent Emacs from automatically initializing packages at startup.
(setq package-enable-at-startup nil)
(advice-add #'package--ensure-init-file :override #'ignore)

;;; Avoid loading site-specific startup files.
(setq site-run-file nil)

;;; allow remembering risky variables, needed for init.org
;;(defun risky-local-variable-p (sym &optional _ignored) nil)


;;; 2. Warning and Message Suppression
;;; Temp solution(s) for JIT Async-native-compile-log compile warnings
;;(setq native-comp-jit-compilation-deny-list '("org-loaddefs" "cl-loaddefs" "tramp-loaddefs"))
;;; or just set silence the errors entirely for now
;;(setq native-comp-async-report-warnings-errors 'silent)
;;; emacs 30 filtering errors by kind, show imporants
(setq native-comp-async-report-warnings-errors-kind 'importants)

;;; Disable ad-redefinition-action messages on startup
;;; Caused by third party functions redefining defadvice
;;; From: https://andrewjamesjohnson.com/suppressing-ad-handle-definition-warnings-in-emacs/
(setq ad-redefinition-action 'accept)

;;; Ignore byte-compile warning
;;; ex. for Emacs 27: Warning: cl package required at runtime
(setq byte-compile-warnings
      '(not unresolved free-vars callargs redefine obsolete lexical
            noruntime make-local cl-functions interactive-only))

;;; Also suppress extraneous package-initialize errors
(setq warning-suppress-log-types '((package reinitialization)))
(setq native-comp-async-report-warnings-errors 'silent)

;;; silence warnings?
;;(setq comp-async-report-warnings-errors nil)


;;; 3. Post-Startup Cleanup and Reporting
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f") gcs-done)))

(provide 'early-init)
;;; early-init.el ends here
