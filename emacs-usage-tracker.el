;;; emacs-usage-tracker.el ---  -*- lexical-binding: t; -*-


(defun create-track-file ()
  (make-empty-file ".emacs-hours"))     ; TEMP the directory is temporarily the current dir for testing purposes


(defun main ()
  (create-track-file))

;;; emacs-usage-tracker.el ends here
