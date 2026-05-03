;;; tools-tramp.el --- Tramp -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;; TRAMP
;; https://www.reddit.com/r/emacs/comments/uto1uv/magit_and_authentication/
(use-package tramp
  :ensure nil
  :defer t
  :init
  (setq tramp-default-method "ssh") ; Set the default TRAMP method

  :config
  (setq tramp-use-ssh-controlmaster-options t
        tramp-verbose 1
        tramp-chunksize 2000                   ;; reduce tramp overhead
        tramp-copy-size-limit (* 1024 1024)    ;; 1 MB
        tramp-use-scp-direct-remote-copying t
        remote-file-name-inhibit-locks t
        remote-file-name-inhibit-auto-save-visited t)

  ;;(add-to-list 'tramp-remote-path 'tramp-own-remote-path) ;; Add remote path
  (add-to-list 'tramp-remote-path 'tramp-default-remote-path)
  ;;(add-to-list 'tramp-remote-path "/usr/local/bin")
  ;;(add-to-list 'tramp-remote-path "/usr/bin")

  ;; Use Direct Async (faster then before in Tramp 2.7+)
  ;; now magit and git-gutter work better
  (connection-local-set-profile-variables
   'remote-direct-async-process
   '((tramp-direct-async-process . t)))

  ;; Fix remote compile, uses ssh connection sharing
  ;; compile command disablesm this, re-enable
  (with-eval-after-load 'compile
    (remove-hook 'compilation-mode-hook
                 #'tramp-compile-disable-ssh-controlmaster-options))

  ;; https://coredumped.dev/2025/06/18/making-tramp-go-brrrr./
  ;; prevent TRAMP from creating a bunch of extra files and use scp directly when moving files.
  (setq remote-file-name-inhibit-locks t
        tramp-use-scp-direct-remote-copying t
        remote-file-name-inhibit-auto-save-visited t)

  ;;(setq magit-tramp-pipe-stty-settings "")  ;; was 'pty

  ;; keep connection history across sessions
  (setq tramp-persistency-file-name
        (expand-file-name "tramp" user-emacs-directory))
)

;;; tramp-hlo
;;; Higher level emacs functions as optimized tramp operations
;;; https://github.com/jsadusk/tramp-hlo
;;(use-package tramp-hlo
;;    :ensure t
;;    :after tramp
;;    :config
;;    (tramp-hlo-setup)
;;)

(provide 'tools-tramp)
;;; tools-tramp.el ends here
