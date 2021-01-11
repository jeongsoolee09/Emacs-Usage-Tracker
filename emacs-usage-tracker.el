;;; emacs-usage-tracker.el ---  -*- lexical-binding: t; -*-

(require 'cl-lib)


(defun create-track-file ()
  (make-empty-file "~/.emacs.d/.emacs-hours"))     ; TEMP the directory is temporarily the current dir for testing purposes


(defun save-uptime-at-exit ()
  "1. create a temp buffer,
   2. write the uptime into that buffer,
   3. and save the buffer, appending to the existing `.emacs-hours` file."
  (let ((uptime (concat (emacs-uptime "%h:%m:%s") "\n")))
    (with-temp-buffer
      (insert uptime)
      (append-to-file (point-min) (point-max) ".emacs-hours"))))


(defun main ()
  (create-track-file)
  (add-hook save-uptime-at-exit kill-emacs-hook))

;;; emacs-usage-tracker.el ends here
