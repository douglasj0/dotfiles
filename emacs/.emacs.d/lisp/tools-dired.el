;;; tools-dired.el -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;;; * ls-lisp
;; OSX/BSD ls doesn't sort directories first, ls-lisp can
(use-package ls-lisp
  :ensure nil
  ;:if (eq system-type 'darwin)
  :if (memq system-type '(darwin gnu/linux))
  :custom
  (ls-lisp-emulation 'MacOS)
  (ls-lisp-ignore-case t)
  (ls-lisp-verbosity nil) ;; Hide link/user/group
  (ls-lisp-dirs-first t)
  (ls-lisp-use-insert-directory-program nil))

;;; * dired
;(use-package casual
;  :ensure t
;  :defer t
;  :custom (casual-lib-use-unicode t))

;(use-package casual-dired
;  :after dired)

(use-package dired
  :ensure nil
  :custom
  (delete-by-moving-to-trash t)
  (dired-dwim-target t) ;; Guess target dir if two dired windows open
  (dired-listing-switches "-alh -v --group-directories-first")
  :bind (:map dired-mode-map
         ("C-o" . casual-dired-tmenu)
         ("?" . casual-dired-tmenu)
         ("s" . casual-dired-sort-by-tmenu)
         ("C-x j" . dired-jump)
         ("C-x 4 C-j" . dired-jump-other-window))
  :config
  ;; mac 'ls' doesn't support --dired
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired nil))
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always))

;; Configure the built-in Dired-X package
(use-package dired-x
  :ensure nil
  :after dired
  :bind (("C-x C-j"   . dired-jump) ;; Jump to current file's directory in dired
         ("C-x 4 C-j" . dired-jump-other-window))
  :config
  (setq-default dired-omit-files-p t)
  (add-to-list 'dired-omit-extensions ".DS_Store") ; macOS DS_Store files
  (add-to-list 'dired-omit-extensions ".swp")  ; Vim swap files
  (add-to-list 'dired-omit-extensions ".bak")  ; Backup files
  (add-to-list 'dired-omit-extensions ".~"))    ; Temporary files

(provide 'tools-dired)
;;; tools-dired.el ends here
