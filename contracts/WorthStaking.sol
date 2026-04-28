// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


//Import das bibliotecas da OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Import da Chainlink
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract WorthStaking is ReentrancyGuard, Ownable {
    IERC20 public worthToken;
    AggregatorV3Interface internal priceFeed;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;
    
    // Eventos para o Frontend escutar
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 reward);

    constructor(address _tokenAddress, address _priceFeed) Ownable(msg.sender) {
        worthToken = IERC20(_tokenAddress);
        // Oráculo da Chainlink
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    // Aluno deposita seus tokens Worth para ganhar "Prestígio"
    function stake(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Valor precisa ser maior que zero");
        
        // Transfere os tokens do aluno para o contrato
        worthToken.transferFrom(msg.sender, address(this), _amount);
        
        stakes[msg.sender] = Stake({
            amount: _amount,
            timestamp: block.timestamp
        });

        emit Staked(msg.sender, _amount);
    }

    // Consulta o Oráculo para ver o "preço do mérito" e ajusta a recompensa do aluno.
    function calcularRecompensa(address _aluno) public view returns (uint256) {
        Stake storage alunoStake = stakes[_aluno];
        if (alunoStake.amount == 0) return 0;

        // Pega o preço atual via Oráculo (Etapa 4)
        (, int price, , , ) = priceFeed.latestRoundData();
        uint256 multiplier = uint256(price / 1e8); // Ajuste de decimais

        uint256 tempoPassado = block.timestamp - alunoStake.timestamp;
        
        // Lógica: Recompensa = (Quantidade * Tempo * Preço do Oráculo) / Constante
        return (alunoStake.amount * tempoPassado * multiplier) / 1000;
    }

    // Função de Saída (Withdraw) seria implementada aqui...
}