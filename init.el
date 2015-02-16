(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

(defvar my-packages '(better-defaults paredit idle-highlight-mode ido-ubiquitous
                                      find-file-in-project magit smex scpaste monokai-theme))

(package-initialize)
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


(load-theme 'monokai t)

(provide 'init)
;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:

;; based on Gilad G. configuration:
(require 'newshell)
;; Load keys the last, in order to override bad key bindings
(require 'keys)

