
;;; package --- Summary
;;
;;; Commentary:
;;;
;;; Code:

(require 'package)

;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(setq package-archives '(
                         ("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                         ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
                         ))


(package-initialize)

;; 查看大型项目采用tags
;; 比如linux、glibc使用时先用make TAGS 生成tags文件，然后再使用emacs查看代码
;(setq tags-file-name "path/TAGS"); 这里的path/TAGS要换成自己的对应的tags文件路径
; 如果有多个tags文件，采用如下方式，少使用的尽量放在后面
;(setq tags-table-list '("path1/TAGS" "path2/TAGS" "path3/TAGS"))
;或者再emacs运行M-x visit-tags-table，再输入TAGS文件的位置即可加载。
; 采用tag 浏览代码的快捷键
;M-. 查找光标所指向的函数的定义
;C-M-. 输入函数名，查找其定义
;M-*   回退
;C-u M-. 查找标签的下一个定义

(load-theme 'manoj-dark t)
;;
;; set autosave and backup directory
;;
(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix emacs-tmp-dir)

;;
;; custome variable path
;;
(setq custom-file "~/.emacs.d/custom-variables.el")
(when (file-exists-p custom-file)
    (load custom-file))


;;
;; use use-package
;;
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(use-package diminish :ensure t)
(use-package bind-key :ensure t)

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;;
;; basic setup
;;
(menu-bar-mode -1)

(show-paren-mode t)
(electric-pair-mode t)

(setq electric-pair-pairs '(
			    (?\' . ?\')
			    ))

(setq-default indent-tabs-mode nil)

(winner-mode t)


;;
;; hideshow
;;
(add-hook 'prog-mode-hook #'hs-minor-mode)


;;
;; multiple cursors
;;
(use-package multiple-cursors
  :ensure t
  :bind (
         ("M-3" . mc/mark-next-like-this)
         ("M-4" . mc/mark-previous-like-this)
         :map ctl-x-map
         ("\C-m" . mc/mark-all-dwim)
         ("<return>" . mule-keymap)
         ))

;;
;; ivy mode
;;
(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :config
  (ivy-mode 1)
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 10)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
        `((t . ivy--regex-ignore-order)))
  )

;;
;; counsel
;;
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("\C-x \C-f" . counsel-find-file)))

;;
;; swiper
;;
(use-package swiper
  :ensure t
  :bind (("\C-s" . swiper))
  )

;;
;; yasnippet
;;
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  (use-package yasnippet-snippets :ensure t)
  )

;;
;; company
;;
(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (setq company-backends
        '((company-files
           company-yasnippet
           company-keywords
           company-capf
           )
          (company-abbrev company-dabbrev))))

(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (add-to-list  (make-local-variable 'company-backends)
                                                '(company-elisp))))

;;
;; change C-n C-p
;;
(with-eval-after-load 'company
  (define-key company-active-map (kbd "\C-n") #'company-select-next)
  (define-key company-active-map (kbd "\C-p") #'company-select-previous)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil))



;;
;; change company complete common
;;
;; With this code, yasnippet will expand the snippet if company didn't complete the word
;; replace company-complete-common with company-complete if you're using it
;;

(advice-add 'company-complete-common :before (lambda () (setq my-company-point (point))))
(advice-add 'company-complete-common :after (lambda () (when (equal my-company-point (point))
                                                         (yas-expand))))

;;
;; flycheck
;;

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode t)
  )

;;
;; magit
;;
(use-package magit
  :ensure t
  :bind (("\C-x g" . magit-status))
  )


;;
;; projectile
;;
(use-package projectile
  :ensure t
  :bind-keymap
  ("\C-c p" . projectile-command-map)
  :config
  (projectile-mode t)
  (setq projectile-completion-system 'ivy)
  (use-package counsel-projectile
    :ensure t)
  )


(use-package ag
  :ensure t)


;;
;; auto insert
;;
(defun my/autoinsert-yas-expand()
  "replace text in yasnippet template"
  (yas-expand-snippet (buffer-string) (point-min) (point-max)))


(use-package autoinsert
  :ensure t
  :config
  (setq auto-insert-query nil)
  (setq auto-insert-directory (locate-user-emacs-file "templates"))
  (add-hook 'find-file-hook 'auto-insert)
  (auto-insert-mode t)
  (define-auto-insert "\\.org$" ["default-org.org" my/autoinsert-yas-expand])
  (define-auto-insert "\\.js$" ["default-js.js" my/autoinsert-yas-expand])
  (define-auto-insert "\\.ts$" ["default-ts.ts" my/autoinsert-yas-expand])
  (define-auto-insert "\\.html?$" ["default-html.html" my/autoinsert-yas-expand])
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                c/c++                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "~/.emacs.d/custom/c.el")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                python               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/python.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 web                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/web.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                  go                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/go.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 ruby                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/ruby.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 org                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/org.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/csharp.el")

;; c++11
(modern-c++-font-lock-global-mode t)
(use-package modern-cpp-font-lock
  :ensure t)

;; clang-format can be triggered using C-c C-f
;; Create clang-format file using google style
;; clang-format -style=google -dump-config > .clang-format
(require 'clang-format)
(global-set-key (kbd "C-c C-f") 'clang-format-region)
(global-set-key (kbd "C-c u") 'clang-format-buffer)
(setq clang-format-style-option "google")

;; vim emulator
;
(add-to-list 'load-path "~/.emacs.d/elpa/evil-20200530.659/")
(require 'evil)
(evil-mode 1)
;(define-key evil-motion-state-map (kbd "SPC h") 'evil-window-left)
;(define-key evil-motion-state-map (kbd "SPC j") 'evil-window-down)
;(define-key evil-motion-state-map (kbd "SPC k") 'evil-window-up)
;(define-key evil-motion-state-map (kbd "SPC l") 'evil-window-right)
;evil 插入状态光标为竖线
(setq evil-insert-state-cursor 'bar)

;;3.快捷键
;only in NeoTree:
;n：next line 
;p：previous line
;SPC or RET or TAB: Open current item if it is a file. Fold/Unfold current item if
; it is a directory.
;U：Go up a directory
;g：Refresh
;A：Maximize/Minimize the NeoTree Window
;H：Toggle display hidden files
;O：Recursively open a directory
;C-c C-n：Create a file or create a directory if filename ends with a ‘/’
;C-c C-d：Delete a file or a directory.
;C-c C-r：Rename a file or a directory.
;C-c C-c：Change the root directory.
;C-c C-p：Copy a file or a directory.
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;ccls
;用以下C/C++ mode hook在项目根目录有compile_commands.json时自动启用`lsp-cquery-enable
(defun my//enable-cquery-if-compile-commands-json ()
  (when-let
      ((_ (not (and (boundp 'lsp-mode) lsp-mode)))
       (_ (cl-notany (lambda (x) (string-match-p x buffer-file-name)) my-cquery-blacklist))
       (root (projectile-project-root))
       (_ (or (file-exists-p (concat root "compile_commands.json"))
              (file-exists-p (concat root ".cquery")))))
    (lsp-cquery-enable)
    (lsp-enable-imenu)))
;;
;;查找定义、引用的jump list和正常jump list(Evil中C-o C-i)分离。因为查找定义/引用后会进行一些局部跳转，喜欢有快捷键回到定义/引用跳转前的位置。 Emacs Lisp dynamic scoping使得我们可以很容易复用evil-jumps做一个用于xref的jump list，同时还支持双向移动，比xref.el中的xref-pop-marker-stack更方便。
(defmacro my-xref//with-evil-jumps (&rest body)
  "Make `evil-jumps.el' commands work on `my-xref--jumps'."
  (declare (indent 1))
  `(let ((evil--jumps-window-jumps ,my-xref--jumps))
     ,@body))
(with-eval-after-load 'evil-jumps
  (evil-define-motion my-xref/evil-jump-backward (count)
    (my-xref//with-evil-jumps
        (evil--jump-backward count)
      (run-hooks 'xref-after-return-hook)))
  (evil-define-motion my-xref/evil-jump-forward (count)
    (my-xref//with-evil-jumps
        (evil--jump-forward count)
      (run-hooks 'xref-after-return-hook))))

(global-linum-mode 'linum-mode)
;;;显示标题栏 %f 缓冲区完整路径 %p 页面百分数 %l 行号
(setq frame-title-format "%f")

;;设置TAB宽度为4
(setq default-tab-width 4) 
(provide 'init)


;;使用的时agtags
;;M-. 查找光标所指向的函数的定义
;;C-M-. 输入函数名，查找其定义
;;M-*   回退
;;C-u M-. 查找标签的下一个定义
;;; init.el ends here
