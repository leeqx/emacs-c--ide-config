;;; agtags-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "agtags" "agtags.el" (0 0 0 0))
;;; Generated autoloads from agtags.el

(autoload 'agtags-grep-mode "agtags" "\
A mode for showing outputs from gnu global.

\(fn)" t nil)

(autoload 'agtags-path-mode "agtags" "\
A mode for showing files from gnu global.

\(fn)" nil nil)

(autoload 'agtags-mode "agtags" "\
Toggle Agtags mode on or off.
With a prefix argument ARG, enable Agtags mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil, and toggle it if ARG is `toggle'.
\\{agtags-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'agtags-bind-keys "agtags" "\
Set global key bindings for agtags.

\(fn)" nil nil)

(autoload 'agtags-update-root "agtags" "\
Set ROOT directory of the project for agtags.

\(fn ROOT)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "agtags" '("agtags-")))

;;;***

;;;### (autoloads nil "agtags-xref" "agtags-xref.el" (0 0 0 0))
;;; Generated autoloads from agtags-xref.el

(autoload 'agtags-xref-backend "agtags-xref" "\
The agtags backend for Xref.

\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "agtags-xref" '("agtags-xref--")))

;;;***

;;;### (autoloads nil nil ("agtags-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; agtags-autoloads.el ends here
