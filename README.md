# VeriPact: Trusted Service Marketplace on Redbelly Network

![Status](https://img.shields.io/badge/Status-Concept%20Phase-blue) ![Network](https://img.shields.io/badge/Network-Redbelly-orange) ![Security](https://img.shields.io/badge/Security-Audit%20Planned-red)

## 🚀 The Vision
**VeriPact** is a decentralized freelance marketplace designed to solve the "Trust Deficit" in the African gig economy. By leveraging **Redbelly Network's** compliant blockspace, we eliminate scams, fake profiles, and payment disputes.

Unlike Web2 platforms (Upwork, Fiverr), VeriPact uses **On-Chain Identity** and **Accountable Escrow** to guarantee that:
1. Every freelancer is a **Verified Human** (No bots).
2. Professional credentials (Lawyers, Accountants) are **Cryptographically Verified**.
3. Payments are secured by **Audited Smart Contracts**.

---

## 🔐 Security Strategy
Because VeriPact holds user funds in Escrow, security is our #1 priority.
* **Non-Custodial:** The platform never holds keys; funds are locked in smart contracts accessible only via logic gates (Completion or Arbitration).
* **Third-Party Audit:** We are allocating grant funding to perform a full external audit of `VeriPact_Escrow.sol` before Mainnet deployment.
* **Redbelly Compliance:** We strictly adhere to Redbelly's Accountability framework to prevent illicit transaction flows.

---

## 🏗 Architecture & Features

### 1. Dual-Path Reputation System
We recognize that trust comes in two forms: **Credentials** and **Performance**.
* **Certified Path:** For regulated industries (Legal, Finance). Users connect their Redbelly ID to verify off-chain licenses.
* **Earned Path:** For creative industries (Design, Dev). A "Skill Mining" protocol where successful jobs mint **Soulbound Tokens (SBTs)** to the user's wallet.

### 2. Accountable Escrow
Payments are held in a smart contract vault.
* **Happy Path:** Client approves work -> Funds released instantly.
* **Dispute Path:** Client rejects work -> "Accountability Tribunal" (high-rep users) reviews the chat/files and votes on the outcome.

---

## 🛠 Tech Stack (Planned)
* **L1:** [Redbelly Network](https://www.redbelly.network/) (EVM Compatible)
* **Smart Contracts:** Solidity (OpenZeppelin Secured)
* **Identity:** Redbelly ID Layer (Verifiable Credentials)
* **Frontend:** Next.js + Wagmi
* **Storage:** IPFS (For job deliverables)

## 🗺 Roadmap

| Phase | Milestone | Description |
| :--- | :--- | :--- |
| **Phase 1** | **Core Contracts** | Development of Escrow & Reputation SBT contracts. |
| **Phase 2** | **Integration** | Connecting Redbelly ID for "One-Click Verification". |
| **Phase 3** | **Security Audit** | **External Smart Contract Audit** & Testnet "Apprentice" Beta. |
| **Phase 4** | **Launch** | Mainnet deployment in the Nigerian market. |

---

## 📬 Contact
* **Lead Developer:** [Sodiq Oluwatoki / github.com/Zeeknow]
* **Project Status:** Applying for Redbelly Grants Program (Dec 2025)
