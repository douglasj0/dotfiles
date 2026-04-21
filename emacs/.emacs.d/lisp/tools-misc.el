;;; tool-misc.el --- ui -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:


;;; * Recentf / Savehist -----
;;; Changed hook to demand for init.el require, enabled both in config
(use-package recentf
  :ensure nil
  :demand t
  ;:hook (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 60)
  (recentf-max-menu-items 15)
  (recentf-exclude '(".*/.emacs.d/" ".*/.git/" ".*tmp/"))  ; Exclude certain directories
  (recentf-auto-cleanup 'never) ; Adjust cleanup behavior
  :config
  ;; Add recent files to a keybinding for easy access
  (global-set-key (kbd "C-x C-t") 'recentf-open-files)  ;; testing
  (recentf-mode 1))

;; Persist minibuffer history over Emacs restarts
(use-package savehist
  :ensure nil
  :demand t
  ;:hook (after-init . savehist-mode)
  :custom
  (savehist-additional-variables '(search-ring regexp-search-ring))
  (savehist-max-length 1000)            ; Store up to 1000 history items
  (savehist-file (expand-file-name "~/.emacs.d/savehist"))
  :config
  (savehist-mode 1))


;;; * Flyspell (internal)
(use-package ispell                     ;
  :ensure nil
  :config
  (setq ispell-program-name
          (cond ((executable-find "aspell") "aspell")
                ((executable-find "hunspell") "hunspell")
                ((eq system-type 'windows-nt) "aspell.exe") ; fallback name
                (t "aspell")))

  ;;; Important for Aspell on Windows: Extra arguments
  ;;(setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))

  (setq ispell-local-dictionary "en_US") ;; Define the dictionary
  ;;; Configure dictionary settings if needed, often necessary on Windows
  (setq ispell-local-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))

(use-package flyspell
  :ensure nil
  :defer t  ;; Lazy load for text-based file types
  :bind (("C-c s a" . flyspell-auto-correct-word)  ;; Auto-correct the word
         ("C-c s w" . ispell-word)                ;; Correct the current word
         ("C-c s p" . flyspell-correct-word-before-point)
         ("C-c s b" . flyspell-buffer)            ;; Check the entire buffer
         ("C-c s n" . flyspell-goto-next-error))  ;; Skip to the next spelling error
  :hook
  ((text-mode       . flyspell-mode)
   (org-mode        . flyspell-mode)
   (markdown-mode   . flyspell-mode)
   (latex-mode      . flyspell-mode)   ;; Add LaTeX support
   (web-mode        . flyspell-mode))) ;; Add Web-mode support for HTML/CSS


;;; nov.el - epub reader
;;; https://depp.brause.cc/nov.el/
;(use-package nov
;  :ensure t
;  :mode ("\\.epub\\'" . nov-mode)
;  ;;:config
;  ;; Optional: Customize default font for better reading experience
;  ;; (defun my-nov-font-setup ()
;  ;;   (face-remap-add-relative 'shr-text :family "Liberation Serif" :height 1.0))
;  ;; (add-hook 'nov-mode-hook 'my-nov-font-setup)
;
;  ;; Optional: Set a specific text width for comfort
;  ;; (setq nov-text-width 80)
;
;  ;; Other configurations can go here.
;)

(provide 'tools-misc)
;;; tools-misc.el ends here
