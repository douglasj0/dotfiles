;;; tool-misc.el --- ui -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;;; * Flyspell (internal)
(use-package ispell                     ;
  :ensure nil
  :config
  (setq ispell-program-name (or (executable-find "aspell")
                                (executable-find "hunspell")
                                "aspell"))
  (setq ispell-local-dictionary "en_US") ;; Define the dictionary
  ;; Configure dictionary settings if needed, often necessary on Windows
  (setq ispell-local-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))
  (when (eq system-type 'windows-nt)
    (setq ispell-program-name "aspell.exe")))

(use-package flyspell
  :ensure nil
  :defer t  ;; Lazy load for text-based file types
  :bind (("C-c s a" . flyspell-auto-correct-word)  ;; Auto-correct the word
         ("C-c s w" . ispell-word)                ;; Correct the current word
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
(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode)
  ;;:config
  ;; Optional: Customize default font for better reading experience
  ;; (defun my-nov-font-setup ()
  ;;   (face-remap-add-relative 'shr-text :family "Liberation Serif" :height 1.0))
  ;; (add-hook 'nov-mode-hook 'my-nov-font-setup)

  ;; Optional: Set a specific text width for comfort
  ;; (setq nov-text-width 80)

  ;; Other configurations can go here.
)

(provide 'tools-misc)
;;; tools-misc.el ends here
