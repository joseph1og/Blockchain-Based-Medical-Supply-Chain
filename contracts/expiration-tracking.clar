;; Expiration Tracking Contract - Simplified
;; Manages inventory based on product shelf life

(define-map expirations
  { product-id: uint }
  {
    manufacture-date: uint,
    expiry-date: uint,
    is-expired: bool
  }
)

(define-map disposals
  { product-id: uint }
  {
    disposer: principal,
    disposal-date: uint,
    disposal-method: (string-ascii 32)
  }
)

;; Register product expiration
(define-public (register-expiration (product-id uint) (manufacture-date uint) (shelf-days uint))
  (let
    ((expiry-date (+ manufacture-date (* shelf-days u144))))  ;; ~144 blocks per day

    ;; Store expiration data
    (ok (map-set expirations
      { product-id: product-id }
      {
        manufacture-date: manufacture-date,
        expiry-date: expiry-date,
        is-expired: false
      }
    ))
  )
)

;; Check expiration status
(define-public (check-expiration (product-id uint))
  (let
    ((expiration (default-to
                   { manufacture-date: u0, expiry-date: u0, is-expired: false }
                   (map-get? expirations { product-id: product-id }))))

    ;; Calculate if expired
    (let
      ((is-expired (>= block-height (get expiry-date expiration))))

      ;; Update expiration status
      (ok (map-set expirations
        { product-id: product-id }
        (merge expiration { is-expired: is-expired })
      ))
    )
  )
)

;; Record disposal
(define-public (record-disposal (product-id uint) (disposal-method (string-ascii 32)))
  ;; Store disposal record
  (ok (map-set disposals
    { product-id: product-id }
    {
      disposer: tx-sender,
      disposal-date: block-height,
      disposal-method: disposal-method
    }
  ))
)

;; Get expiration data
(define-read-only (get-expiration (product-id uint))
  (map-get? expirations { product-id: product-id })
)

;; Get disposal record
(define-read-only (get-disposal (product-id uint))
  (map-get? disposals { product-id: product-id })
)

;; Check if product is expired
(define-read-only (is-expired (product-id uint))
  (let
    ((expiration (default-to
                   { manufacture-date: u0, expiry-date: u0, is-expired: false }
                   (map-get? expirations { product-id: product-id }))))

    (get is-expired expiration)
  )
)
