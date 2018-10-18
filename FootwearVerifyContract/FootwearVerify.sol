pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "openzeppelin-solidity/contracts/access/roles/MinterRole.sol";

contract FootwearVerify is ERC721Full, MinterRole {
    constructor (string _name, string _symbol) public ERC721Full(_name, _symbol)
    {
    }
    event NewFootwear( uint tokenId, string owner, string tokenURI);

    function mintFootwear(
        string  _tokenURI
    ) public
    onlyMinter
    {
        uint256 newTokenId = _getNextTokenId();
        super._mint(msg.sender, newTokenId);
        super._setTokenURI(newTokenId, _tokenURI);
	NewFootwear( newTokenId, msg.sender, _tokenURI);
    }

    function _getNextTokenId() private view returns (uint256) {
        return totalSupply().add(1); 
    }

     // Function getFootwearByOwner() will return a user's entire footwear collection, uint[] (an array of uint variables).
    function getFootwearByOwner(address _owner) external view returns(uint[]) {

    // Declares a uint[] memory variable 'result'. This new uint array will be
    // declared of length equal to how many trainers the user owns. Generic declaration for 3 items:
    //      uint[] memory values = new uint[](3);
    uint[] memory result = new uint[](balanceOf(_owner));
        uint counter = 0;
        for (uint i = 0; i < totalSupply(); i++) {
            if (ownerOf(i) == _owner) {
            // Adds the footwear ID to the result array by setting result[counter] equal to i.
            result[counter] = i;
            counter++;
            } 
        } 
        return result;
    } // end of function getFootwearByOwner()
}
