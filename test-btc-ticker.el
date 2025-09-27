(let ((btc-ticker-currency "JPY"))
  (mapcar #'btc-ticker--format-price
          '(0 1 12 123 1234 12345 123456 1234567 16000000)))

(let ((btc-ticker-currency "USD"))
  (mapcar #'btc-ticker--format-price '(1 12.3 1234.5 1234567.89)))

(let ((btc-ticker-currency "JPY"))
  (list
   (symbol-function 'btc-ticker--format-price)
   (btc-ticker--format-price 16000000)))
