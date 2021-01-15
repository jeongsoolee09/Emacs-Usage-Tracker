;;; emacs-usage-tracker.el ---  -*- lexical-binding: t; -*-

(require 'cl-lib)


(defcustom emacs-track-file-dir "~/.emacs.d/.emacs-hours"
  "The file for recording Emacs usage time."
  :type 'file)


(defun create-track-file-if-necessary ()
  (when (not (file-directory-p *track-file-dir*))
    (make-empty-file target-dir)))


(defun save-uptime-at-exit ()
  "1. create a temp buffer,
   2. write the uptime (in seconds) into that buffer,
   3. and save the buffer, appending to the existing `.emacs-hours` file."
  (let ((date (format-time-string "%Y-%m-%d:"))
        (uptime (concat (emacs-uptime "%s") "\n")))
    (with-temp-buffer
      (insert date)
      (insert uptime)
      (append-to-file (point-min) (point-max) *track-file-dir*))))


(defun save-time-at-startup ()
  (with-temp-buffer
    (insert (format-time-string "%Y-%m-%d~"))
    (append-to-file (point-min) (point-max) *track-file-dir*)))


(defun emacs-usage-tracker-setup ()
  (interactive)
  (create-track-file-if-necessary)
  (add-hook save-time-at-startup emacs-startup-hook)
  (add-hook save-uptime-at-exit kill-emacs-hook))


(defun seconds-to-hours-and-mins (seconds)
  (format-seconds "%d days, %h hours, %m minutes, and %s seconds"))


;; Statistics functions


(defun get-usage-of-day (date)
  "Given a date, get the usage of that day.")


(defun get-usage-of-today ()
  "Get the usage of today.")


(defun get-usage-of-week (date)
  "Get the usage of that week upto the given date.")


(defun get-usage-of-this-week ()
  "Get the usage of this week upto today.")


(defun get-usage-of-month (date)
  "Get the usage of that month upto the given date.")


(defun get-usage-of-this-month ()
  "Get the usage of this month upto today.")


(defun get-usage-of-year (date)
  "Get the usage of that year upto the given date.")


(defun get-highest-day-of-month (date)
  "Get the date with the most uptime in that month,
   upto the given date.")


(defun get-highest-day-of-year (date)
  "Get the date with the most uptime in that year,
   upto the given date.")


(defun get-highest-month-of-year (date)
  "Get the month with the most uptime in that year,
   upto the given date.")


;;; emacs-usage-tracker.el ends here
