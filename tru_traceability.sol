// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GreenHydrogenContract{
    
    address producer_address = 0x0531262Ef42AF2d1aC21f2058022C9e65f35867F;

    struct TRU{
        uint id; // id = orden en la lista allTRU
        string owner; // propietario
        string holder; // persona física que conserva el asset. Transportista por ejemplo.
        string hydrogenType;// green, yellow, pink.
        string assetState; // Hidrógeno o amoníaco. 
        uint quantity; // masa total del lote de Hidrógeno.
        // uint timestamp?
        // algún otro atributo?
    }

    TRU[] public allTRU;

    function createTRU(string memory _hydrogenType, string memory _assetState, 
                       uint _quantity)public{
     // require(msg.sender == producer_address);
        require((keccak256(abi.encodePacked((_hydrogenType))) == keccak256(abi.encodePacked(("green")))) || 
                (keccak256(abi.encodePacked((_hydrogenType))) == keccak256(abi.encodePacked(("yellow")))) ||
                (keccak256(abi.encodePacked((_hydrogenType))) == keccak256(abi.encodePacked(("pink")))));

        require((keccak256(abi.encodePacked((_assetState))) == keccak256(abi.encodePacked(("pure")))) ||
                (keccak256(abi.encodePacked((_assetState))) == keccak256(abi.encodePacked(("ammonia"))))); // amoníaco 
        
        allTRU.push(TRU(allTRU.length,"Producer","Producer",_hydrogenType, 
                        _assetState, _quantity));
    }

   // function getTRU_owner(uint _id) public view returns(string memory){
    //        return allTRU[_id]["owner"];
    //}
}
