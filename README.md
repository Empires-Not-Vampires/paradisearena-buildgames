# paradisearena-buildgames

**Agar.io meets Web3 — stake tokens, eat competitors, claim their bags.**

Paradise Arena is a real-time multiplayer PvP game where players stake Avalanche ecosystem tokens, compete in familiar blob-eating gameplay, and claim opponents' tokens when they eliminate them.

---

## Why This Repo is Partially Private

Paradise Arena involves real token staking and on-chain fund transfers. To protect players and the platform:

- **Smart contracts are public** — fully auditable escrow logic
- **Game assets are public** — art, UI elements, screenshots
- **Server and client code are private** — prevents exploitation of game logic, anti-cheat systems, and server infrastructure

This is standard practice for live games handling real value. We're happy to provide private repo access to grant reviewers upon request.

---

## Game Overview

### Core Gameplay
- Classic agar.io mechanics: move, eat food, grow larger, eat smaller players
- Split mechanic to escape or attack
- Consumables: speed boosts, shields, mystery drinks
- Real-time multiplayer with bot AI backfill

### Game Modes

**Practice Mode (Free)**
- No wallet required
- Learn mechanics risk-free
- 10 fake tokens to practice with

**Arena Mode (Staked)**
- Deposit 0.1 AVAX to enter
- 10% platform fee, start with 0.09 AVAX bag
- Eat players → claim their bag
- Get eaten → lose your bag
- Exit via portal → keep your winnings

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Game Client | Phaser 3, React 18, TypeScript, Vite |
| UI/State | Tailwind CSS, Zustand |
| Game Server | Colyseus, Node.js, Express |
| Blockchain | Avalanche C-Chain, Solidity |
| Network | WebSocket (Colyseus protocol) |

### Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Game Client   │────▶│   Game Server   │────▶│ Escrow Contract │
│  (Phaser/React) │◀────│   (Colyseus)    │◀────│   (Avalanche)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
        │                       │                       │
   Renders game            Authoritative           Holds funds
   Sends input             game state              Processes transfers
```

- **Server-authoritative**: Server determines all outcomes. Clients send input only.
- **Escrow pattern**: Tokens held in contract during play, transferred on elimination/exit.
- **Minimal on-chain calls**: Blockchain touched only on entry, elimination, and exit — not during gameplay.

---

## Smart Contracts

**Network:** Avalanche Fuji Testnet (Chain ID: 43113)

**Escrow Contract:** [`0x17CcD924877Cd7A50D6907f657059E36d6C5B253`](https://testnet.snowtrace.io/address/0x17CcD924877Cd7A50D6907f657059E36d6C5B253)

### Contract Functions

| Function | Description |
|----------|-------------|
| `enterArena()` | Player deposits tokens, fee deducted, balance locked |
| `transferBag(from, to, amount)` | Transfers funds between players on elimination |
| `exitArena(player, amount)` | Releases funds to player wallet |
| `getPlayerBag(player)` | Query current escrow balance |

### Security Model

- Server acts as trusted operator for game-triggered transactions
- Players cannot directly call transfer/exit — only server can invoke based on game outcomes
- Contract is sole custodian of funds during gameplay

Full contract source available in [`/contracts`](./contracts)

---

## Game Assets

Sample assets included in this repo to demonstrate visual style and quality:

```
assets/
├── characters/
│   └── paradise_tycoon_character.png    # Player avatar
├── ui/
│   ├── leaderboard_top10.png            # Leaderboard header
│   ├── gold.png, silver.png, bronze.png # Rank medals
│   ├── practice_mode_selected.png       # Mode buttons
│   ├── arena_mode_selected.png
│   └── end_screen.png                   # Game over screen
├── environment/
│   ├── Tile_Grass.png                   # Arena tiles
│   ├── Tile_Sand.png
│   ├── Tile_Water.png
│   └── Tile_Grass_Portal.png            # Exit portal
└── consumables/
    ├── Consumable_Banana.png            # Food items
    ├── Consumable_Coconut.png
    └── Consumable_SpeedDrink.png        # Power-ups
```

All assets created by our art team using Paradise Tycoon IP.

---

## Roadmap

### Current (MVP)
- ✅ Core agar.io mechanics
- ✅ Practice and Arena modes
- ✅ Escrow contract on Fuji testnet
- ✅ Real-time multiplayer
- ✅ Exit portal with fund release

### Next (v1.0)
- Inventory system with hotkey slots
- Multiple ecosystem token support
- Mobile controls
- Enhanced bot AI

### Future (v1.5+)
- Player-created tournaments
- Seasonal leaderboards
- Unlockable character skins

---

## Links

- **Play:** [arena.paradise.cloud](https://arena.paradise.cloud)
- **Contract:** [Snowtrace](https://testnet.snowtrace.io/address/0x17CcD924877Cd7A50D6907f657059E36d6C5B253)
- **Paradise Tycoon:** [paradisetycoon.com](https://paradisetycoon.com)

---

## Team

Built by **Empires Not Vampires**, the team behind Paradise Chain L1 and Paradise Tycoon (1M+ players).

---

## License

Smart contracts: MIT License  
Game assets: © Empires Not Vampires, All Rights Reserved  
Game code: Proprietary (private repository)
