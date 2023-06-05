;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Startup speedups                                                          ;;
;; Stolen from: https://github.com/Bassmann/emacs-config/blob/master/init.el ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Speedup startup by reducing Garbage Collector
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)

;; Every file opened and loaded by Emacs will run through this list to check
;; for a proper handler for the file, but during startup, it won’t need any of
;; them.
(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; After Emacs startup has been completed, set `gc-cons-threshold' to
;; 16 MB and reset `gc-cons-percentage' to its original value.
;; Also reset `file-name-handler-alist'
(add-hook 'emacs-startup-hook
          (lambda ()
             (setq gc-cons-threshold (* 16 1024 1024)
                   gc-cons-percentage 0.1
                   file-name-handler-alist file-name-handler-alist-original)
             (makunbound 'file-name-handler-alist-original)))

;; For startup profiling
(setq esup-depth 0)
(setq create-lockfiles nil)
;; Put backup files neatly away
(let ((backup-dir "~/.local/share/emacs/backups")
      (auto-saves-dir "~/.cache/emacs/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too

(add-hook 'before-save-hook
	  'delete-trailing-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup packages                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Don't use package repositories when using emacs provided by nix
(if (cl-search "/nix/store" system-configuration-options)
    (progn
      ;; Force use of emacsPackages from nix
      (setq package-archives nil)
      (setq package-enable-at-startup nil))
  (progn
    (unless (package-installed-p 'use-package)
      (package-refresh-contents)
      (package-install 'use-package))
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
    (require 'use-package)
    (eval-when-compile (require 'use-package))
    (require 'use-package-ensure)
    (setq use-package-always-ensure t)))
(package-initialize)

(use-package mu4e
  :ensure nil
  :defer 5 ;; Defer 5 seconds (avoid slowdown for syncing at startup)
  :config
  (require 'mu4e-org)

  (setq mu4e-change-filenames-when-moving t
	mu4e-update-interval (* 10 60)
	mu4e-get-mail-command "mbsync -a"
	mu4e-maildir "~/mail")
  (mu4e t)) ;; Run in background for syncing



(setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme, Disable GUI Elements                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-screen t)

;; Remove toolbar, menubar, scrollbar, and window decorations
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq frame-title-format "%b")

(setq pixel-scroll-precision-interpolate-page t)
(pixel-scroll-precision-mode)

;; For setting frame parameters on emacsclient frames
(defun my-ui-setup (frame)
  (modify-all-frames-parameters
   '((right-divider-width . 20)
     (internal-border-width . 20)))
  (dolist (face '(window-divider
  		window-divider-first-pixel
  		window-divider-last-pixel
		border
  		vertical-border))
    (face-spec-reset-face face)
   ; (set-face-foreground face "#ffffff")
    (set-face-foreground face (face-attribute 'default :background))
    (set-face-background 'fringe (face-attribute 'default :background)))
    )
 ;; (set-frame-parameter frame 'undecorated t))
;;(add-hook 'after-make-frame-functions #'my-ui-setup)
;;(add-hook 'server-after-make-frame-functions #'my-ui-setup)


;; This probably doesn't do anything on wayland
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 90))

;; Setup fonts
(set-face-attribute 'default nil :family "Iosevka Fixed" :height 130)
(set-face-attribute 'fixed-pitch nil :family "Iosevka Fixed" :height 1.0)
(set-face-attribute 'variable-pitch nil :family "Iosevka" :height 1.0)
(set-face-attribute 'mode-line nil :family "Iosevka Fixed" :height 0.8)
(set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)
(setq-default line-spacing 0.1)

(require 'tramp)
(use-package visual-fill-column)
(use-package hide-mode-line
  :init
  (add-hook 'markdown-mode-hook #'hide-mode-line-mode)
  :bind ("<f8>" . hide-mode-line-mode))

;; Set wrap to 80 chars
(setq-default fill-column 90)
(setq-default visual-fill-column-center-text t)
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'visual-line-mode-hook #'visual-fill-column-mode)

;; Prevent GUI from zombieing out
(global-unset-key (kbd "C-z"))

;; Overwrite selection when typing
(delete-selection-mode 1)

;; For replacing " with “/” (only in text modes)
(setq-default electric-quote-replace-double t)

(use-package modus-themes
  :demand t
  :config
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs t
	modus-themes-intense-mouseovers t
	modus-themes-paren-match '(bold intense)
	modus-themes-region '(bg-only no-extend accented))
  (setq modus-themes-common-palette-overrides
	'((window-divider bg-main)
	  (bg-inactive bg-main)
;	  (window-divider-last-pixel bg-active)
	  (border bg-main)
	  (fringe unspecified)))
  (setq window-divider-default-bottom-width 20
	window-divider-default-right-width 20)
  (window-divider-mode)
  (load-theme 'modus-operandi :no-confirm)
  :bind ("<f5>" . modus-themes-toggle)
  :init
)

(defun modus-themes-reload ()
  "Reload the current modus theme."
  (interactive)
  (if-let* ((themes (modus-themes--toggle-theme-p))
            (one (car themes))
            (two (cadr themes)))
      (if (eq (car custom-enabled-themes) two)
          (modus-themes-load-theme two)
        (modus-themes-load-theme one))
    (modus-themes-load-theme (modus-themes--select-prompt))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful For Editing Text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package expand-region
  :init
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package move-text
  :config
  (move-text-default-bindings))

(use-package writegood-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown Mode                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package markdown-mode
  :init
  (setq-default markdown-hide-markup t)
  (add-hook 'markdown-mode-hook
          (lambda ()
            (setq-local modus-themes-common-palette-overrides
			'((fg-heading-0 fg-main)
			  (fg-heading-1 fg-main)
			  (fg-heading-2 fg-main)
			  (fg-heading-3 fg-main)
			  (fg-heading-4 fg-main)
			  (string fg-main)
			  (border bg-main)
			  (bg-inactive bg-main)
			  (fringe unspecified))
			modus-themes-headings
			'((0 . (variable-pitch regular 1.0))
			  (1 . (variable-pitch 1.6))
			  (2 . (variable-pitch 1.3))
			  (3 . (variable-pitch regular 1.0))
			  (t . (variable-pitch 1))))

	    (face-remap-add-relative 'default '(:family "Spectral"))
	    (face-remap-add-relative 'markdown-header-face-1 '(:family "Spectral"))
	    (face-remap-add-relative 'markdown-header-face-2 '(:family "Spectral"))
	    (face-remap-add-relative 'markdown-header-face-3 '(:family "Spectral SC"))

	    (local-set-key [return] (lambda ()
				      (interactive)
				      (insert "\n\n")))
	    (auto-fill-mode)

	    (modus-themes-reload)))



  (add-hook 'markdown-mode-hook #'electric-quote-local-mode)
  (add-hook 'markdown-mode-hook 'visual-line-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mixed pitch                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package mixed-pitch
  :hook
  ;; If you want it in all text modes:
  (text-mode . mixed-pitch-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Mode                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-bullets)
(use-package org-modern)
(use-package org-anki)
(use-package org
  :mode (("\\.org$" . org-mode))
  :config
  (setq org-hide-emphasis-markers t
	org-pretty-entities t
	org-ellipsis "…"
	org-tags-column 0
	org-catch-invisible-edits 'show-and-error
	org-special-ctrl-a/e t
	org-preview-latex-default-process 'dvisvgm
	org-preview-latex-image-directory "~/.cache/org-latex-images/")
  ;; (customize-set-variable 'org-blank-before-new-entry
  ;;                         '((heading . nil)
  ;;                           (plain-list-item . nil)))
  (setq org-cycle-separator-lines 1)
  (setq org-log-done 'time)

  (setq org-agenda-files '("~/Documents/Org/inbox.org"
                         "~/documents/org/projects.org"
                         "~/documents/org/tickler.org"))
  (defun transform-square-brackets-to-round-ones(string-to-transform)
    "Transforms [ into ( and ] into ), other chars left unchanged."
    (concat
     (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform))
  )
  (setq org-capture-templates '(
				("t" "Todo [inbox]" entry
				 (file+headline "~/documents/org/inbox.org" "Tasks")
				 "* TODO %i%?")
				("T" "Tickler" entry
                                 (file+headline "~/documents/org/tickler.org" "Tickler")
                                 "* TODO %^{Task} \n %^{Date}t \n %i" :time-prompt t)
			        ("s" "Songs" entry
			         (file+headline "~/documents/org/inbox.org" "Songs")
			         "* TODO Download %^{Song} by %^{Artist}%?")
				("p" "Protocol" entry
				 (file+headline  "~/documents/org/inbox.org" "Web")
				 "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
				("L" "Protocol Link" entry
				 (file+headline "~/documents/org/inbox.org" "Web")
				 "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]] \nCaptured On: %U")
				("b" "Add book to reading list" entry
				 (file+headline "~/documents/org/readinglist.org" "Reading List")
				 "* %^{Title} by %^{Author} \nAdded On: %u")
				("a" "Add to Activity Log")
				))
  (setq org-refile-targets '(("~/documents/org/projects.org" :maxlevel . 3)
                             ("~/documents/org/someday.org" :level . 1)
			     ("~/documents/org/readinglist.org" :maxlevel . 2)
                           ("~/documents/org/tickler.org" :maxlevel . 2)))
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)

  (org-defkey org-mode-map (kbd "C-M-<return>") (lambda ()
						(interactive)
						(org-insert-heading-respect-content)
						(org-demote-subtree)))

  (org-defkey org-mode-map (kbd "M-i") (lambda ()
				        (interactive)
				        (tab-to-tab-stop)))
  (org-defkey org-mode-map (kbd "C-c i") #'org-insert-link)
  (org-defkey org-mode-map (kbd "C-c I") #'org-insert-last-stored-link)
  (org-defkey org-mode-map (kbd "C-c s") #'org-anki-sync-entry)


  :init
  (require 'ox)
  (require 'ox-publish)
  (require 'org-protocol)

  (defun my-org-chooser ()
    (defun my-org-writing-setup ()
      ;; Redefine enter key to intent paragraphs excluding the first after a heading
      (local-set-key [return] (lambda ()
				(interactive)
				(backward-char) ;; Without this org-at-heading doesn't give correct result
				(let ((dont-indent (or
						    (org-in-block-p my-org-skipblocks)
						    (org-before-first-heading-p)
						    (org-at-heading-or-item-p))))
				(forward-char)
				(insert "\n")
				(unless dont-indent
				  (insert "\t")))))
      (setq-local org-modern-hide-stars t
		  org-modern-tag t
		  org-tags-column -100
		  modus-themes-common-palette-overrides
		  '((fg-heading-0 fg-dim)
		    (fg-heading-1 fg-main)
		    (fg-heading-2 fg-main)
		    (fg-heading-3 fg-main)
		    (prose-metadata-value fg-dim)
		    (prose-tag fg-dim)
		    ;; FIXME: find better way to inherit values
		    (border bg-main)
		    (bg-inactive bg-main)
		    (fringe unspecified))
		  modus-themes-headings
		  '((0 . (variable-pitch regular 1.0))
		    (1 . (variable-pitch 1.6))
		    (2 . (variable-pitch 1.3))
		    (3 . (variable-pitch regular 1.0))
		    (t . (variable-pitch 1.0))
		    ))
      (face-remap-add-relative 'default '(:family "Spectral"))
      (face-remap-add-relative 'org-level-1 '(:family "Spectral"))
      (face-remap-add-relative 'org-level-2 '(:family "Spectral"))
      (face-remap-add-relative 'org-level-3 '(:family "Spectral SC"))
      (face-remap-add-relative 'org-document-info '(:family "Iosevka"))
      (face-remap-add-relative 'org-document-title '(:family "Iosevka"))
      (face-remap-set-base 'org-modern-tag
			   '(:family "Iosevka"
				     :background "inherit"
				     :height 80
				     :weight light
				     :foreground "gray"))
      (electric-quote-local-mode)
      (modus-themes-reload))

    (defun my-org-default-setup ()
      (modus-themes-reload))

    (if (string-suffix-p ".draft.org" buffer-file-name)
	(my-org-writing-setup)
      (my-org-default-setup)))

  (add-hook 'window-selection-change-functions (lambda (x) (my-org-chooser)))
  (add-hook 'org-mode-hook #'org-modern-mode)
  (add-hook 'org-mode-hook #'my-org-chooser)
  (add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)))

  (setq my-org-skipblocks '(
			    "center"
			    "comment"
			    "example"
			    "export"
			    "quote"
			    "src"
			    "verse"))

  (defun my-paragraph-add-newlines-hook (backend)
    "Add a newline in front of lines that start with a tab (unless in block)."
    (goto-char (point-min))
    (while (re-search-forward "^\t" nil t)
      (backward-char)
      (unless (org-in-block-p my-org-skipblocks)
	(insert "\n"))
      (forward-char)))
  (add-hook 'org-export-before-processing-hook 'my-paragraph-add-newlines-hook)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package python-black
  :demand t
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rust                                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package rustic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Variables                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Specify location for Customize since nix config is R/O
(setq custom-file "~/.config/emacs/emacs-custom.el")
(when (file-exists-p custom-file)
  (load custom-file))
