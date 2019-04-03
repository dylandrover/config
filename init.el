(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
	     '("org" . "https://orgmode.org/elpa/") t)

(require 'org)

;; Set theme and typeface size
(load-theme 'base16-default-dark t)
(set-face-attribute 'default nil :height 95)

;; Auto-complete 
(ac-config-default)

;; Standard Jedi.el setting
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(global-linum-mode 1)
(scroll-bar-mode -1)
(setq column-number-mode t)


;; Auto revert mode enabled (reload a modified file)
(global-auto-revert-mode t)

;; Customizing and activating the 80 character line
(require 'fill-column-indicator)
(setq fci-rule-width 1)
(setq fci-rule-color "#01a252")
(setq fci-rule-column 80)

;; Fixing the autocomplete stuff for fill-column-indicator
(defun sanityinc/fci-enabled-p () (symbol-value 'fci-mode))
(defvar sanityinc/fci-mode-suppressed nil)
(make-variable-buffer-local 'sanityinc/fci-mode-suppressed)

(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible"
  (let ((fci-enabled (sanityinc/fci-enabled-p)))
    (when fci-enabled
      (setq sanityinc/fci-mode-suppressed fci-enabled)
      (turn-off-fci-mode))))

(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed"
  (when (and sanityinc/fci-mode-suppressed
	     (null popup-instances))
    (setq sanityinc/fci-mode-suppressed nil)
    (turn-on-fci-mode)))

;; Set up Move up/down by 10 lines
(global-set-key (kbd "M-n")
    (lambda () (interactive) (next-line 10)))
(global-set-key (kbd "M-p")
    (lambda () (interactive) (next-line -10)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(custom-enabled-themes (quote (base16-3024)))
 '(custom-safe-themes
   (quote
    ("b3bcf1b12ef2a7606c7697d71b934ca0bdd495d52f901e73ce008c4c9825a3aa" default)))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (org-ac org org-edna windata ## tree-mode virtualenvwrapper virtualenv neotree jedi-direx fill-column-indicator company-jedi base16-theme auto-virtualenv))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Modifications to kill and yank
(defun yank-pop-forwards (arg)
      (interactive "p")
      (yank-pop (- arg)))

(global-set-key "\M-Y" 'yank-pop-forwards) ; M-Y (Meta-Shift-Y)


;; Prevents long backspace or delete from copying information to the kill-ring
(defun my-delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (delete-region
   (point)
   (progn
     (forward-word arg)
     (point))))

(defun my-backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (my-delete-word (- arg)))

(global-set-key (kbd "M-d") 'my-delete-word)
(global-set-key (kbd "<M-backspace>") 'my-backward-delete-word)
(global-set-key (kbd "<C-backspace>") 'my-backward-delete-word)




(put 'scroll-left 'disabled nil)
