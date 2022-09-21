// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/* 
se importa las librerias de OpenZeppelin, para poder obtener una implementación 
segura y auditada. El paquete ERC20Burnable agrega una funcionalidad nueva, que 
permite eliminar tokens anteriormente creados
*/
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract TokenProofContract is ERC20, ERC20Burnable {

    /* 
    se realiza una emisión de 1000 tokens en el pomento que se despliega
    el contrato inteligente
    */ 
    constructor() ERC20("TokenProof!", "TP!") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    /*
    Se permite la funcionalidad de crear tokens on demand
    */
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

}
