(require 'package)
(package-initialize)
(setq package-enable-at-startup nil)

(add-to-list 'load-path (concat user-emacs-directory "config"))
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package powerline-evil
  :ensure powerline-evil
  :demand powerline-evil
  :init (powerline-evil-vim-color-theme))

(defun run-python-tests ()
  "Run python tests using nosetests"
  (interactive)
  (save-some-buffers 'no-confirm)
  (compile "nosetests"))

(use-package evil-leader
  :commands (evil-leader-mode)
  :ensure evil-leader
  :demand evil-leader
  :init (global-evil-leader-mode)
  :config
  (progn
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key "b" 'ibuffer)

    (evil-leader/set-key "<SPC>" 'other-window)
    (evil-leader/set-key "p" 'helm-projectile)
    (evil-leader/set-key "sp" 'helm-projectile-switch-project)
    (evil-leader/set-key "f" 'toggle-frame-fullscreen)
    (evil-leader/set-key "ra" 'run-python-tests)
    )
  )

(use-package magit
  :ensure t
  :config
  (progn
    (setq magit-last-seen-setup-instructions "1.4.0")
    )
  )

(use-package org
  :ensure t
  )
(use-package evil-org
  :ensure t
  )

;; Spaces, not tabs
(setq-default indent-tabs-mode nil)

;; Remove GUI stuff
(tool-bar-mode -1)
;(scroll-bar-mode -1)
(menu-bar-mode -1)

;;dark colortheme
(load-theme 'monokai t)

;; trying to get unicode to work. not very successful...
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Python mode
(use-package python-mode
  :ensure t
  )

; Fuzzy searching like CtrlP/Unite
(use-package helm
  :ensure t)
(use-package helm-projectile
  :ensure t
  :config
  (progn
    (projectile-global-mode)
    (add-to-list 'projectile-globally-ignored-directories "venv" "node_modules")
    )
  )

; Somewhat better formatting when showing line numbers, but still...
(setq linum-format "%d ")

; hide startup messages
(setq inhibit-splash-screen t
      inhibit-startup-echo-area-message t
      inhibit-startup-message t)

;; turn off autosave and backup files
(setq backup-inhibited t)
(setq auto-save-default nil)

;; Show matching parens
(show-paren-mode 1)

(defun my-python-mode-hook ()
  (linum-mode 1)
  (py-electric-backspace 1)
  (normal-erase-is-backspace-mode 1))
(add-hook 'python-mode-hook 'my-python-mode-hook)

(defun my-js-mode-hook ()
  (linum-mode 1))
(add-hook 'js-mode-hook 'my-js-mode-hook)

(defun my-html-mode-hook ()
  (linum-mode 1))
(add-hook 'html-mode-hook 'my-html-mode-hook)

(use-package js2-mode
  :config
  (progn
    (add-hook 'js-mode-hook 'js2-minor-mode)
    (add-hook 'js2-mode-hook 'ac-js2-mode)
    (setq js2-highlight-level 3)
    )
  )

(use-package auto-complete-config
  :config
  (progn
    (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
    (ac-config-default)
    )
  )

(use-package evil
  :ensure evil
  :demand evil
  :init (evil-mode 1)
  )

(eval-after-load 'dired
  '(progn
     (evil-set-initial-state 'dired-mode 'normal)
	(evil-define-key 'normal dired-mode-map "h" 'dired-up-directory)
	(evil-define-key 'normal dired-mode-map "l" 'dired-find-alternate-file)
	(evil-define-key 'normal dired-mode-map "o" 'dired-sort-toggle-or-edit)
	(evil-define-key 'normal dired-mode-map "v" 'dired-toggle-marks)
	(evil-define-key 'normal dired-mode-map "m" 'dired-mark)
	(evil-define-key 'normal dired-mode-map "u" 'dired-unmark)
	(evil-define-key 'normal dired-mode-map "U" 'dired-unmark-all-marks)
	(evil-define-key 'normal dired-mode-map "c" 'dired-create-directory)
	(evil-define-key 'normal dired-mode-map "n" 'evil-search-next)
	(evil-define-key 'normal dired-mode-map "N" 'evil-search-previous)
	(evil-define-key 'normal dired-mode-map "q" 'kill-this-buffer)
     )
  )

(use-package key-chord
 :ensure key-chord
  :demand key-chord
  :init (key-chord-mode 1)
  :config
  (progn
    (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
    )
  )
