(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

(setq org-cycle-separator-lines 0)

(setq org-special-ctrl-a/e t)

(setq org-startup-folded t)

(setq org-catch-invisible-edits 'show)

(setq org-goto-auto-isearch nil)

(setq org-M-RET-may-split-line t)

(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+"))
      org-list-indent-offset 1)

(setq org-cycle-include-plain-lists 'integrate)

(setq org-hide-block-startup nil)

(setq org-table-export-default-format "orgtbl-to-csv")

(setq org-link-abbrev-alist
      '(("duckduckgo" . "https://duckduckgo.com/?q=%h")
        ("gnubug" . "https://debbugs.gnu.org/cgi/bugreport.cgi?bug=")))

(setq org-use-fast-todo-selection t)

(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s!)"
                  "NEXT(n)" "WAITING(w@/!)"
                  "HOLD(h@/!)" "|" "DONE(d)"
                  "CANCELED(c@/!)" "PHONE"
                  "MEETING")))

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "firebrick" :weight bold :box nil))
        ("STARTED" . (:foreground "DarkOrange3" :weight bold :box nil))
        ("NEXT" . (:foreground "olive drab" :weight bold :box nil))
        ("WAITING" . (:foreground "steel blue" :weight bold :box nil))
        ("HOLD" . (:foreground "orchid" :weight bold :box nil))
        ("DONE" . (:foreground "dim gray" :strike-through t))
        ("CANCELED" . (:foreground "dim gray" :strike-through t))
        ("PHONE" . (:foreground "dim gray"))
        ("MEETING" . (:foreground "dim gray"))))

