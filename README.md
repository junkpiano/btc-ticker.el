# btc-ticker

A tiny Emacs minor mode that shows the current **Bitcoin price** in your mode line.

* No API key (uses CoinGecko public endpoint)
* Currency/interval/format customizable (default: JPY, every 60s)

---

## Features

* Global minor mode: `btc-ticker-mode`
* Customizable variables:

  * `btc-ticker-currency` (e.g. `"JPY"`, `"USD"`)
  * `btc-ticker-interval` (seconds)

---

## Requirements

* Emacs **27.1+** (verified on 30.x)
* Built-ins: `url`, `json`

---

## Installation

### With `straight.el` + `use-package` (recommended)

```elisp
;; bootstrap straight.el if needed
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Replace "junkpiano/btc-ticker" with your repo path
(use-package btc-ticker
  :straight (btc-ticker :type git :host github :repo "junkpiano/btc-ticker")
  :custom
  (btc-ticker-currency "JPY")
  (btc-ticker-interval 60)
  :config
  (btc-ticker-mode 1))
```

### Local development checkout (relative paths only)

If `btc-ticker.el` is in your project root while developing, you can load it directly:

```elisp
(add-to-list 'load-path default-directory) ; project root
(require 'btc-ticker)
(btc-ticker-mode 1)
```

## Usage

Enable/disable:

```elisp
M-x btc-ticker-mode
```

Customize:

```elisp
;; currency: "JPY", "USD", "EUR", ...
(setq btc-ticker-currency "JPY")

;; polling interval (seconds)
(setq btc-ticker-interval 60)

;; mode-line format (PRICE, CURRENCY)
(setq btc-ticker-format "₿ %s %s")   ; or "BTC %s %s"
```

---

## Fonts

If the Bitcoin symbol `₿` (U+20BF) doesn’t render in **GUI Emacs** (e.g., WSL2 + `emacs-gtk`):

* Install a font that contains U+20BF, e.g. **Noto Sans Symbols 2**
* On Ubuntu/WSL2 (Linux side for GUI):

  ```bash
  sudo apt update
  sudo apt install -y fonts-noto-extra
  fc-cache -fsv
  ```

## License

MIT