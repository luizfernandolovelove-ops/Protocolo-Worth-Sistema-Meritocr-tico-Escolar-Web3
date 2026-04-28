// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// ContribuitionNFT
// Contrato de NFTs para certificados de contribuição escolar.

contract ContribuitionNFT is ERC721, ERC721URIStorage, AccessControl {
    uint256 private _nextTokenId;
    
    // Role para quem pode emitir certificados (Equipe Pedagógica)
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(address defaultAdmin, address schoolAddress) 
        ERC721("Worth Badge", "WRTH-NFT") 
    {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(MINTER_ROLE, schoolAddress);
    }

    // Emite um novo certificado de evento para um aluno.
    // Link do metadado (IPFS) contendo a imagem e detalhes do certificado.
    function issueCertificate(address student, string memory uri) 
        public 
        returns (uint256) 
    {
        // Apenas endereços autorizados podem emitir certificados
        require(hasRole(MINTER_ROLE, msg.sender), "Apenas autorizados podem emitir NFTs");

        uint256 tokenId = _nextTokenId++;
        _safeMint(student, tokenId);
        _setTokenURI(tokenId, uri);

        return tokenId;
    }

    // As funções abaixo são overrides necessários pelo Solidity ao usar ERC721URIStorage e AccessControl
    // para evitar conflitos de herança múltipla

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}