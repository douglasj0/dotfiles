;;; completion.el --- completion -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;;; * Completions -----
;; vertico.el - VERTical Interactive COmpletion
;; https://github.com/minad/vertico
(use-package vertico
  :ensure t
  :bind (:map vertico-map
              ("<backspace>" . vertico-directory-delete-char)
              ("C-h" . vertico-directory-delete-word)
              ("C-n" . vertico-next)
              ("C-p" . vertico-previous)
              ("C-v" . vertico-scroll-up)
              ("M-v" . vertico-scroll-down))

  :init
  (vertico-mode)
  (vertico-multiform-mode)
  :custom
  ;(vertico-multiform-commands ; customize display per-command
  ; '(;(execute-extended-command flat) ; I prefer the vert list
  ;   (consult-line reverse)
  ;   (consult-recent-file reverse)
  ;   (find-file reverse)))
  (vertico-resize t)
  (vertico-count 15)
  (vertico-multiform-commands
   '((consult-line reverse)
     (consult-recent-file reverse)
     (find-file reverse))))

;; corfu.el - Completion Overlay Region FUnction
;; https://github.com/minad/corfu
(use-package corfu
  :ensure t
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  :custom
  (corfu-auto t)
  (corfu-count 8)
  (corfu-auto-prefix 2))

;; Use corfu in tui, replace child frames with overlay-based popups
(use-package corfu-terminal
  :ensure t
  :hook
  (corfu-mode . corfu-terminal-mode))

;; marginalia.el - Marginalia in the minibuffer
;; https://github.com/minad/marginalia
(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; https://github.com/oantolin/orderless
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion))))

;; consult.el - Consulting completing-read
;; https://github.com/minad/consult
(use-package consult
  :ensure t
  :bind
  ;("M-b" . consult-buffer)
  ("M-b"     . switch-to-buffer)                ;; remap to access switch-to-buffer
  ("C-x b"   . consult-buffer)                ;; orig. switch-to-buffer
  ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
  ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
  ("C-s"     . consult-line)  ;; replace I-search
  ("C-x C-r" . consult-recent-file)         ;; added for recentf
  :hook (completion-list-mode . consult-preview-at-point-mode))

(provide 'completion)
;;; completion.el ends here
