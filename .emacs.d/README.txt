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
