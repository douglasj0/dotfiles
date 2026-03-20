;;; tools-tramp.el --- Tramp -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;; TRAMP
;; https://www.reddit.com/r/emacs/comments/uto1uv/magit_and_authentication/
;(require 'tramp)
;(require 'auth-source)

(use-package tramp
  :config
  (setq tramp-default-method "ssh") ; Set the default TRAMP method
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path) ; Add own remote path

  ;; Enable TRAMP's support for authentication information from `auth-source'
  (setq auth-sources '("~/.authinfo.gpg" "~/.authinfo" "~/.netrc"))

  ;; https://coredumped.dev/2025/06/18/making-tramp-go-brrrr./
  ;; prevent TRAMP from creating a bunch of extra files and use scp directly when moving files.
  (setq remote-file-name-inhibit-locks t
        tramp-use-scp-direct-remote-copying t
        remote-file-name-inhibit-auto-save-visited t)

  ;; TRAMP uses 2 ways to copy files, OOB and Inline (base64 over ssh)
  ;; inline is usually faster all the way up until about 2MB.  Also, rsync
  ;; can update faster, but can also break remote shells (fixed in 30.3?), use scp
  (setq tramp-copy-size-limit (* 1024 1024) ;; 1MB
        tramp-verbose 2)

  ;; Use Direct Async (faster then before in Tramp 2.7+)
  ;; now magit and git-gutter work better
  (connection-local-set-profile-variables
   'remote-direct-async-process
   '((tramp-direct-async-process . t)))

  ;; change 'server' to remote host
  ;(connection-local-set-profiles
  ; '(:application tramp :machine "server")
  ; 'remote-direct-async-process)

  (setq magit-tramp-pipe-stty-settings 'pty)

  ;; Fix remote compile
  ;; tramp will use ssh connection sharing, but compile command disables, turn back on
  (with-eval-after-load 'tramp
    (with-eval-after-load 'compile
      (remove-hook 'compilation-mode-hook #'tramp-compile-disable-ssh-controlmaster-options)))
)

;;; https://github.com/jsadusk/tramp-hlo
(use-package tramp-hlo
    :ensure t
    :config
    (tramp-hlo-setup)
)

(provide 'tools-tramp)
