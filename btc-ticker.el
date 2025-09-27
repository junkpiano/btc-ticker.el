;;; btc-ticker.el --- Simple BTC price ticker for mode line -*- lexical-binding: t; -*-

;; Author: Yusuke Ohashi
;; Version: 0.1
;; Package-Requires: ((emacs "27.1"))
;; Keywords: bitcoin, convenience
;; URL: local

;;; Commentary:
;; Minimal Bitcoin ticker using CoinGecko. No API key required.
;; M-x btc-ticker-mode to toggle.

;;; Code:

(require 'url)
(require 'json)

(defgroup btc-ticker nil
  "Bitcoin price ticker."
  :group 'convenience)

(defcustom btc-ticker-currency "JPY"
  "Fiat currency code for the ticker (e.g., \"USD\", \"JPY\")."
  :type 'string
  :group 'btc-ticker)

(defcustom btc-ticker-interval 60
  "Update interval in seconds."
  :type 'integer
  :group 'btc-ticker)

(defcustom btc-ticker-format "₿ %s %s"
  "Format string for the mode-line.
It receives two args: PRICE and CURRENCY."
  :type 'string
  :group 'btc-ticker)

(defface btc-ticker-face
  '((t :inherit mode-line))
  "Face for the BTC ticker."
  :group 'btc-ticker)

(defvar btc-ticker--timer nil)
(defvar btc-ticker--text "")
(defvar btc-ticker--last-price nil)

(defun btc-ticker--endpoint ()
  (format "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=%s"
          (downcase btc-ticker-currency)))

(defun btc--group-commas-from-string (s)
  "数値文字列 S を3桁区切りにして返す（小数点以下はそのまま）。"
  (let* ((neg (and (> (length s) 0) (eq (aref s 0) ?-)))
         (body (if neg (substring s 1) s))
         (parts (split-string body "\\."))
         (int-str (car parts))
         (frac-str (cadr parts))
         (i (length int-str))
         (acc '()))
    (while (> i 3)
      (push (substring int-str (- i 3) i) acc)
      (setq i (- i 3)))
    (push (substring int-str 0 i) acc)
    (concat (when neg "-")
            (mapconcat #'identity acc ",")
            (when frac-str (concat "." frac-str)))))

(defun btc-ticker--format-price (num)
  (let* ((is-jpy (string= (upcase btc-ticker-currency) "JPY"))
         (raw (if is-jpy
                  (format "%.0f" num)
                (format "%.2f" num))))
    (btc--group-commas-from-string raw)))

(defun btc-ticker--update-modeline (price)
  (setq btc-ticker--text
        (propertize
         (format btc-ticker-format (btc-ticker--format-price price) (upcase btc-ticker-currency))
         'face 'btc-ticker-face))
  (force-mode-line-update t))

(defun btc-ticker--fetch-callback (_status)
  (unwind-protect
      (when (buffer-live-p (current-buffer))
        (goto-char (point-min))
        (re-search-forward "^$" nil 'move)
        (let* ((json (json-parse-buffer :object-type 'alist :array-type 'list))
               (obj  (alist-get "bitcoin" json nil nil #'string=))
               (price (and obj (alist-get (downcase btc-ticker-currency) obj nil nil #'string=))))
          (when (numberp price)
            (setq btc-ticker--last-price price)
            (btc-ticker--update-modeline price))))
    (when (buffer-live-p (current-buffer))
      (kill-buffer (current-buffer)))))

(defun btc-ticker--fetch ()
  "Fetch price asynchronously."
  (condition-case err
      (url-retrieve (btc-ticker--endpoint) #'btc-ticker--fetch-callback nil t)
    (error
     (setq btc-ticker--text (propertize "₿ N/A" 'face 'btc-ticker-face)))))

(defun btc-ticker--start ()
  (unless btc-ticker--timer
    (setq btc-ticker--timer
          (run-at-time 0 btc-ticker-interval #'btc-ticker--fetch))))

(defun btc-ticker--stop ()
  (when btc-ticker--timer
    (cancel-timer btc-ticker--timer)
    (setq btc-ticker--timer nil)))

;;;###autoload
(define-minor-mode btc-ticker-mode
  "Toggle Bitcoin price ticker in the mode line."
  :global t
  :lighter ""
  (if btc-ticker-mode
      (progn
        (add-to-list 'global-mode-string '(:eval btc-ticker--text) t)
        (btc-ticker--start))
    (setq global-mode-string (remq '(:eval btc-ticker--text) global-mode-string))
    (btc-ticker--stop)))

(provide 'btc-ticker)
;;; btc-ticker.el ends here
