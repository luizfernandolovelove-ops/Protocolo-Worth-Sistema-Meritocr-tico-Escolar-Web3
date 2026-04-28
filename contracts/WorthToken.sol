// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//Importando biblioteca do OpenZeppelin para ERC-20 e Controle de Acesso
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Token de mérito escolar com controle de acesso para a escola

contract WorthToken is ERC20, ERC20Burnable, AccessControl {
    // Função dada apenas para a conta da escola
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(address defaultAdmin, address schoolAddress) ERC20("Worth", "WRTH") {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(MINTER_ROLE, schoolAddress);
    }

    //Função para recompensar alunos por mérito
    function mintByMerit(address to, uint256 amount) public {
        // Apenas quem tem a MINTER_ROLE (a Escola) pode chamar esta função
        require(hasRole(MINTER_ROLE, msg.sender), "Apenas a escola pode emitir Worth");
        _mint(to, amount);
    }
}