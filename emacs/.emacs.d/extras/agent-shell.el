;;; -*- lexical-binding: t; -*-

(use-package agent-shell
  :ensure t

  :bind
  (("C-c a a" . agent-shell)
   ("C-c a n" . agent-shell-new-shell)
   ("C-c a d" . agent-shell-send-dwim)
   ("C-c a r" . agent-shell-send-region-to))

  :config
  ;; Agents available in `agent-shell'.
  (setq agent-shell-agent-configs
        (list #'agent-shell-openai-make-codex-config
              #'agent-shell-kimi-make-config))

  ;; Default to Codex in the picker, without skipping the picker.
  (setq agent-shell-preferred-agent-config
        '(preselect . codex))

  ;; Authenticate Codex through ChatGPT login.
  (setq agent-shell-openai-authentication
        (agent-shell-openai-make-authentication :login t)))
