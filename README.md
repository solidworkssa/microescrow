# MicroEscrow

Simple P2P escrow with arbiter release mechanism on Base and Stacks.

## Features

- Create escrow agreements
- Fund with ETH/STX
- Arbiter-controlled release
- Refund mechanism

## Contract Functions

### Base (Solidity)
- `createEscrow(seller, arbiter)` - Create funded escrow
- `release(escrowId)` - Release funds to seller
- `refund(escrowId)` - Refund to buyer

### Stacks (Clarity)
- `create-escrow` - Create STX escrow
- `release` - Release to seller
- `get-escrow` - Get escrow details

## Quick Start

```bash
pnpm install
pnpm dev
```

## Deploy

```bash
pnpm deploy:base
pnpm deploy:stacks
```

## License

MIT
