;; Product Registration Contract - Simplified
;; Tracks medical supplies from manufacture to use

(define-data-var product-id-counter uint u0)

(define-map products
  { id: uint }
  {
    manufacturer: principal,
    name: (string-ascii 64),
    batch: (string-ascii 32),
    current-owner: principal,
    status: (string-ascii 16)
  }
)

(define-map transfers
  { product-id: uint, transfer-id: uint }
  {
    from: principal,
    to: principal,
    timestamp: uint
  }
)

;; Register a new product
(define-public (register-product (name (string-ascii 64)) (batch (string-ascii 32)))
  (let
    ((new-id (+ (var-get product-id-counter) u1)))

    ;; Update counter
    (var-set product-id-counter new-id)

    ;; Store product data
    (map-set products
      { id: new-id }
      {
        manufacturer: tx-sender,
        name: name,
        batch: batch,
        current-owner: tx-sender,
        status: "created"
      }
    )

    ;; Record initial transfer
    (map-set transfers
      { product-id: new-id, transfer-id: u1 }
      {
        from: tx-sender,
        to: tx-sender,
        timestamp: block-height
      }
    )

    (ok new-id)
  )
)

;; Transfer product to new owner
(define-public (transfer-product (product-id uint) (to principal))
  (let
    ((product (default-to
                { manufacturer: tx-sender, name: "", batch: "", current-owner: tx-sender, status: "" }
                (map-get? products { id: product-id })))
     (transfer-count u2))

    ;; Only current owner can transfer
    (asserts! (is-eq tx-sender (get current-owner product)) (err u1))

    ;; Record transfer
    (map-set transfers
      { product-id: product-id, transfer-id: transfer-count }
      {
        from: tx-sender,
        to: to,
        timestamp: block-height
      }
    )

    ;; Update product owner
    (ok (map-set products
      { id: product-id }
      (merge product { current-owner: to })
    ))
  )
)

;; Update product status
(define-public (update-status (product-id uint) (new-status (string-ascii 16)))
  (let
    ((product (default-to
                { manufacturer: tx-sender, name: "", batch: "", current-owner: tx-sender, status: "" }
                (map-get? products { id: product-id }))))

    ;; Only current owner can update status
    (asserts! (is-eq tx-sender (get current-owner product)) (err u1))

    ;; Update product status
    (ok (map-set products
      { id: product-id }
      (merge product { status: new-status })
    ))
  )
)

;; Get product details
(define-read-only (get-product (product-id uint))
  (map-get? products { id: product-id })
)

;; Get transfer details
(define-read-only (get-transfer (product-id uint) (transfer-id uint))
  (map-get? transfers { product-id: product-id, transfer-id: transfer-id })
)
