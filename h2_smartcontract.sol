// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// se utiliza tokens ERC20 de Open Zeppelin, con la opción de que sean Burnable.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract GreenHydrogenContract is ERC20, ERC20Burnable {
    
    // cambiar por las address a utilizar antes de desplegar el contrato
    address producer_address = 0x0531262Ef42AF2d1aC21f2058022C9e65f35867F;
    address transporter_address = 0xb4b2d0Cb2426175a25922E7D3954cac314F99fB5;
    address consumer_address = 0x6F6c6D9868d452EC580fC1422f47776a5C73676F;

    constructor() ERC20("GreenHydrogenToken!", "GHT!") {}

    function mint(address to, uint256 amount) internal {
        _mint(to, amount);
    }

    struct TRU{
        uint id; // id = orden en la lista "allTRU"
        string[] owner; // propietario del activo.
        string[] holder; // persona física que porta el asset. Un ejemplo es el transportista.
        string hydrogenType; // "green", "yellow", "pink".
        string assetState; // Hidrógeno ("H") o amoníaco ("NH3"). 
        uint quantity; // masa total efectiva de Hidrógeno en el lote.
    }

    TRU[] public allTRU;
    
    modifier requirement_msg_sender(address _address){
        require(
            msg.sender == _address
            );
        _;
    }

    modifier requirement_TRU(uint _id, string memory _attribute, string memory _type) {
        if (keccak256(abi.encodePacked((_attribute))) == keccak256(abi.encodePacked(("owner")))) {
            require(
                keccak256(abi.encodePacked((allTRU[_id].owner[allTRU[_id].owner.length-1])))
                == keccak256(abi.encodePacked((_type)))
                );

        } else if (keccak256(abi.encodePacked((_attribute))) == keccak256(abi.encodePacked(("holder")))){
            require(
                keccak256(abi.encodePacked((allTRU[_id].holder[allTRU[_id].holder.length-1])))
                == keccak256(abi.encodePacked((_type)))
                );
        }
        _;
    }

    function createTRU(string memory _hydrogenType, string memory _assetState, 
        uint _quantity) external requirement_msg_sender (producer_address) {

	    require(
	            keccak256(abi.encodePacked((_hydrogenType))) == keccak256(abi.encodePacked(("green"))) || 
	            keccak256(abi.encodePacked((_hydrogenType))) == keccak256(abi.encodePacked(("yellow"))) ||
	            keccak256(abi.encodePacked((_hydrogenType))) == keccak256(abi.encodePacked(("pink")))
    	            );

	    require(
	            keccak256(abi.encodePacked((_assetState))) == keccak256(abi.encodePacked(("H"))) ||
	            keccak256(abi.encodePacked((_assetState))) == keccak256(abi.encodePacked(("NH3")))
	            );  
	
	    string[] memory _producer = new string[](1);
	    _producer[0] = "producer";

	    allTRU.push(TRU(allTRU.length,_producer,_producer,_hydrogenType, _assetState, _quantity));

    }
     
    function getTRUowner(uint _id) external view returns(string[] memory){
            return allTRU[_id].owner;
    }

    function getTRUholder(uint _id) external view returns(string[] memory){
            return allTRU[_id].holder;
    }

    function getTRUquantity() external view returns(uint){
            return allTRU.length;
    }

    function soldTRU(uint _id) external requirement_msg_sender(producer_address) 
        requirement_TRU(_id, "owner","producer"){
            allTRU[_id].owner.push("consumer");
    }

    function sendTRUtransporter(uint _id) external requirement_msg_sender(producer_address) 
        requirement_TRU(_id, "owner","consumer") requirement_TRU(_id, "holder ","producer") {
            allTRU[_id].holder.push("transporter");
    }

    function sendTRUconsumer(uint _id) external requirement_msg_sender(transporter_address) 
        requirement_TRU(_id, "owner","consumer") requirement_TRU(_id, "holder ","transporter") {
            allTRU[_id].holder.push("consumer");

            if (keccak256(abi.encodePacked(allTRU[_id].hydrogenType)) == keccak256(abi.encodePacked(("green")))){
                mint(consumer_address, 100 * 10**18 * allTRU[_id].quantity);
            }
    }

    function utilizeHydrogen(uint _id) external requirement_msg_sender(consumer_address) {
            allTRU[_id].assetState = "utilized";
            burn(100 * 10**18 * allTRU[_id].quantity);
    }
}
