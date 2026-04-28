// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./WorthToken.sol";

contract WorthGovernance is AccessControl {
    bytes32 public constant SCHOOL_ROLE = keccak256("SCHOOL_ROLE");
    WorthToken public token;

    enum TipoDaVotacao {Livre, Restrito, Opcoes}

    struct Proposta {
        string descricao;
        TipoDaVotacao tipo;
        uint256 fimVotacao;
        bool executada;
        uint256 votosFavor; // Para Livre/Restrito
        uint256 votosContra; // Para Livre/Restrito
        mapping(uint256 => uint256) votosOpcoes; // Para o tipo 'Opcoes'
        uint256 numOpcoes; // Limite de opções de voto estabelecido pela escola. Para o tipo 'Opcoes'
        mapping(address => bool) jaVotou;
    }

    uint256 public totalPropostas;
    mapping(uint256 => Proposta) public propostas;

    constructor(address _tokenAddress, address _schoolAddress) {
        token = WorthToken(_tokenAddress);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(SCHOOL_ROLE, _schoolAddress);
    }

    /*
    A escola cria uma proposta aberta para os alunos votarem.
    O TipoDaVotacao define se a proposta é de tema livre, retrito ou se a votacao
    está fechada a opções predefinidas.
    */
    //O ipfsHash aponta para um JSON com: título, descrição longa e opções.
    function criarProposta(
        string memory _ipfsHash, 
        TipoDaVotacao _tipo, 
        uint256 _duracao,
        uint256 _numOpcoes
    ) external onlyRole(SCHOOL_ROLE) {
        uint256 id = totalPropostas++;
        Proposta storage p = propostas[id];
        
        // Armazenar apenas o ponteiro (CID) economiza muito gas
        p.descricao = _ipfsHash; 
        p.tipo = _tipo;
        p.numOpcoes = _numOpcoes;
        p.fimVotacao = block.timestamp + _duracao;
    }

    /*
     Aluno vota utilizando seu saldo de tokens Worth como poder de voto.
     */
    function votar(uint256 _propostaId, bool _apoia, uint256 _opcaoId) external {
        Proposta storage p = propostas[_propostaId];
        require(_opcaoId < p.numOpcoes, "Opcao de voto invalida");
        require(block.timestamp < p.fimVotacao, "Votacao encerrada");
        require(!p.jaVotou[msg.sender], "Voce ja votou");

        uint256 poderVoto = token.balanceOf(msg.sender);
        require(poderVoto > 0, "Sem tokens para votar");

        if (p.tipo == TipoDaVotacao.Opcoes) {
            p.votosOpcoes[_opcaoId] += poderVoto;
        } else {
            if (_apoia) p.votosFavor += poderVoto;
            else p.votosContra += poderVoto;
        }

        p.jaVotou[msg.sender] = true;
    }
}