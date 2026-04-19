;;; tools-shell.el --- shell -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;;; * Terminals -----
;; define terminal keymaps (C-c t)
(define-prefix-command 'term-command-map)
;(define-key term-command-map (kbd "t") #'eat)
(define-key term-command-map (kbd "m") #'term)
(define-key term-command-map (kbd "a") #'ansi-term)
(define-key term-command-map (kbd "s") #'shell)
(define-key term-command-map (kbd "e") #'eshell)
(global-set-key (kbd "C-c t") '("terminals" . term-command-map))

;; shell (commented out after trying shell over tramp)
;(setq explicit-shell-file-name "zsh")
;(setq shell-file-name "zsh")
;(setq explicit-zsh-args '("--login" "--interactive"))
;(defun zsh-shell-mode-setup ()
;  "Set local varialbes for zsh."
;  (setq-local comint-process-echoes t))
;(add-hook 'shell-mode-hook #'zsh-shell-mode-setup)

;; eshell
;; Guide to mastering eshell
;; https://www.masteringemacs.org/article/complete-guide-mastering-eshell

;; https://github.com/xuchunyang/eshell-git-prompt
;(use-package eshell-git-prompt
;  :ensure t
;  :after eshell
;  :functions eshell-git-prompt-use-theme
;  :init
;  (eshell-git-prompt-use-theme 'robbyrussell))

(use-package eshell
  :ensure nil
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :custom
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-visual-commands '("top" "htop" "zsh" "vi" "vim"))
  (eshell-history-size 1000)
  (eshell-buffer-maximum-lines 1000)
  (eshell-hist-ignoredups t)
  (eshell-scroll-to-bottom-on-input t)
  :config
  (defun efs/configure-eshell ()
    ;; Save command history when commands are entered
    (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)
  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)
  ;; Little quality of life improvement if you work with multiple eshell buffers:
  (defun eshell-buffer-name ()
    (rename-buffer (concat "*eshell*<" (eshell/pwd) ">") t))
  (add-hook 'eshell-directory-change-hook #'eshell-buffer-name)
  (add-hook 'eshell-prompt-load-hook #'eshell-buffer-name))
)

;; eat - eat stands for "Emulate A Terminal"
;; https://codeberg.org/akib/emacs-eat
;(use-package eat
;  :ensure t
;  :preface
;  (defun my--eat-open (file)
;      "Helper function to open files from eat terminal."
;      (interactive)
;      (if (file-exists-p file)
;              (find-file-other-window file t)
;          (warn "File doesn't exist")))
;  :config
;  (add-to-list 'eat-message-handler-alist (cons "open" 'my--eat-open))
;  (setq process-adaptive-read-buffering nil) ; makes EAT a lot quicker!
;  (setq eat-term-name "xterm-256color") ; https://codeberg.org/akib/emacs-eat/issues/119"
;  (setq eat-kill-buffer-on-exit t)
;  (setq eat-shell-prompt-annotation-failure-margin-indicator "")
;  (setq eat-shell-prompt-annotation-running-margin-indicator "")
;  (setq eat-shell-prompt-annotation-success-margin-indicator ""))

(provide 'tools-shell)
;;; tools-shell.el ends here
