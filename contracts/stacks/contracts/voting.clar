;; MicroEscrow - P2P Escrow (Clarity v4)

(define-data-var escrow-nonce uint u0)

(define-map escrows
    uint
    {
        buyer: principal,
        seller: principal,
        arbiter: principal,
        amount: uint,
        funded: bool,
        released: bool,
        refunded: bool
    }
)

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-STATE (err u101))

(define-public (create-escrow (seller principal) (arbiter principal) (amount uint))
    (let
        (
            (escrow-id (var-get escrow-nonce))
        )
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        
        (map-set escrows escrow-id {
            buyer: tx-sender,
            seller: seller,
            arbiter: arbiter,
            amount: amount,
            funded: true,
            released: false,
            refunded: false
        })
        
        (var-set escrow-nonce (+ escrow-id u1))
        (ok escrow-id)
    )
)

(define-public (release (escrow-id uint))
    (let
        (
            (escrow (unwrap! (map-get? escrows escrow-id) ERR-INVALID-STATE))
        )
        (asserts! (or (is-eq tx-sender (get arbiter escrow)) (is-eq tx-sender (get buyer escrow))) ERR-UNAUTHORIZED)
        (asserts! (and (get funded escrow) (not (get released escrow)) (not (get refunded escrow))) ERR-INVALID-STATE)
        
        (try! (as-contract (stx-transfer? (get amount escrow) tx-sender (get seller escrow))))
        (map-set escrows escrow-id (merge escrow {released: true}))
        (ok true)
    )
)

(define-read-only (get-escrow (escrow-id uint))
    (ok (map-get? escrows escrow-id))
)
