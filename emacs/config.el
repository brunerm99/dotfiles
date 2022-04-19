(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(setq user-full-name "Marshall Bruner"
      user-mail-address "brunerm99@gmail.com")

;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)

(after! org
        (setq org-directory "~/.org-roam/")
        (setq org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "IP(i)" "IDEA(a)"
                                            "MAYBE(m)" "|" "DONE(d)" "CANCELLED(c)" )))
        (setq org-log-done 'time)

        (require 'ob-ipython)
        (org-babel-do-load-languages 'org-babel-load-languages
                                     '(
                                       (python . t)
                                       (ipython . t)
                                       (sh . t)))
        (setq ob-async-no-async-languages-alist '("ipython"))
  )

;; (make-directory "~/.org-roam")
(add-to-list 'load-path "~/.gitclones/org-roam")
(require 'org-roam)
(setq org-roam-directory (file-truename "~/.org-roam"))

;; Allow symbolic links
(setq find-file-visit-truename t)

;; Autosync
(org-roam-db-autosync-mode)

(setq org-roam-completion-everywhere t)

;; Allows multiple cursor editing with evil bindings
(require 'evil-multiedit)
(evil-multiedit-default-keybinds)

;; Create function to insert ipython source block
(defun insert-ipython-src-block ()
  (interactive)
  (insert "#+BEGIN_SRC ipython :session ipyenv :results raw drawer\n\n#+END_SRC"))

;; Leader mappings
(map! :leader
      (:prefix ("m L" . "blocks")
       :desc "Insert ipython code block with session" "i" #'insert-ipython-src-block
       )
      (:desc "Find org-roam node" "f o" #'org-roam-node-find)
      (:desc "Insert org-roam node" "f O" #'org-roam-node-insert))
