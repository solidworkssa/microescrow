# 04-microescrow - Base Native Architecture

> **Built for the Base Superchain & Stacks Bitcoin L2**

This project is architected to be **Base-native**: prioritizing onchain identity, low-latency interactions, and indexer-friendly data structures.

## 🔵 Base Native Features
- **Smart Account Ready**: Compatible with ERC-4337 patterns.
- **Identity Integrated**: Designed to resolve Basenames and store social metadata.
- **Gas Optimized**: Uses custom errors and batched call patterns for L2 efficiency.
- **Indexer Friendly**: Emits rich, indexed events for Subgraph data availability.

## 🟠 Stacks Integration
- **Bitcoin Security**: Leverages Proof-of-Transfer (PoX) via Clarity contracts.
- **Post-Condition Security**: Strict asset movement checks.

---
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
