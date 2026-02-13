;; MicroEscrow Clarity Contract
;; Trustless escrow for secure small transactions.


(define-map escrows
    uint
    {
        payer: principal,
        payee: principal,
        amount: uint,
        state: (string-ascii 20)
    }
)
(define-data-var next-escrow-id uint u0)

(define-public (create-escrow (payee principal) (amount uint))
    (let
        (
            (id (var-get next-escrow-id))
        )
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set escrows id {
            payer: tx-sender,
            payee: payee,
            amount: amount,
            state: "awaiting-delivery"
        })
        (var-set next-escrow-id (+ id u1))
        (ok id)
    )
)

(define-public (release (id uint))
    (let
        (
            (escrow (unwrap! (map-get? escrows id) (err u404)))
        )
        (asserts! (is-eq tx-sender (get payer escrow)) (err u401))
        (asserts! (is-eq (get state escrow) "awaiting-delivery") (err u400))
        (try! (as-contract (stx-transfer? (get amount escrow) tx-sender (get payee escrow))))
        (map-set escrows id (merge escrow {state: "completed"}))
        (ok true)
    )
)

