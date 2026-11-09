;;; -*- lexical-binding: t -*-
;;;
;;; Emacs Bedrock
;;;
;;; Extra config: Development tools

;;; Usage: Append or require this file from init.el for some software
;;; development-focused packages.
;;;
;;; It is **STRONGLY** recommended that you use the base.el config if you want to
;;; use Eglot. Lots of completion things will work better.
;;;
;;; This will try to use tree-sitter modes for many languages. Please run
;;;
;;;   M-x treesit-install-language-grammar
;;;
;;; Before trying to use a treesit mode.

;;; Contents:
;;;
;;;  - Built-in config for developers
;;;  - Version Control
;;;  - Common file types
;;;  - Eglot, the built-in LSP client for Emacs
;;;  - Templating

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in config for developers
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :config
  ;; TAB indents first, then performes completion.
  (setopt tab-always-indent 'complete)
  (show-paren-mode 1)
  ;; Code folding config
  (setopt hs-show-indicators t)         ; Show collapse indicators in margin
  (setopt hs-display-lines-hidden t)    ; Show number of collapsed lines


  ;; Treesitter config

  ;; Enable tree-sitter in all available modes
  (setopt treesit-enabled-modes t)

  ;; Amount to highlight: integer between 1-4; 4 is max highlighting
  (setopt treesit-font-lock-level 4)

  ;; What to do if language grammar not installed: default is `ask';
  ;; other options are `always', and `ask-dir'.
  (setopt treesit-auto-install-grammar 'ask)

  :hook
  ;; Auto parenthesis matching
  ((prog-mode . electric-pair-mode)
   (prog-mode . hs-minor-mode)
   (prog-mode . display-line-numbers-mode))

  )

(use-package project
  :custom
  (when (>= emacs-major-version 30)
    (project-mode-line t)))         ; show project name in modeline

;; ToDo: add this to '.dir-locals.el' for a language's build/test command:
;; Rust
;; ((nil . ((compile-command . "cargo test"))))
;; Go
;; ((nil . ((compile-command . "go test ./..."))))
;; Python
;; ((nil . ((compile-command . "pytest"))))
;; Typescript
;; ((nil . ((compile-command . "npm test"))))



;; this should be used alongside direnv for when I need
;; to set specific environment variables for a project
;; or a specific environment setup
(use-package envrc
  :hook (after-init . envrc-global-mode)

  :config
  (with-eval-after-load 'envrc
    (define-key envrc-mode-map
                (kbd "C-c e")
                'envrc-command-map)))
;; example of use: installing a specific typescript LSP for a project
;; put it in direnv and let eglot automatically inherit it.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Version Control
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Magit: best Git client to ever exist
(use-package magit
  :bind (("C-x g" . magit-status)))

;; Git changes in fringe/margin
(use-package diff-hl
  :hook
  ((prog-mode . diff-hl-mode)
   (dired-mode . diff-hl-dired-mode))
  :config
  (diff-hl-flydiff-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Common file types
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package markdown-mode
  :hook ((markdown-mode . visual-line-mode)))

(use-package yaml-mode)

(use-package json-mode)

;; Emacs ships with a lot of popular programming language modes. If it's not
;; built in, you're almost certain to find a mode for the language you're
;; looking for with a quick Internet search.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Eglot, the built-in LSP client for Emacs
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helpful resources:
;;
;;  - https://www.masteringemacs.org/article/seamlessly-merge-multiple-documentation-sources-eldoc

(use-package eglot
  ;; no :ensure t here because it's built-in

  ;; Configure hooks to automatically turn-on eglot for selected modes
  :hook
  (((rust-mode rust-ts-mode
	       go-mode go-ts-mode
	       python-mode python-ts-mode
	       js-mode js-ts-mode
	       typescript-mode typescript-ts-mode
	       tsx-ts-mode)
    . eglot-ensure))

  :custom
  (eglot-send-changes-idle-time 0.3)
  (eglot-extend-to-xref t)              ; activate Eglot in referenced non-project files

  :bind
  (:map eglot-mode-map
	("C-c l a" . eglot-code-actions)
        ("C-c l r" . eglot-rename)
        ("C-c l f" . eglot-format-buffer)
        ("C-c l h" . eglot-inlay-hints-mode)
        ("C-c l R" . eglot-reconnect))

  :config
  ;; Avoid changing line heights if your font is wonky. See
  ;; https://github.com/joaotavora/eglot/discussions/1492
  (setopt eglot-code-action-indicator "h")

  ;; (fset #'jsonrpc--log-event #'ignore)  ; massive perf boost---don't log every event -> Disabled for now
  ;; Sometimes you need to tell Eglot where to find the language server
					; (add-to-list 'eglot-server-programs
					;              '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))

  ;; You can set various options for each language server. For
  ;; example, you can raise the number of completions surfaced by a
  ;; given langauge server to Emacs:
  ;;(setopt eglot-workspace-configuration
  ;;'((haskell (maxCompletions . 100))
  ;;(elixir  (maxCompletions . 100))))
  )

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((python-mode python-ts-mode)
		 . ("basedpyright-langserver" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Universal Formatter Layer (Apheleia)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package apheleia
  :config
  ;; Ruff is better lol.
  (setf (alist-get 'python-mode apheleia-mode-alist) 'ruff
        (alist-get 'python-ts-mode apheleia-mode-alist) 'ruff)

  (apheleia-global-mode +1)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Editor Config
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package editorconfig
  :ensure nil
  :config
  (editorconfig-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Templating
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package tempel
  ;; By default, tempel looks at the file "templates" in
  ;; user-emacs-directory, but you can customize that with the
  ;; tempel-path variable:
  ;; :custom
  ;; (tempel-path (concat user-emacs-directory "custom_template_file"))
  :bind (("M-*" . tempel-insert)
         ("M-+" . tempel-complete)
         :map tempel-map
         ("C-c RET" . tempel-done)
         ("C-<down>" . tempel-next)
         ("C-<up>" . tempel-previous)
         ("M-<down>" . tempel-next)
         ("M-<up>" . tempel-previous))
  :init
  ;; Make a function that adds the tempel expansion function to the
  ;; list of completion-at-point-functions (capf).
  (defun tempel-setup-capf ()
    (add-hook 'completion-at-point-functions #'tempel-expand -1 'local))
  ;; Put tempel-expand on the list whenever you start programming or
  ;; writing prose.
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

;; collection of templates
(use-package tempel-collection
  :after tempel)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Debugging(Dape)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dape
  :commands dape
  :custom
  (dape-buffer-window-arrangement 'right))

;; TODO: See if configuration for specific language debugging tools are necessary

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Special Syntax-Highlighting (Prism)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Always update this function when using a new language.
(defun gen-configure-prism()
  (add-hook 'lisp-mode-hook 'prism-mode)
  (add-hook 'emacs-lisp-mode-hook 'prism-mode)
  (add-hook 'scheme-mode-hook 'prism-mode)
  (add-hook 'json-mode-hook 'prism-mode)
  (add-hook 'yaml-mode-hook 'prism-mode)
  (add-hook 'clojure-mode-hook 'prism-mode)
  (add-hook 'python-ts-mode-hook 'prism-whitespace-mode)
  (add-hook 'rust-ts-mode-hook 'prism-mode)
  (add-hook 'typescript-ts-mode-hook 'prism-mode)
  (add-hook 'go-ts-mode-hook 'prism-mode))

;; (use-package prism
;;   :ensure t
;;   :config (gen-configure-prism))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Documentation(DevDocs & Eldoc)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package devdocs
  :ensure t
  :bind (("C-h D" . devdocs-lookup)
	 ("C-c d d" . devdocs-search)))

(use-package eldoc
  :ensure nil
  :bind ("C-c d e" . eldoc))
