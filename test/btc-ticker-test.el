;;; btc-ticker-test.el --- unit tests for btc-ticker -*- lexical-binding: t; -*-

(require 'ert)
(require 'btc-ticker)

(ert-deftest btc-format-jpy ()
  :tags '(string)
  (let ((btc-ticker-currency "JPY"))
    (should (equal (btc-ticker--format-price 0) "0"))
    (should (equal (btc-ticker--format-price 123) "123"))
    (should (equal (btc-ticker--format-price 1234) "1,234"))
    (should (equal (btc-ticker--format-price 12345) "12,345"))
    (should (equal (btc-ticker--format-price 123456) "123,456"))
    (should (equal (btc-ticker--format-price 1234567) "1,234,567"))
    (should (equal (btc-ticker--format-price 16000000) "16,000,000"))
    (should (equal (btc-ticker--format-price -9876543) "-9,876,543"))))

(ert-deftest btc-format-usd ()
  :tags '(string)
  (let ((btc-ticker-currency "USD"))
    (should (equal (btc-ticker--format-price 1) "1.00"))
    (should (equal (btc-ticker--format-price 12.3) "12.30"))
    (should (equal (btc-ticker--format-price 1234.5) "1,234.50"))
    (should (equal (btc-ticker--format-price -9876543.2) "-9,876,543.20"))
    (should (equal (btc-ticker--format-price 1234567.89) "1,234,567.89"))))

(when (fboundp 'btc--group-commas-from-string)
  (ert-deftest btc-group-commas-string-only ()
    :tags '(string)
    (should (equal (btc--group-commas-from-string "0") "0"))
    (should (equal (btc--group-commas-from-string "16000000") "16,000,000"))
    (should (equal (btc--group-commas-from-string "1234567.89") "1,234,567.89"))
    (should (equal (btc--group-commas-from-string "-42") "-42"))))


(ert-deftest btc-api-tests-are-skipped ()
  :tags '(network api)
  (ert-skip "Network/API tests are intentionally skipped in this run."))
