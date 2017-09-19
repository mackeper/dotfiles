;;; Package --- Summary
;;; Commentary:
;;; Code:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(custom-safe-themes
   (quote
    ("ac256b4d2adab96f5fa48bd5ead6840a011fd127887e6ba60c6328cf2c97bad3" "808dcce7c5285915214f85090519493a42db6f34281bca84f6787958344a31ea" "a1289424bbc0e9f9877aa2c9a03c7dfd2835ea51d8781a0bf9e2415101f70a7e" "08b8807d23c290c840bbb14614a83878529359eaba1805618b3be7d61b0b0a32" default)))
 '(fci-rule-color "#3E4451")
 '(inhibit-startup-screen t)
 '(jde-jdk-registry (quote (("1.8.0_66" . "/usr/lib/jvm/jdk1.8.0_66"))))
 '(jdee-server-dir "~/.emacs.d/elpa/jdee-20161130.1311/jdee-server/target/")
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (zone-rainbow fireplace function-args autopair flycheck yasnippet auto-complete-c-headers auto-complete org evil)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(set-face-attribute 'default nil :height 120)

;; Remove scrollbar
(toggle-scroll-bar -1)

;; Show matching paren
(show-paren-mode 1)

(set-face-attribute 'default nil
                    :family "monospace"
                    :height 120
                    :weight 'normal
                    :width 'normal)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/elpa/")
(add-to-list 'load-path "~/.emacs.d/packages/")
(require 'goto-chg)

;; Looks (themes, colors and transparency)
(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/atom-one-dark-theme/")
(load-theme 'atom-one-dark t)

;; Uses spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; no beep sound
(setq ring-bell-function 'ignore)

;;Put c++-mode as default for *.h files (improves parsing):
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Move between buffers Shift
(windmove-default-keybindings)

;; Global settings
(global-linum-mode t) ; line number
(setq column-number-mode t) ; column position
(global-set-key (kbd "C-h C-s") 'ff-find-other-file) ; switch between .c .h
(global-set-key (kbd "M-<up>") 'enlarge-window)
(global-set-key (kbd "M-<down>") 'shrink-window)

;; Global key bindings
(global-set-key (kbd "C-c C-l") 'goto-line)

;;--------------------------------------------
;; Org-mode
;;--------------------------------------------
;; The following lines are always needed. Choose your own keys.
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

;;--------------------------------------------
;; Auto-complete
;;--------------------------------------------
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)

;;--------------------------------------------
;; auto-complete-c-headers
;;--------------------------------------------
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/usr/include")
  (add-to-list 'achead:include-directories '"/usr/include/c++/7.1.1"))
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)
;; gcc -xc++ -E -v - , shows where header files are.


;;--------------------------------------------
;; Auto-insert
;;--------------------------------------------
(auto-insert-mode)

(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.java\\'" . "Java skeleton")
     '("potatis" \n "/**" \n
       (file-name-nondirectory (buffer-file-name)) \n \n
       "@author " \n
       "@version " \n
     "*/"  \n \n
     "public class " (car (split-string (file-name-nondirectory (buffer-file-name)) "\\."))
     " {" \n \n
     "" \n \n
     "}")))

(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.cpp\\'" . "C++ skeleton")
     '("potatis" \n "/**" \n
       (file-name-nondirectory (buffer-file-name)) \n \n
       "@author " \n
       "@version " \n
     "*/"  \n \n
     )))

;;--------------------------------------------
;; yasnippet
;--------------------------------------------
(require 'yasnippet)
(yas-global-mode 1)

;;--------------------------------------------
;; flycheck
;;--------------------------------------------
(add-hook 'after-init-hook #'global-flycheck-mode)
(defun my-flycheck-c-setup ()
  (setq flycheck-gcc-language-standard "c99"))
(add-hook 'c-mode-hook #'my-flycheck-c-setup)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")));;c++11

;;--------------------------------------------
;; CC mode
;;--------------------------------------------
(setq-default c-basic-offset 4)

;;--------------------------------------------
;; autopair
;;--------------------------------------------
(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers

;;--------------------------------------------
;; function-args
;;--------------------------------------------
;; M-i show function, M-n/M-h cycle, M-u dismiss.
;(add-to-list 'load-path "~/.emacs.d/function-args")
;(require 'function-args)
;(fa-config-default)
;;Enable case-insensitive searching:
;(set-default 'semantic-case-fold t)

;;--------------------------------------------
;; helm
;;--------------------------------------------
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)

;;--------------------------------------------
;; iedit C-;
;;--------------------------------------------
(define-key global-map (kbd "C-;") 'iedit-mode)

;;--------------------------------------------
;; CEDET
;;--------------------------------------------
(semantic-mode 1)
(defun my:add-semantic-to-autocomplete ()
  (add-to-list 'ac-sources 'ac-source-semantic))
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
(global-semantic-idle-scheduler-mode 1)

;;--------------------------------------------
;; Evil
;;--------------------------------------------
(require 'evil)
(evil-mode 1)

;;(global-evil-leader-mode)
;;(evil-leader/set-leader ",")

;;; .emacs ends here