(setq org-log-done 'time)

(add-to-list 'org-modules 'org-habit)

(setq org-habit-graph-column 40
      org-habit-preceding-days 30
      org-habit-following-days 7
      org-habit-show-habits-only-for-today t)

(setq org-highest-priority 65
      org-lowest-priority 69
      org-default-priority 67)

(setq org-tag-alist (quote ((:startgroup . nil)
                            ("@work" . ?W)
                            ("@home" . ?H)
                            ("@parents" . ?P)
                            (:endgroup . nil)
                            ("WAITING" . ?w)
                            ("HOLD" . ?h)
                            ("HABITS" . ?b)
                            ("PERSONAL" . ?p)
                            ("ORG" . ?o)
                            ("NOTE" . ?n)
                            ("CANCELED" . ?c)
                            ("FLAGGED" . ??))))

(setq org-use-fast-tag-selection t
      org-fast-tag-selection-single-key 'expert)

(setq org-global-properties
      '(("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
        ("STYLE_ALL" . "habit")))

(setq org-time-stamp-rounding-minutes '(1 1))

(setq org-log-redeadline 'note
      org-log-reschedule 'time)

(org-clock-persistence-insinuate)
(setq org-clock-persist t
      org-clock-history-length 25)

(defun jr/clock-in-to-started (kw)
  "Return special todo keyword when outside org-capture-mode."
  (unless (or (string-equal kw "STARTED")
              (and (boundp 'org-capture-mode)
                   org-capture-mode))
    "STARTED"))

(setq org-clock-into-drawer t
      org-clock-out-remove-zero-time-clocks t
      org-clock-out-when-done t
      org-clock-in-switch-to-state 'jr/clock-in-to-started)

(setq org-clock-idle-time 10)

(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM"
      org-agenda-overriding-columns-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

(setq org-directory "~/rep/personal/org"
      org-default-notes-file (concat org-directory "/notes.org"))

(defconst jr/org-basic-scheduled-task
  "* TODO %^{Task}
  SCHEDULED: %t
  :PROPERTIES:
  :Effort: %^{effort|1:00|0:05|0:15|0:30|0:45|2:00|3:00|4:00|5:00|6:00}
  :END:\n%U\n%?\n%i\n%a\n" "Basic task data suggested by Sasha Chua")

(defconst jr/org-habit-task
  "* NEXT %? :HABIT:
  SCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")
  :PROPERTIES:
  :STYLE: habit
  :REPEAT_TO_STATE: NEXT
  :END:\n%U\n%a\n" "Capture template for habits")

(setq org-capture-templates
      `(("t" "todo" entry (file "refile.org")
         ,jr/org-basic-scheduled-task :clock-in t :clock-resume t)
        ("r" "respond" entry (file "refile.org")
         "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n"
          :clock-in t :clock-resume t :immediate-finish t)
        ("n" "note" entry (file "refile.org")
         "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
        ("h" "habit" entry (file "refile.org")
         ,jr/org-habit-task :clock-in t :clock-resume t)
        ("i" "interrupting task" entry (file "refile.org")
         "* STARTED %^{Task}\n   SCHEDULED: %t\n%a"
         :clock-in t :clock-keep t)
        ("m" "meeting" entry (file "refile.org")
         "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
        ("w" "org-protocol" entry (file "refile.org")
         "* TODO Review %:description\n   SCHEDULED: %t\nSource: %:link\n\n"
         :immediate-finish t)
        ("s" "someday" entry (file+headline "someday.org" "Someday tasks")
         "* %? :SOMEDAY:\n%U\n%a\n" :clock-in t :clock-resume t)
        ("p" "phone call" entry (file "refile.org")
         "* PHONE call with %? :PHONE:\n%U" :clock-in t :clock-resume t)))

(defun jr/org-remove-empty-drawer-on-clock-out ()
  "Blatlanty stolen from http://doc.norang.ca/org-mode.html"
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at (point))))

(add-hook 'org-clock-out-hook 'jr/org-remove-empty-drawer-on-clock-out)

(setq org-capture-templates-contexts
      '(("r" ((in-mode . "gnus-\\(summary\\|article\\)-mode")))))

(setq org-refile-targets '((nil :maxlevel . 4) ; nil = current buffer
                           (org-agenda-files :maxlevel . 3)
                           (org-agenda-files :tag . "PROJECT")))

(defun jr/org-verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets.
Taken from http://doc.norang.ca/org-mode.html"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'jr/org-verify-refile-target
      org-refile-use-outline-path t
      org-outline-path-complete-in-steps nil
      org-refile-allow-creating-parent-nodes 'confirm
      org-log-refile 'time)

(setq org-archive-location "%s_archive::datetree/"
      org-archive-save-context-info '(time file ltags itags todo category olpath))

(setq org-agenda-window-setup 'reorganize-frame
      org-agenda-restore-windows-after-quit t)

(setq org-agenda-files (list org-directory
                             (concat org-directory "/maximo-nivel")
                             (concat org-directory "/ticketnetwork")))

(define-key org-mode-map (kbd "C-c [") 'nil)
(define-key org-mode-map (kbd "C-c ]") 'nil)

(setq org-agenda-sticky t)

(setq org-agenda-span 'day
      org-agenda-include-diary nil)

(org-agenda-to-appt)

(defun jr/org-agenda-to-appt ()
  "Clear the list of today's appointments and rebuild it from the
`org-agenda'"
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))

(add-hook 'org-agenda-finalize-hook 'jr/org-agenda-to-appt 'append)
(run-at-time "24:05" nil 'jr/org-agenda-to-appt)

(setq org-agenda-todo-ignore-deadlines 'all
      org-agenda-todo-ignore-scheduled 'all)

(setq org-stuck-projects
      '("+LEVEL=2/-DONE" ("TODO" "NEXT" "STARTED") nil ""))

(setq org-fontify-emphasized-text t)

(setq org-pretty-entities t)

(define-key org-mode-map (kbd "C-c ;") 'nil)

(setq org-use-speed-commands t)

;; Fontify org-mode code blocks
(setq org-src-fontify-natively t)

(use-package org-present
  :ensure t
  :config
  (progn
    (use-package hide-mode-line
      :ensure t)
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)
                 (hide-mode-line-mode +1)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)
                 (hide-mode-line-mode -1)))))

(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-tab-acts-natively t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((C . t)
   (calc . t)
   (clojure . t)
   (haskell . t)
   (gnuplot . t)
   (java . t)
   (js . t)
   (latex . t)
   (ledger . t)
   (lisp . t)
   (org . t)
   (python . t)
   (scheme . t)
   (sed . t)
   (shell . t)
   (sqlite . t)
   (python . t)))

;; Start emacs with the agenda open
(add-hook 'after-init-hook
          (lambda ()
            (org-agenda nil "a")
            (delete-other-windows)))

;; I've been using the agenda far more these days as a way to stay
;; organized. I like that hitting 'k' while in an agenda buffer fires up
;; org-capture. What I don't like is that I have to manually refresh (by
;; hitting 'g') the agenda to see the newly added task.
;; Here's a bit of code to sort this out:

(defun jr/org-agenda-rebuild-agenda ()
  (when (buffer-live-p org-agenda-buffer)
    (ignore-errors
      (with-current-buffer org-agenda-buffer
        (org-agenda-redo t)))))

(add-hook 'org-capture-after-finalize-hook 'jr/org-agenda-rebuild-agenda)

;; Often times I need to restart emacs and leave my clocking in a bad
;; state.
;; The following hook clocks me out before closing emacs, if needed.

(add-hook 'kill-emacs-hook (lambda () (when (org-clocking-p)
                                   (with-current-buffer (org-clocking-buffer)
                                     (org-clock-out)
                                     (save-buffer)))))

(defun jr/org-show-agenda ()
  "Show the agenda buffer in a full frame creating it if needed."
  (interactive)
  (let ((agenda-buffer-name
         (if org-agenda-sticky "*Org Agenda(a)*" "*Org Agenda*")))
    (if (get-buffer agenda-buffer-name)
        (switch-to-buffer agenda-buffer-name)
      (org-agenda nil "a")))
  (delete-other-windows))

(defun jr/clock-in-last (arg)
  "Clock in the most recently clocked task.

If the clock is already active, do nothing but print a message.
With a ‘C-u’ prefix argument, offer a list of recently clocked
tasks to clock into."
  (interactive "p")
  (cond
   ((eq arg 4) (org-clock-in '(4))))
  (if (org-clock-is-active)
      (message "Clock is already active. Nothing to do.")
    (let ((task-marker (car org-clock-history)))
      (when task-marker
        (org-with-point-at task-marker
          (org-clock-in nil))))))

(global-set-key (kbd "<f12>") 'org-agenda)

(global-set-key (kbd "<f9> <f9>") 'jr/org-show-agenda)
(global-set-key (kbd "<f9> b") 'bbdb)
(global-set-key (kbd "<f9> c") 'calendar)
(global-set-key (kbd "<f9> t l") 'org-toggle-link-display)
(global-set-key (kbd "<f9> t l") 'org-toggle-link-display)
(global-set-key (kbd "<f9> t i") 'org-toggle-inline-images)

(global-set-key (kbd "<f9> i") 'org-clock-in)
(global-set-key (kbd "<f9> o") 'org-clock-out)
(global-set-key (kbd "<f9> l") 'jr/clock-in-last)
(global-set-key (kbd "<f9> e") 'org-clock-modify-effort-estimate)

(global-set-key (kbd "<f11>") 'org-clock-goto)

(global-set-key (kbd "<XF86Explorer>") 'org-agenda)
(global-set-key (kbd "<XF86Tools> <XF86Tools>") 'jr/org-show-agenda)

(global-set-key (kbd "<XF86Tools> b") 'bbdb)
(global-set-key (kbd "<XF86Tools> c") 'calendar)
(global-set-key (kbd "<XF86Tools> t l") 'org-toggle-link-display)
(global-set-key (kbd "<XF86Tools> t i") 'org-toggle-inline-images)

(global-set-key (kbd "<XF86Tools> i") 'org-clock-in)
(global-set-key (kbd "<XF86Tools> o") 'org-clock-out)
(global-set-key (kbd "<XF86Tools> l") 'jr/clock-in-last)
(global-set-key (kbd "<XF86Tools> e") 'org-clock-modify-effort-estimate)

(global-set-key (kbd "<XF86LaunchA>") 'org-clock-goto)
