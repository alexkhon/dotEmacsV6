;; Minimal Emacs v6.0
;; ===========================================================================

;; https://systemcrafters.net/emacs-from-scratch/the-best-default-settings/

;; ===========================================================================
;; Unclutter startup
;; ===========================================================================
(setq inhibit-startup-message t)

(menu-bar-mode   -1)
(tool-bar-mode   -1)
(scroll-bar-mode -1)

;; ===========================================================================
;; Package manager: straight.el
;; https://jeffkreeftmeijer.com/emacs-straight-use-package/
;; ===========================================================================
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; use-package
;; ---------------------------------------------------------------------------
(straight-use-package 'use-package)

;; straight
;; ---------------------------------------------------------------------------
(use-package straight
  ;; package manager, see code in early-init.el
  :custom
  (straight-use-package-by-default t) ;; Use straight.el by default
  )

;; ===========================================================================
;; Git related packages
;; ===========================================================================

;; magit
;; ---------------------------------------------------------------------------
(use-package magit
  ;; git interface: install as early as possible to avoid issues
  :ensure t
  :config
  ;; https://www.reddit.com/r/emacs/comments/179t67l/comment/k5b56i2/
  ;; this will open magit full screen and return to previous buffer when done
  (setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-topleft-v1)
  (setq magit-bury-buffer-function 'magit-restore-window-configuration)
  )

;; git-gutter
;; https://ianyepan.github.io/posts/emacs-git-gutter/
;; ---------------------------------------------------------------------------
(use-package git-gutter
	:hook (prog-mode . git-gutter-mode)
	:config
	(setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe)


(define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
(define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
(define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom)


;; ===========================================================================
;; Org related packages
;; ===========================================================================

;; org-mode
;; https://orgmode.org/
;; ---------------------------------------------------------------------------
(use-package org
  ;; use the latest version for org-roam
  :init
  (setq
   org-log-into-drawer t
   org-use-speed-commands t
   )

  
  :config
  ;;(add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook 'turn-on-auto-fill)

  ;; babel
  ;; https://orgmode.org/worg/org-contrib/babel/
  ;; https://eschulte.github.io/org-scraps/
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)
     ))
)

;; org-modern
;; ---------------------------------------------------------------------------
(use-package org-modern
  :config
  ;; Add frame borders and window dividers
  (modify-all-frames-parameters
   '((right-divider-width . 10)
     (internal-border-width . 10)))
  (dolist (face '(window-divider
                  window-divider-first-pixel
                  window-divider-last-pixel))
    (face-spec-reset-face face)
    (set-face-foreground face (face-attribute 'default :background)))
  (set-face-background 'fringe (face-attribute 'default :background))

  (setq
   ;; Edit settings
   org-auto-align-tags nil
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t
   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t
   org-agenda-tags-column 0
   org-ellipsis " …")

;;  (set-face-attribute 'org-modern-symbol nil :family "Iosevka Nerd Font Mono")
  (with-eval-after-load 'org (global-org-modern-mode)))


;; org-modern-indent
;;  src code blocks have an outline
;; ---------------------------------------------------------------------------
(use-package org-modern-indent
  :straight
  (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent")
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))


;; ===========================================================================
;; markdown packages
;; ===========================================================================

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))

;; ===========================================================================
;; dired
;; ===========================================================================
(org-babel-load-file (expand-file-name "~/Config/dotEmacsV5/babel/dired.org"))

;; ===========================================================================
;; ibuffer
;; ===========================================================================

(org-babel-load-file (expand-file-name "~/Config/dotEmacsV5/babel/ibuffer.org"))

;; ===========================================================================
;; minibuffer packages
;; ===========================================================================

;; https://alexforsale.github.io/posts/emacs-vertico/
;; https://prelude.emacsredux.com/en/stable/modules/vertico/ 

;; vertico
;; ---------------------------------------------------------------------------
(use-package vertico
  ;; single column mini-buffer
  :config
  (vertico-mode t))

;; orderless
;; ---------------------------------------------------------------------------
(use-package orderless
  ;; mini-buffer regex search tokens in any order
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; marginalia
;; ---------------------------------------------------------------------------
(use-package marginalia
  ;; adds notes to mini-buffer items
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))
  ;; The :init section is always executed.
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  :init
  (marginalia-mode))


;; ===========================================================================
;; Current line and line numbers
;; ===========================================================================

;; Set line numbers
;; ---------------------------------------------------------------------------
(setq display-line-numbers-width-start '5)
(setq display-line-numbers-type 'visual)
(setq display-line-numbers 'relative)

;; Always display line numbers
;; ---------------------------------------------------------------------------
(global-display-line-numbers-mode)

;; Make the current line number more apparent
;; ---------------------------------------------------------------------------
(set-face-attribute 'line-number-current-line nil :foreground "#ECEFF4" :background "black")

;; Highlight current line
;; ---------------------------------------------------------------------------
(global-hl-line-mode 1)



;; ===========================================================================
;; themes fonts and icons
;; ===========================================================================

;; fonts
;; --------------------------------------------------------------------------------
(set-face-attribute 'default nil
                    :family "Iosevka Term"
                    :height 140)

(set-face-attribute 'variable-pitch nil
                    :family "Iosevka Aile")

(set-face-attribute 'fixed-pitch nil
                    :font "0xProto Nerd Font Mono"
                    :height 120)


(set-face-attribute 'org-block nil
                    :font "0xProto Nerd Font Mono"
                    :height 110)

;; set non edit mode fonts
;; ...........................................................................
(add-hook 'dired-mode-hook
          (lambda ()
            (face-remap-add-relative 'default
				     :family "0xProto Nerd Font Mono"
				     :height 120)))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (face-remap-add-relative 'default
				     :family "0xProto Nerd Font Mono"
				     :height 120)))

(add-hook 'shell-mode-hook
          (lambda ()
            (setq-local buffer-face-mode-face
			'(:family "0xProto Nerd Font Mono" :height 120))
            (buffer-face-mode 1)
            ))


;; nerd-icons
;;   M-x nerd-icons-install-fonts
;;   https://github.com/rainstormstudio/nerd-icons.el
;; ---------------------------------------------------------------------------
(use-package nerd-icons
  ;; standardize the icons for doom modeline
  )


;; doom-themes
;;   https://github.com/doomemacs/themes
;; ---------------------------------------------------------------------------
(use-package doom-themes
  ;; recomended for doom-modeline
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-ir-black t))


;; ===========================================================================
;; modeline
;; ===========================================================================

;; pkg: doom-modeline
;;   https://github.com/seagle0128/doom-modeline
;; ---------------------------------------------------------------------------
(use-package doom-modeline
  ;; eyecandy modeline
  :ensure t
  :init
  (if (not (display-graphic-p))
      (setq doom-modeline-icon nil))
  :config
  (setq doom-modeline-project-detection 'auto)
  (setq doom-modeline-time-icon nil)
  (setq doom-modeline-time t)
  (doom-modeline-mode t)

  ;; setting nord colors in the modeline
  (set-face-attribute 'mode-line nil 
                      :background "#5E81AC" 
                      :box nil)

  (set-face-attribute 'mode-line-inactive nil 
                      :background "#2E3440" 
                      :box nil)
    )


;; ===========================================================================
;; sidebars
;; ============================================================================

;; replacement for treemacs
;;   dired subtree is required
;; ---------------------------------------------------------------------------
(use-package dired-sidebar
  :ensure t
  :after dired
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-should-follow-file t)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t)

  :hook
  ;; don't show the current and parent directory dots
  (dired-mode . dired-omit-mode)
  )

;; ibuffer-sidebar
;; --------------------------------------------------------------------------------
(use-package ibuffer-sidebar
  :straight
  (ibuffer-sidebar :type git :host github :repo "jojojames/ibuffer-sidebar")
  :ensure nil
  :commands (ibuffer-sidebar-toggle-sidebar)
  :config
  (require 'ibuffer-sidebar)
  (setq ibuffer-sidebar-use-custom-font t)
  (setq ibuffer-sidebar-face `(:family "0xProto Nerd Font Mono" :height 130)))


;; imenu-list
;;   this allows you to summarize the document
;;   imenu works well with code, not well with org-mode
;;   to auto-update, turn on imenu-list-minor-mode
;; ---------------------------------------------------------------------------
(use-package imenu-list
  :straight
  (imenu-list :type git :host github :repo "bmag/imenu-list")
  :config
  (setq imenu-list-position 'right)
  (setq imenu-list-size 35)
  ;; :hook
  ;; (prog-mode . imenu-list-minor-mode)
  )



;; function to toggle both
(defun +sidebar-toggle ()
  "Toggle both `dired-sidebar' and `ibuffer-sidebar'."
  (interactive)
  (dired-sidebar-toggle-sidebar)
  (ibuffer-sidebar-toggle-sidebar))


;; ===========================================================================
;; snippet packages
;; ===========================================================================

;; yasnippet
;; ---------------------------------------------------------------------------
(use-package yasnippet
  ;; snippets
  :config
  ;; Personal snippet directory
  ;; 1. Use full path, symlinks does not seem to work
  ;; 2. Point to the top level directory
  (setq yas-snippet-dirs
	'("~/Config/dotEmacsV5/snippets"))
  (yas-global-mode 1)
  :bind
  ;; https://emacs.stackexchange.com/questions/66352/how-to-change-key-binding-for-yas-expand
  (:map yas-minor-mode-map
        ("C-'". yas-expand)
        ([(tab)] . nil)
        ("TAB" . nil))
  )


;; ===========================================================================
;; windows
;; ===========================================================================

;; popper
;; ---------------------------------------------------------------------------
(use-package popper
  :ensure t ; or :straight t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
      '("^\\*eshell.*\\*$" eshell-mode ;eshell as a popup
        "^\\*shell.*\\*$"  shell-mode    ;shell as a popup
        "^\\*term.*\\*$"   term-mode     ;term as a popup
        "^\\*vterm.*\\*$"  vterm-mode    ;vterm as a popup
        "^\\*compilation.*\\*$" compilation-mode
      ))

  (popper-mode +1)
  (popper-echo-mode +1))


;; ace-windows
;; ---------------------------------------------------------------------------
(use-package ace-window
  ;; useful when there are multiple windows
  :ensure t
  :config
  (set-face-attribute
   'aw-leading-char-face nil
   :foreground "eceff4"
   :background "#bf616a"
   :weight 'bold
   :height 3.0)
  )

;; ===========================================================================
;; File handling
;; ===========================================================================
(use-package openwith
  :config
  (setq openwith-associations
	'(
	  ;;("\\.pdf\\'"  "evince -f" (file))
	  ("\\.pdf\\'"  "mupdf -A 8 -r 300" (file))
	  ;;("\\.pdf\\'"  "okular" (file))
	  ("\\.epub\\'" "mupdf -A 8 -r 300" (file))
	  ))
  (openwith-mode t))

;; auto refresh files
;; auto reload file if the file has been updated
;; https://stackoverflow.com/questions/1480572/how-to-have-emacs-auto-refresh-all-buffers-when-files-have-changed-on-disk
;; ---------------------------------------------------------------------------
(global-auto-revert-mode t)
(setq auto-revert-use-notify nil)

;; ===========================================================================
;; mark region
;; ===========================================================================

;; expand-region
;; ---------------------------------------------------------------------------
(use-package expand-region)

;; multiple cursors
;; be sure to press <RETURN> to end multiple-cursors
;; ---------------------------------------------------------------------------
(use-package multiple-cursors)

;; Set mark color to be more visible
;; ---------------------------------------------------------------------------
(setq akh-mark-color 'green)

(cond
      ((string= akh-mark-color 'red)    (set-face-attribute 'region nil :background "#bf616a" :foreground "#000000"))
      ((string= akh-mark-color 'orange) (set-face-attribute 'region nil :background "#d08770" :foreground "#000000"))
      ((string= akh-mark-color 'yellow) (set-face-attribute 'region nil :background "#ebcb8b" :foreground "#000000"))
      ((string= akh-mark-color 'green)  (set-face-attribute 'region nil :background "#a3be8c" :foreground "#000000"))
      ((string= akh-mark-color 'purple) (set-face-attribute 'region nil :background "#b48ead" :foreground "#000000"))
 )


;; Select set to over write
;; ---------------------------------------------------------------------------
(delete-selection-mode 1)



;; ===========================================================================
;; focused editing
;; ===========================================================================

;; olivetti-mode
;; ---------------------------------------------------------------------------
(use-package olivetti
  :straight
  (:host github :repo "rnkn/olivetti" :branch "master" :files ("*.el"))
  :config
  (setq olivetti-body-width 120)
  ;; todo
  ;; if any sidebars are open, close them first
  )


;; ===========================================================================
;; code editing
;; ===========================================================================






;; ===========================================================================
;; Current line and line numbers
;; ===========================================================================

;; Set line numbers
;; ---------------------------------------------------------------------------
(setq display-line-numbers-width-start '5)
(setq display-line-numbers-type 'visual)
(setq display-line-numbers 'relative)

;; Make the current line number more apparent
;; - background color matches the "doom-pine" theme
;; ---------------------------------------------------------------------------
(set-face-attribute 'line-number-current-line nil :foreground "#ECEFF4" :background "#0c1501")






;; ===========================================================================
;; Customize cursor
;; ===========================================================================

;; Set cursor to bar
;; ---------------------------------------------------------------------------
(setq-default cursor-type 'bar) 
(set-cursor-color "#ff0000")

;; shut off cursor in non-select windows
(setq-default cursor-in-non-selected-windows nil)


;; ===========================================================================
;; scrolling
;; ===========================================================================
;; smooth scrolling
;;   this is only apparent with the scroll wheel
;; ---------------------------------------------------------------------------
(pixel-scroll-precision-mode t)



;; ===========================================================================
;; Electric pairs mode
;; ===========================================================================

;; Set electric pair mode
;; highlighted region can be surrounded by parenthesis
;; ---------------------------------------------------------------------------
(electric-pair-mode 1)

;; http://xahlee.info/emacs/emacs/emacs_insert_brackets_by_pair.html
(setq electric-pair-pairs
      '(
        (?\" . ?\")
        (?\{ . ?\})
	    (?\[ . ?\])
	    (?\< . ?\>)
	    ))

;; ===========================================================================
;; which key mode
;; ===========================================================================
(setq-default which-key-idle-delay 0.1)
(which-key-mode 1)


;; ============================================
;; no text on scratch page
;; ============================================
(setq initial-scratch-message "")
(setq initial-major-mode 'org-mode)


;; Set keys for Apple keyboard, for emacs in OS X
;; http://ergoemacs.org/emacs/emacs_hyper_super_keys.html
;; ------------------------------------------
(setq mac-command-modifier  'super)    ; make cmd key do super
(setq mac-option-modifier   'meta)     ; make opt key do meta
(setq mac-control-modifier  'control)  ;
(setq mac-function-modifier 'hyper)    ; make Fn key do hyper


(global-set-key (kbd "s-q")         #'save-buffers-kill-emacs)
(global-set-key (kbd "s-s")         #'save-some-buffers)
(global-set-key (kbd "s-o")         #'find-file)
(global-set-key (kbd "s-t")         #'tab-new)
(global-set-key (kbd "s-w")         #'delete-frame)
(global-set-key (kbd "s-n")         #'make-frame-command)

(global-set-key (kbd "s-,") (lambda () (interactive)
                              (if user-init-file
                                  (find-file user-init-file)
                                (message "Session did not include a user-init-file")
                                )))

;; my C-x map
;; --------------------------------------------------------------------------------
(define-prefix-command 'meta-super-x-map)
(global-set-key (kbd "M-s-x") 'meta-super-x-map)

(define-key meta-super-x-map (kbd "s") #'+sidebar-toggle)
(define-key meta-super-x-map (kbd "w") #'ace-window)

;; regions
;; --------------------------------------------------------------------------------
(define-prefix-command 'meta-super-spc-map)
(global-set-key (kbd "M-s-SPC") 'meta-super-spc-map)

(define-key meta-super-spc-map (kbd "SPC") #'er/expand-region)
(define-key meta-super-spc-map (kbd "p") #'er/mark-inside-pairs)
(define-key meta-super-spc-map (kbd "P") #'er/mark-outside-pairs)
(define-key meta-super-spc-map (kbd "q") #'er/mark-inside-quotes)
(define-key meta-super-spc-map (kbd "Q") #'er/mark-outside-quotes)
(define-key meta-super-spc-map (kbd ";") #'er/mark-comment)
(define-key meta-super-spc-map (kbd "c") #'er/mark-org-code-block)

(define-key meta-super-spc-map (kbd "*") #'mc/mark-all-dwim)


;; ace window
;; --------------------------------------------------------------------------------
(global-set-key (kbd "M-s-w") #'ace-window)



;; windows separator
(setq window-divider-default-right-width 2)
(setq window-divider-default-bottom-width 2)
(window-divider-mode t)
