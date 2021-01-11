;;; emacs-usage-tracker.el ---  -*- lexical-binding: t; -*-

(require 'cl-lib)


(defconst *track-file-dir* "~/.emacs.d/.emacs-hours")


(defun create-track-file-if-necessary ()
  (when (not (file-directory-p *track-file-dir*))
    (make-empty-file target-dir)))


(defun save-uptime-at-exit ()
  "1. create a temp buffer,
   2. write the uptime into that buffer,
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


(defun main ()
  (create-track-file-if-necessary)
  (add-hook save-time-at-startup emacs-startup-hook)
  (add-hook save-uptime-at-exit kill-emacs-hook))

;;; emacs-usage-tracker.el ends here
