(defvar frame-geometry-file
  (expand-file-name (concat spacemacs-cache-directory "frame-geometry"))
  "Save frame geometry to this file.")

(spacemacs|do-after-display-system-init
 (progn
   (add-hook 'after-init-hook 'frame-geometry//load)
   (add-hook 'kill-emacs-hook 'frame-geometry//save)))
