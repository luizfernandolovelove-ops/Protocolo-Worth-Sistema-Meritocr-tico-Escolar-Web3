# Protocolo-Worth-Sistema-Meritocr-tico-Escolar-Web3
O Protocolo Web3 Worth consiste no gerenciamento do token WRTH e de NFTs a fim de estabelecer uma meritocracia digital e confiável em uma escola.

# ✨ Worth Protocol

Sistema de incentivo educacional baseado em blockchain que recompensa alunos por mérito, participação e governança escolar.

## 📌 Visão Geral

O **Worth Protocol** é um ecossistema descentralizado composto por:

- 💰 Token ERC-20 de mérito (WRTH)
- 📈 Sistema de Staking com recompensas dinâmicas
- 🗳️ Governança DAO para decisões escolares
- 🏆 NFTs de certificados de contribuição

---

## 🧱 Arquitetura

### 1. 🪙 WorthToken
Token ERC-20 com controle de acesso.

- Mint controlado pela escola (`MINTER_ROLE`)
- Burn habilitado
- Baseado em OpenZeppelin

📄 Arquivo: `WorthToken.sol`

---

### 2. 📈 WorthStaking
Sistema de staking com recompensas baseadas em tempo + oráculo.

- Stake de tokens WRTH
- Recompensas calculadas com Chainlink
- Proteção contra reentrância

📄 Arquivo: `WorthStaking.sol`

---

### 3. 🗳️ WorthGovernance
Sistema DAO para votação estudantil.

- Propostas via IPFS
- Tipos de votação:
  - Livre
  - Restrita
  - Opções (A/B)
- Poder de voto baseado no saldo de tokens

📄 Arquivo: `WorthGovernance.sol`

---

### 4. 🏆 ContribuitionNFT
NFTs para certificados escolares.

- Emitidos pela escola
- Metadados via IPFS
- Controle por role

📄 Arquivo: `ContribuitionNFT.sol`

---

## ⚙️ Tecnologias

- Solidity ^0.8.20
- OpenZeppelin
- Chainlink (Price Feed)
- Ethers.js
- TailwindCSS

---

## 🔗 Integração Frontend

O frontend permite:

- Conectar carteira (MetaMask)
- Stake de tokens
- Visualizar saldo
- Criar propostas
- Votar

---

## ⚠️ Problemas Conhecidos

- Algumas funções do frontend não correspondem ao ABI atual
- Funções como `claim()` e `getLatestETHPrice()` não existem no contrato
- DAO frontend usa nomes errados de funções

---

## 🚀 Roadmap

- [ ] Implementar função withdraw no staking
- [ ] Adicionar claim de recompensas
- [ ] Melhorar UI/UX
- [x] Deploy em testnet (Sepolia)
- [x] Integração completa com IPFS

---

## 👨‍💻 Autor

Projeto acadêmico focado em Web3 e educação descentralizada.
