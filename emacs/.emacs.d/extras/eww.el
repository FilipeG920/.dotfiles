;;; -*- lexical-binding: t -*-

;; (use-package link-hint
;;   :ensure t
;;   :after evil)
(use-package browse-url
  :ensure nil
  :custom
  (browse-url-browser-function #'eww-browse-url)
  (browse-url-secondary-browser-function #'browse-url-default-browser))
;; press & to open a page in a GUI browser

(defun my/eww-new-buffer ()
  "Open an URL/search in a new buffer."
  (interactive)
  (let ((current-prefix-arg '(4)))
    (call-interactively #'eww)))

(defun my-language-doc-search (query)
  "Search official documentation for QUERY based on current major mode."
  (interactive
   (list
    (read-string
     "Documentation search: "
     (thing-at-point 'symbol t))))

  (let ((site
         (cond
          ((derived-mode-p 'go-mode 'go-ts-mode)
           "go.dev")

          ((derived-mode-p 'rust-mode 'rust-ts-mode)
           "doc.rust-lang.org")

          ((derived-mode-p 'python-mode 'python-ts-mode)
           "docs.python.org")

          ((derived-mode-p 'typescript-mode
                           'typescript-ts-mode
                           'tsx-ts-mode)
           "typescriptlang.org/docs")

          ((derived-mode-p 'js-mode 'js-ts-mode)
           "developer.mozilla.org")

          (t nil))))

    (eww
     (if site
         (format "site:%s %s" site query)
       query))))

(global-set-key (kbd "C-c d s") #'my-language-doc-search)
;;     (kbd "f") #'link-hint-open-link
;;     (kbd "O") #'my/eww-new-buffer
;;     (kbd "r") #'eww-reload
;;     (kbd "/") #'isearch-forward))
