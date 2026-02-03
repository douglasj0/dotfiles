;;; org-denote.el --- org and denote -*- lexical-binding: t; -*-

;;;; * --- Org ---
;; emacs git repos: https://savannah.gnu.org/git/?group=emacs
;; Installation: https://orgmode.org/org.html#Installation
;; Manual: https://orgmode.org/org.html
;; org-contrib repo, now separate from org
;; git clone https://git.sr.ht/~bzg/org-contrib
;;
;; ob-python-mode-mode repo, for separate python functionality
;; git clone https://gitlab.com/jackkamm/ob-python-mode-mode.git

(use-package org
  :diminish visual-line-mode
  :bind
  (:map global-map
   ("C-c o l" . org-store-link)
   ("C-c o a" . org-agenda)
   ("C-c o c" . org-capture)
   ("C-c o o" . org-info)
   ("C-c o b" . org-switchb))
  :hook (org-mode . visual-line-mode) ; enable word-wrap, treat lines as visual not logical
  :hook (org-mode . (lambda () (corfu-mode -1))) ; turns off corfu completions
  :hook (org-mode . (lambda () (electric-indent-local-mode -1))) ; turns off global electric-indent-mode in org buffers
  ;:hook (org-mode . (lambda () (diminish 'org-indent-mode -1))) ; unsure if needed
  ;:hook (org-mode . (lambda () (display-line-numbers-mode -1))) ; disable line numbers in org
  :custom
  (org-ellipsis "...")
  ;(org-startup-indented t) ; not a fan, disabling
  (org-hide-emphasis-markers t)
  :config
  (setq org-adapt-indentation nil)
  (setq org-startup-folded t) ; initial visibility set to closed
  (setq-default org-catch-invisible-edits 'smart)  ;; Prevent inadvertently edits an the invisible part of the buffer (default: smart)
  (setq org-directory "~/org") ; location of org files
  (add-to-list 'auto-mode-alist '("\\.txt$" . org-mode)) ; open txt files in org-mode

  ;;; Agenda - Agenda window setup (default: reorganize-frame)
  (setq org-agenda-window-setup 'current-window) ;; don't kill my window setup

  ;; Include emacs diary, not needed if using org-anniversary
  ;(setq org-agenda-include-diary t)

  ;; Custom agenda commands
  ;; http://members.optusnet.com.au/~charles57/GTD/mydotemacs.txt
  (setq org-agenda-custom-commands
  '(
  ("P" "Projects"
                ((tags "PROJECT")))

  ("H" "Office and Home Lists"
       ((agenda)
            (tags-todo "OFFICE")
            (tags-todo "HOME")
            (tags-todo "COMPUTER")
            (tags-todo "DVD")
            (tags-todo "READING")))

  ;("D" "Daily Action List"
  ;     ((agenda "" ((org-agenda-ndays 1)
  ;                     (org-agenda-sorting-strategy
  ;                        (quote ((agenda time-up priority-down tag-up))))
  ;                     (org-deadline-warning-days 0)
  ;                     ))))

  ("d" "Do today"
     ;; Show all todos and everything due today.
     ((agenda "" (
                  ;; Limits the agenda to a single day
                  (org-agenda-span 1)
                  ))
      (todo "TODO")))

  ("D" "Deadline due"
       ((tags-todo "+TODO=\"TODO\"+DEADLINE<=\"<today>\""
                   ((org-agenda-overriding-header "Deadline today")))
        (tags-todo "+TODO=\"TODO\"+DEADLINE=\"\""
                   ((org-agenda-overriding-header "No deadline")))))

  ))


  ;;; Capture
  ;; NOTE:  Fibonacci format: 0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100
  ;; Setup default target for notes and a global hotkey for new ones
  ;; NOTE:  Need org-mode version 6.3.6 or later for this to work
  ;; http://stackoverflow.com/questions/3622603/org-mode-setup-problem-when-trying-to-use-capture
  (setq org-default-notes-file (expand-file-name "~/org/notes.org"))

  ;; Capture templates - C-c c t
  ;; Based on Sacha Chua's org-capture-tempaltes
  ;; http://pages.sachachua.com/.emacs.d/Sacha.html
  (defvar dbj/org-basic-task-template "* TODO %^{Task}
SCHEDULED: %^t

:PROPERTIES:
:Story: %^{story|2|0|0.5|1|2|3|5|8|13}
:END:
:LOGBOOK:
- State \"TODO\"       from \"\"           %U
:END:
%?" "Basic task data")

  (defvar dbj/org-basic-jira-template "* TODO %^{Task}
SCHEDULED: %^t

:PROPERTIES:
:Story: %^{story|2|0|0.5|1|2|3|5|8|13}
:URL: %^{URL}
:END:
:LOGBOOK:
- State \"TODO\"       from \"\"           %U
:END:
%?" "Basic task data")

  (defvar dbj/org-basic-someday-template "* %^{Task}
:PROPERTIES:
:Story: %^{story|2|0|0.5|1|2|3|5|8|13}
:END:
:LOGBOOK:
- State \"TODO\"       from \"\"           %U
:END:
%?" "Basic task data")

  (setq org-capture-templates
        `(("t" "Tasks" entry
            (file "~/org/inbox.org"), dbj/org-basic-task-template)
            ;(file+headline "~/org/inbox.org" "Tasks"), dbj/org-basic-task-template)

          ("j" "Jira" entry
            (file "~/org/inbox.org"), dbj/org-basic-jira-template)

          ("s" "Someday task" entry
            (file "~/org/someday.org"), dbj/org-basic-someday-template)

          ("r" "Reference information" entry
            (file+headline "~/org/reference.org" "Inbox"))

          ("n" "Notes" entry
            (file+headline "~/org/notes.org"))

          ("o" "Journal" entry
            (file+olp+datetree "~/org/journal.org")
            "* %?\nEntered on %U\n  %i\n  %a")
  ))

  ;;; Other
  ;; When adding new heading below the current heading, the new heading is
  ;; Placed after the body instead of before it.  C-<RET>
  (setq org-insert-heading-respect-content t)

  ;; Set Todo keywords, same as:
  ;; Shortcut key:  C-c C-t
  ;; #+TODO: TODO(t) INPROGRESS(p) WAITING(w) | DONE(d) CANCELED(c)
  (setq org-todo-keywords
     '((sequence "TODO(t)" "NEXT(n)" "INPROGRESS(p)" "WAITING(w@/!)" "APPT(a)"
                 "|"
                 "DONE(d/!)" "CANCELED(c@/!)" "DEFERRED(f)")))

  ;; Set Tags, same as:
  ;; #+TAGS: home(h) work(w) @computer(c) @phone(p) errants(e)
  (setq org-tag-alist '(("@office" . ?o) ("@home" . ?h) ("computer" . ?c)
                        ("phone" . ?p) ("reading" . ?r)))

  ;; Prevent C-k from killing whole subtrees and losing work (default: nil)
  (setq org-special-ctrl-k t)

  ;; Fontify code buffers in org, instead of grey text
  ;; This is especially nice when you open an editing buffer with [Ctrl+c ']
  ;; to insert code into the #+begin_src ... #+end_src area.
  (setq org-src-fontify-natively t)

  ;; org-refile (C-c C-w) settings from:
  ;; http://www.mail-archive.com/emacs-orgmode@gnu.org/msg34415.html
  ;; http://doc.norang.ca/org-mode.html#RefileSetup
  ; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets '((org-agenda-files :maxlevel . 2)
                             (nil :maxlevel . 3)))

  ; Use full outline paths for refile targets - we file directly with IDO
  ;(setq org-refile-use-outline-path t)
  ;;(setq org-refile-use-outline-path 'file)

  ; Targets complete directly with IDO
  ;(setq org-outline-path-complete-in-steps nil)

  ; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))

  ;;; Strike-through finished todos
  ;; sachachua.com/blog/2012/12/emacs-strike-through-headlines-for-done-tasks-in-org/
  ;(setq org-fontify-done-headline t)
  ;(custom-set-faces
  ; '(org-done ((t (:foreground "PaleGreen"
  ;                 :weight normal
  ;                 :strike-through t))))
  ; '(org-headline-done
  ;            ((((class color) (min-colors 16) (background dark))
  ;               (:foreground "LightSalmon" :strike-through t)))))

  ;; Disable company-mode (word completions) in org using company conf var
  ;(setq company-global-modes '(not org-mode))

  ;; Override org-mode heading sizes (too larger in some themes)
  ;; https://stackoverflow.com/questions/21525436/orgmode-title-levels-height
  (custom-set-faces
    '(org-level-1 ((t (:inherit outline-1 :height 1.0))))
    '(org-level-2 ((t (:inherit outline-2 :height 1.0))))
    '(org-level-3 ((t (:inherit outline-3 :height 1.0))))
    '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
    '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
  )

  ;;; NOTE
  ;; org-insert-structure-template: C-c C-,
  ;; org-priority: C-c ,
  ;;; Enable other org-babel languages
  ;; https://orgmode.org/worg/org-contrib/babel/languages/index.html
  (with-eval-after-load 'org
    (org-babel-do-load-languages
     'org-babel-load-languages
     (seq-filter
      (lambda (pair)
        (locate-library (concat "ob-" (symbol-name (car pair)))))
      '((awk . t)       ;Awk
        (C . t)         ;C, C++, D
        (calc . t)      ; Emacs Calc
        ;(clojure . t)   ;Clojure
        ;(ditaa . f)     ;ditaa
        ;(dot . t)       ;Graphviz
        (emacs-lisp . t) ;Emacs Lisp, elisp
        (eshell . t)    ;eshell babel functions
        ;(forth . t)     ;Gforth
        ;(fortran . t)   ;Fortran
        ;(gnuplot . t)   ;Gnuplot, requires gnuplot
        ;(groovy . t)    ;
        ;(haskell . t)   ;Haskell
        ;(java . t)      ;Java
        ;(js . t)        ;Javascript, requires node
        ;(julia . t)     ;
        ;(latex . t)     ;LaTeX
        ;(lilypond . t)  ;Lilypond
        ;(lisp . t)      ;Lisp
        ;(lua . t)       ;Lua
        ;(makefile . t)  ;
        ;(matlab . t)    ;Matlab and Octave
        ;(maxima . t)    ;Maxima
        ;(ocaml . t)     ;Objective Caml
        ;(octave . t)    ;octave
        (org . t)       ;Org mode
        (perl . t)      ;Perl
        ;(plantuml . t)  ;Plantuml
        ;(processing . t) ;Processing.js
        (python . t)    ;Python
        ;(R . t)         ;R
        ;(ruby . t)      ;Ruby
        ;(sass . t)      ;Sass
        ;(scheme . t)    ;Scheme
        ;(screen . t)    ;GNU Screen
        (shell . t)     ;shell
        ;(sql . t)       ;SQL
        ;(sqlite . t)    ;SQLite
  )))))

;;;; * denote

;; denote: Simple notes with an efficient file-naming scheme
;; https://github.com/protesilaos/denote
;; https://protesilaos.com/codelog/2024-09-04-emacs-denote-3-1-0/
;;
;; Manual: https://protesilaos.com/emacs/denote
;;
;; Notes from system crafters stream
;; https://systemcrafters.net/live-streams/october-6-2023/
;;
;; Note, for silos create a .dir-local.el file
;; M-x add-dir-local-variable
;;   denote-directory
;;   denote-known-keywords

;(defun dw/denote-rename-buffer-with-prefixed-title (&optional buffer)
;  (denote-rename-buffer-with-title)
;  (rename-buffer (concat "[D] " (buffer-name (or buffer (current-buffer) title :unique)))))

;; Set denote-directory via system-name to keep home/work separate
;;(if (string-match "\\`lothlorien,*" (system-name))
;(if (string-match "\\`lothlorien.*\\|\\`Mac" (system-name))
;    (setq denote-directory "~/denote-home/")
;  (setq denote-directory "~/denote/")
;)

;; override org front-matter to add startup overview
(defvar denote-org-front-matter
  "#+title:      %s
#+date:       %s
#+filetags:   %s
#+identifier: %s
#+startup:    overview
\n")

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
;  (("C-c n d n" . denote)
;   ("C-c n d o" . denote-open-or-create)
;   ("C-c n d r" . denote-rename-file)
;   ("C-c n d i" . denote-link) ; "insert" mnemonic
;   ("C-c n d b" . denote-backlinks)
;   ("C-c n d d" . denote-dired)
;   ("C-c n d g" . denote-grep))
  (:map global-map
   ("C-c n n" . denote)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep)
   ("C-c n l" . denote-link)
   ("C-c n L" . denote-add-links)
   ("C-c n b" . denote-backlinks)
   ("C-c n q c" . denote-query-contents-link) ; create link that triggers a grep
   ("C-c n q f" . denote-query-filenames-link) ; create link that triggers a dired
   ("C-c n r" . denote-rename-file)
   ("C-c n R" . denote-rename-file-using-front-matter)
   ("C-c n o" . denote-open-or-create)
   ;; Key bindings specifically for Dired.
   :map dired-mode-map
   ("C-c C-d C-i" . denote-dired-link-marked-notes)
   ("C-c C-d C-r" . denote-dired-rename-files)
   ("C-c C-d C-k" . denote-dired-rename-marked-files-with-keywords)
   ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter))
  :custom
  (denote-sort-keywords t)
  (denote-link-description-function #'ews-denote-link-description-title-case)
  :config
  (setq denote-file-extension "org")
  (setq denote-directory (expand-file-name "~/denote/"))
  (setq denote-save-buffers nil)
  (setq denote-known-keywords '("emacs" "philosophy" "politics" "economics"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-prompts '(subdirectory title keywords))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-keywords-to-not-infer-regexp nil)
  (setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))

  ;; Pick dates, where relevant, with Org's advanced interface:
  (setq denote-date-prompt-use-org-read-date t)

  ;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
  (denote-rename-buffer-mode 1)
  ;(require 'denote-org-extras) ; moved to denote-org pkg

  (with-eval-after-load 'org-capture
    (add-to-list 'org-capture-templates
                 '("d" "New note (with Denote)" plain
                   (file denote-last-path)
                   #'denote-org-capture
                   :no-save t
                   :immediate-finish nil
                   :kill-buffer t
                   :jump-to-captured t)))
)

;; consult-denote
;; Integrate denote package with Daniel Mendler's consult
;; https://github.com/protesilaos/consult-denote
;; https://protesilaos.com/emacs/consult-denote
(use-package consult-denote
  :ensure t
  :bind
  (("C-c n c f" . consult-denote-find)
   ("C-c n c g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

;; Additionally, consult-notes could be useful
;; https://github.com/mclear-tools/consult-notes
