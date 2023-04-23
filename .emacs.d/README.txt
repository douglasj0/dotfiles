Setup emacs python virtualenv

;; install black, tox, flake8, pyflakes, isort   #pyright
;; $ pip3 install --upgrade black tox isort flake8
;;
;;   black - reports code errors and also fixes them
;;   tox - automate standard testing in python
;;   flake8 - linter, python version specific
;;     "wrapper which verifies pep8, pyflakes and circular complexity"
;;   pyflakes - linter, faster then pylint (needed by flake8?)
;;   isort - sort imports alphabetically and by type
;;   pyright - another language server (like pylsp)
;;
;; Install langauge server pylsp pylint
(set-eglot-client! 'python-mode '("pylsp"))

Installing python lsp in pyenv-virtualenv:
# if issues, use: python3 -m pip install
#+begin_src shell
$ pyenv versions
$ pyenv install --list | grep 3.10
$ pyenv install 3.10.11
$ pyenv global 3.10.11
$ pyenv virtualenv 3.10.11 emacs-py
$ pyenv activate emacs-py
$ python --version
Python 3.10.11
$ pip3 install --upgrade pip
# install black, tox, flake8, pyflakes, isort   #pyright
$ pip3 install --upgrade black tox isort flake8 # error checkers
# Install langauge server pylsp pylint
#$ pip3 install 'python-language-server[all]'  # pyls (unmaintained)
$ pip3 install 'python-lsp-server[all]' pylint # pylsp (maintained fork)
$ pylsp --version
pylsp v1.7.2
$ pip3 list
#+end_src


-=-=-=-

RMail is loaded, customize to remove org modules
https://www.reddit.com/r/emacs/comments/tkp4v5/weekly_tips_tricks_c_thread/

Phil-Hudson
1 yr. ago
You can use the Customize interface via M-x customize-option RET org-modules RET to pick and choose which modules you want enabled.

oantolin 1 yr. ago C-x * q 100! RET

In version 9.5.2 ol-rmail does not have (require 'rmail), so ol-rmail was not the culprit in my case. It turned out that ol-gnus does (require 'gnus-util), and gnus-util in turn does (require 'rmail). Since I definitely need ol-gnus I gave up on not loading rmail. :)

By the way, of the methods of tracking down how a library got loaded in your link, I think the easiest is looking at load-history it tells you everything! It's probably best to give it its own buffer by doing M-x pp-eval-expression RET load-history.
