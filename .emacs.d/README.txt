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
#+begin_src shell
$ pyenv versions
$ pyenv install --list | grep 3.11
$ pyenv install 3.11.3
$ pyenv global 3.11.3
$ pyenv virtualenv 3.11.3 emacs-py
$ pyenv activate emacs-py
$ python --version
Python 3.11.3
$ python3 -m pip install --upgrade pip
# install black, tox, flake8, pyflakes, isort   #pyright
$ python3 -m pip install --upgrade black tox isort flake8 # error checkers
# Install langauge server pylsp pylint
#$ pip install 'python-language-server[all]'  # pyls (unmaintained)
$ python3 -m pip install 'python-lsp-server[all]' pylint # pylsp (maintained fork)
$ pylsp --version
pylsp v1.7.2
$ pip3 list
#+end_src
