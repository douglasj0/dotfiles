;;; tools-org-roam.el --- org-roam -*- lexical-binding: t; -*-

;;; Commentary:
;;; Testing out org-roam again.
;;; Other releated packages to investigate
;;;   org-roam query language:  https://github.com/ahmed-shariff/org-roam-ql
;;;   consult-notes: https://github.com/mclear-tools/consult-notes

;;; Code:

(use-package org-roam
  :ensure t
  :defer t  ;; Don't load until a command is called
  :hook (org-roam-mode . consult-org-roam-mode)
  :custom
  (org-roam-directory (file-truename "~/org-roam"))
  ;; Show tags in the Vertico/Consult menu
  (org-roam-node-display-template
   (concat "${title:*} " (propertize "${tags:50}" 'face 'org-tag)))

  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)) ; Added capture shortcut

  :config
  ;; updates modified date on save
  (defun my/org-roam-update-modified ()
    (when (and (derived-mode-p 'org-mode)
               (boundp 'org-roam-directory)
               (buffer-file-name)
               (buffer-modified-p)
               (string-prefix-p (expand-file-name org-roam-directory)
                                (buffer-file-name)))
      (save-excursion
        (goto-char (point-min))
        (let ((new-ts (format-time-string "[%Y-%m-%d %a %H:%M]")))
          (if (re-search-forward "^#\\+modified: \\(.*\\)" nil t)
              (let ((old-ts (match-string 1)))
                (unless (string= old-ts new-ts)
                  (replace-match (format "#+modified: %s" new-ts))))
            ;; If missing, insert it after #+date
            (when (re-search-forward "^#\\+date:.*" nil t)
              (end-of-line)
              (insert (format "\n#+modified: %s" new-ts))))))))

  (add-hook 'before-save-hook #'my/org-roam-update-modified)

  ;; moves the cursor to end of capture buffer
  (add-hook 'org-capture-mode-hook
            (lambda () (goto-char (point-max)))
            t)  ;; run last after other hooks

  ; Ensure IDs are created when file saved
  (org-id-update-id-locations)
  (org-roam-db-autosync-mode)


  ;; Custom Templates
  (setq org-roam-capture-templates
        '(
          ("d" "default" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
"#+title:    ${title}
#+date:     %U
#+modified: %<[%Y-%m-%d %a %H:%M]>
#+startup:  overview
#+filetags: %^g

")
           :unnarrowed t)

          ;; Template for "jaj" subdirectory
          ("j" "jaj" plain "%?"
           :target (file+head "jaj/%<%Y%m%d%H%M%S>-${slug}.org"
"#+title:    ${title}
#+date:     %U
#+modified: %<[%Y-%m-%d %a %H:%M]>
#+startup:  overview
#+filetags: :jaj:%^g

")
           :unnarrowed t)

          ;; Template for "projects" subdirectory
          ("p" "project" plain "%?"
           :target (file+head "projects/%<%Y%m%d%H%M%S>-${slug}.org"
"#+title:    ${title}
#+date:     %U
#+modified: %<[%Y-%m-%d %a %H:%M]>
#+startup:  overview
#+filetags: %^g

")
           :unnarrowed t)

          ;; Template for "work" subdirectory
          ("w" "work" plain "%?"
           :target (file+head "work/%<%Y%m%d%H%M%S>-${slug}.org"
"#+title:    ${title}
#+date:     %U
#+modified: %<[%Y-%m-%d %a %H:%M]>
#+startup:  overview
#+filetags: %^g

")
           :unnarrowed t)

          ;; Template for "abbys_lab" subdirectory
          ("a" "abbys_lab" plain "%?"
           :target (file+head "abbys_lab/%<%Y%m%d%H%M%S>-${slug}.org"
"#+title:    ${title}
#+date:     %U
#+modified: %<[%Y-%m-%d %a %H:%M]>
#+startup:  overview
#+filetags: %^g

")
           :unnarrowed t)

          ;; Template for "chuck" subdirectory
          ("c" "chuck" plain "%?"
           :target (file+head "chuck/%<%Y%m%d%H%M%S>-${slug}.org"
"#+title:    ${title}
#+date:     %U
#+modified: %<[%Y-%m-%d %a %H:%M]>
#+startup:  overview
#+filetags: %^g

")
           :unnarrowed t)

          ;; Template for "misc" subdirectory
          ("m" "misc" plain "%?"
           :target (file+head "misc/%<%Y%m%d%H%M%S>-${slug}.org"
"#+title:    ${title}
#+date:     %U
#+modified: %<[%Y-%m-%d %a %H:%M]>
#+startup:  overview
#+filetags: %^g

")
           :unnarrowed t))))


;;; consult-org-roam
;; https://github.com/jgru/consult-org-roam
;; TODO look into consult-notes:
;; # moved https://github.com/mclear-tools/consult-notes
;; https://codeberg.org/mclear-tools/consult-notes
(use-package consult-org-roam
  :ensure t
  :after org-roam
  ;:defer t
  :custom
  ;; Use `ripgrep' for searching with `consult-org-roam-search'
  (consult-org-roam-grep-func #'consult-ripgrep)
  ;; Configure a custom narrow key for `consult-buffer'
  (consult-org-roam-buffer-narrow-key ?r)
  ;; Display org-roam buffers right after non-org-roam buffers
  ;; in consult-buffer (and not down at the bottom)
  (consult-org-roam-buffer-after-buffers t)
  :config
  ;; Eventually suppress previewing for certain functions
  (consult-customize
   consult-org-roam-forward-links
   :preview-key "M-.")
  ;; Activate the minor mode
  (consult-org-roam-mode 1)
  :bind
  ;; Define some convenient keybindings as an addition
  ("C-c n e" . consult-org-roam-file-find)
  ("C-c n b" . consult-org-roam-backlinks)
  ("C-c n B" . consult-org-roam-backlinks-recursive)
  ("C-c n L" . consult-org-roam-forward-links)
  ("C-c n s" . consult-org-roam-search)) ;; was C-c n r - rg?

(provide 'tools-org-roam)
;;; tools-org-roam.el ends here
