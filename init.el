(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

(defvar my-packages '(better-defaults paredit idle-highlight-mode ido-ubiquitous
                                      drag-stuff git-gutter powerline find-file-in-project
                                      magit smex scpaste monokai-theme))

(package-initialize)
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(require 'git-gutter)
(require 'powerline)
(powerline-default-theme)

(load-theme 'monokai t)

;; shaief defaults:
(delete-selection-mode t)
(setq lazy-highlight-interval nil)

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;; Shell mode
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue3" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(add-hook 'shell-mode-hook 
     '(lambda () (toggle-truncate-lines 1)))
(setq comint-prompt-read-only t)
;; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Duplicate line or region with C-d:
;; from here:
;; http://stackoverflow.com/a/4717026/1659322
;; ==============================================================================================
(defun duplicate-line-or-region (&optional n)
  "Duplicate current line, or region if active.
With argument N, make N copies.
With negative N, comment out original line and use the absolute value."
  (interactive "*p")
  (let ((use-region (use-region-p)))
    (save-excursion
      (let ((text (if use-region        ;Get region if active, otherwise line
                      (buffer-substring (region-beginning) (region-end))
                    (prog1 (thing-at-point 'line)
                      (end-of-line)
                      (if (< 0 (forward-line 1)) ;Go to beginning of next line, or make a new one
                          (newline))))))
        (dotimes (i (abs (or n 1)))     ;Insert N times, or once if not specified
          (insert text))))
    (if use-region nil                  ;Only if we're working with a line (not a region)
      (let ((pos (- (point) (line-beginning-position)))) ;Save column
        (if (> 0 n)                             ;Comment out original with negative arg
            (comment-region (line-beginning-position) (line-end-position)))
        (forward-line 1)
        (forward-char pos)))))

(global-set-key (kbd "C-d") 'duplicate-line-or-region)
;; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; drag-stuff mode enabled:
(drag-stuff-global-mode t)
;; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(require 'git-gutter)

;; If you enable global minor mode
(global-git-gutter-mode t)

;; If you would like to use git-gutter.el and linum-mode
(git-gutter:linum-setup)

;; If you enable git-gutter-mode for some modes
(add-hook 'ruby-mode-hook 'git-gutter-mode)

(global-set-key (kbd "C-x C-g") 'git-gutter:toggle)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)

;; Jump to next/previous hunk
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)

;; Stage current hunk
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)

;; Revert current hunk
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

(custom-set-variables
 '(git-gutter:modified-sign "  ") ;; two space
 '(git-gutter:added-sign "++")    ;; multiple character is OK
 '(git-gutter:deleted-sign "--"))

(set-face-background 'git-gutter:modified "purple") ;; background color
(set-face-foreground 'git-gutter:added "green")
(set-face-foreground 'git-gutter:deleted "red")

;; first character should be a space
(custom-set-variables
 '(git-gutter:lighter " GG"))

(custom-set-variables
 '(git-gutter:separator-sign "|"))
(set-face-foreground 'git-gutter:separator "yellow")
;; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; heartbeat from here:
;; http://stackoverflow.com/a/13658817/1659322
;; ==============================================================================================
(require 'cl)
(require 'color)

(defvar heartbeat-fps 16)
(defvar heartbeat-period 5)

(defun heartbeat-range (from to cnt)
  (let ((step (/ (- to from) (float cnt))))
    (loop for i below cnt collect (+ from (* step i)))))

(defun heartbeat-cursor-colors ()
  (let ((cnt (* heartbeat-period heartbeat-fps)))
    (mapcar (lambda (r)
              (color-rgb-to-hex r 0 0))
            (nconc (heartbeat-range .2 1 (/ cnt 2))
                   (heartbeat-range 1 .2 (/ cnt 2))))))

(defvar heartbeat-cursor-timer nil)
(defvar heartbeat-cursor-old-color)

(define-minor-mode heartbeat-cursor-mode
  "Change cursor color with the heartbeat effect."
  nil "" nil
  :global t
  (when heartbeat-cursor-timer
    (cancel-timer heartbeat-cursor-timer)
    (setq heartbeat-cursor-timer nil)
    (set-face-background 'cursor heartbeat-cursor-old-color))
  (when heartbeat-cursor-mode
    (setq heartbeat-cursor-old-color (face-background 'cursor)
          heartbeat-cursor-timer
          (run-with-timer
           0 (/ 1 (float heartbeat-fps))
           (lexical-let ((colors (heartbeat-cursor-colors)) tail)
             (lambda ()
               (setq tail (or (cdr tail) colors))
               (set-face-background 'cursor (car tail))))))))
;; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


(provide 'init)
;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:

;; based on Gilad G. configuration:
(require 'newshell)
;; Load keys the last, in order to override bad key bindings
(require 'keys)

