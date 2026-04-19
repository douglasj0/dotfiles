;;; tools-ui.el --- ui -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;;; * Themes + Visuals -----
;; https://github.com/catppuccin/emacs
(use-package catppuccin-theme
  :ensure t
  :config
  (setq catppuccin-highlight-matches t)
  (if (display-graphic-p)
      (progn
        ;;(setq catppuccin-flavor 'frappe) ; set before to avoid dbl load
        (load-theme 'catppuccin t))
    (load-theme 'wheatgrass t))) ;; TTY fallback

(use-package diminish
  :ensure t)

;(use-package centered-cursor-mode
;  :commands (centered-cursor-mode)
;  :diminish centered-cursor-mode)

;; nerd-icons.el - A Library for Nerd Font icons
;; https://github.com/rainstormstudio/nerd-icons.el#installing-fonts
;; To finish, run: M-x nerd-icons-install-fonts ; installs to ‘~/Library/Fonts'
(use-package nerd-icons
  :ensure t
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")  ;; Adjust Nerd Font if necessary
  ;:config
  ;(nerd-icons-install-fonts)  ;; Automatically install Nerd Font
)

;; ace-window allows switching to window by number, bind to 'C-x o'
;; not installed by default
;(use-package ace-window
;  :ensure t
;  :bind ("C-x o" . ace-window)
;  :custom
;  (aw-keys '(?a ?b ?c ?d ?e ?f ?g ?h ?i))) ;; Use letters instead of numbers for window selection


;;; * tab-bar
;(use-package tab-bar
;  :init
;  (tab-bar-mode 1)
;  :config
;  (custom-set-variables '(tab-bar-show 1))  ; hide bar if <= 1 tabs open
;  (setq tab-bar-new-tab-choice "*scratch*") ; Start new tabs with the *scratch* buffer
;  (setq tab-bar-close-button nil)  ; Hide the default close button
;  (setq tab-bar-new-button nil)    ; Hide the default new tab button
;  (setq tab-bar-new-tab-to 'right) ; Open new tabs to the right of the current tab
;  (setq tab-bar-tab-hints t)       ; show tab numbers
;
;  ;; Optional: Define custom keybindings, for example, like Safari's
;  (global-set-key (kbd "s-{") 'tab-bar-switch-to-prev-tab)
;  (global-set-key (kbd "s-}") 'tab-bar-switch-to-next-tab)
;  (global-set-key (kbd "s-t") 'tab-bar-new-tab)
;  (global-set-key (kbd "s-w") 'tab-bar-close-tab))


;;; * Keybindings -----
(use-package which-key
  :ensure nil ;; Included in emacs > 30.1
  :diminish which-key-mode
  :init
  (which-key-mode)
  (which-key-setup-minibuffer)
  :config
  (setq which-key-idle-delay 0.3
        which-key-prefix-prefix "◉ "
        which-key-sort-order 'which-key-key-order-alpha
        which-key-min-display-lines 3
        which-key-max-display-columns nil
        which-key-show-remaining-keys t))


;;; * IBuffer -----
;; ibuffer - *Nice* buffer switching
(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b" . ibuffer) ; replaces electric-buffer-list
  :custom
  (ibuffer-expert t) ; Enable expert mode for more ibuffer features.
  (ibuffer-display-summary nil) ; Hide the summary line at the top of the ibuffer list.
  (ibuffer-use-other-window nil)
  (ibuffer-show-empty-filter-groups nil) ; Don't show empty filter groups in the ibuffer list.
  (ibuffer-default-sorting-mode 'filename/process) ; Set the default sorting mode for ibuffer, for example, by filename/process.
  (ibuffer-title-face 'font-lock-doc-face) ; Set the face for the ibuffer title.
  (ibuffer-use-header-line t)
  :config
  (setq ibuffer-formats
        '((mark modified read-only locked " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " name)
          (mark modified read-only locked " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " filename-and-process)
          (mark modified read-only locked " " name " " filename))))


;;: * helpful
;; alternative to the built-in Emacs help provideing more contextual information.
;; https://github.com/Wilfred/helpful
;(use-package helpful
;  :ensure t
;  :defer t
;  :bind
;  (("C-h f" . helpful-function)
;   ("C-h x" . helpful-command)
;   ("C-h h" . helpful-key)
;   ("C-h v" . helpful-variable)
;   ("C-h C" . helpful-at-point))) ;; Show help for symbol at point

(provide 'tools-ui)
;;; tools-ui.el ends here
