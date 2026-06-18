;; https://jeffkreeftmeijer.com/emacs-straight-use-package/
;; The ~/.emacs.d/early-init.el file disables package.el to disable
;; its auto-loading, causing all packages to be loaded through
;; straight.el in the init file:

;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)
