;;; emacs-usage-tracker.el ---  -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 's)    ; string manipulation library
(require 'ts)   ; timestamp library


(defcustom emacs-track-file-dir "~/.emacs.d/.emacs-hours"
  "The file for recording Emacs usage time."
  :type 'file)


(defun create-track-file-if-necessary ()
  (when (not (file-directory-p *track-file-dir*))
    (make-empty-file target-dir)))


(defun save-time-at-startup ()
  (with-temp-buffer
    (insert (concat (current-time-string) "~"))
    (append-to-file (point-min) (point-max) emacs-track-file-dir)))


(defun save-time-at-exit ()
  (with-temp-buffer
    (insert (current-time-string))
    (append-to-file (point-min) (point-max) emacs-track-file-dir)))


(defun emacs-usage-tracker-setup ()
  (interactive)
  (create-track-file-if-necessary)
  (add-hook save-time-at-startup emacs-startup-hook)
  (add-hook save-uptime-at-exit kill-emacs-hook))


(defun calculate-uptime (time-line)
  "calculate the uptime from the string <start>~<end>"
  (let* ((two-tss (s-split "~" time-line))
         (starting-ts (ts-parse (car two-tss)))
         (ending-ts (ts-parse (cadr two-tss))))
    (ts-difference ending-ts starting-ts)))


(defun zero-apply (ts)
  (ts-fill (ts-apply :hour 0 :minute 0 :second 0 ts)))


(defun adjust-to-sunday-and-zero-apply (ts num)
  (->> ts
      (ts-adjust 'day (- 0 num))
      (ts-fill)
      (zero-apply)))


(defun get-this-weeks-sunday-date (date)
  (let ((now-ts (ts-fill date)))
    (pcase (ts-day-abbr now-ts)
      ("Sun" (zero-apply now-ts))
      ("Mon" (adjust-to-sunday-and-zero-apply now-ts 1))
      ("Tue" (adjust-to-sunday-and-zero-apply now-ts 2))
      ("Wed" (adjust-to-sunday-and-zero-apply now-ts 3))
      ("Thu" (adjust-to-sunday-and-zero-apply now-ts 4))
      ("Fri" (adjust-to-sunday-and-zero-apply now-ts 5))
      ("Sat" (adjust-to-sunday-and-zero-apply now-ts 6)))))


(defun read-entire-track-file ()
  "Read the track file line by line, and collect them into a list.
   credit: ErgoEmacs"
  (with-temp-buffer
    (insert-file-contents emacs-track-file-dir)
    (split-string (buffer-string) "\n" t)))


(defun seconds-to-hours-and-mins (seconds)
  (format-seconds "%d days, %h hours, %m minutes, and %s seconds"))


;; Statistics functions


(defun is-today (time-line date)
  (let* ((two-tss (s-split "~" time-line))
         (starting-ts (ts-parse (car two-tss)))
         (ending-ts (ts-parse (cadr two-tss))))
    (equal (ts-day starting-ts)
           (ts-day date))))


(defun is-complete (time-line)
  (let* ((two-tss (s-split "~" time-line))
         (starting-ts (ts-parse (car two-tss)))
         (ending-ts (ts-parse (cadr two-tss))))
    (not (equal (ts-day ending-ts) ""))))


(defun get-usage-of-day (date)
  "Given a date, get the usage of that day, by:
   - if there are no complete records in the file, return the uptime
   - if there are complete records in the file, add up all the uptimes"
  (let* ((track-file-lines (read-entire-track-file))
         (today-lines (cl-loop for line in track-file-lines
                               if (and (is-today line date)
                                       (is-complete line))
                               collect line)))
    (if (null today-lines)
        (cl-parse-integer (emacs-uptime "%s"))
      (apply #'+ (mapcar #'calculate-uptime today-lines)))))


(defun get-usage-of-today ()
  "Get the usage of today."
  (get-usage-of-day (ts-now)))


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
