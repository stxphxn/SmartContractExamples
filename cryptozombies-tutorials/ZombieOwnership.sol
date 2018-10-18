pragma solidity ^0.4.25;

import "./ZombieAttack.sol";
import "./ERC721.sol";

// Practice for natspec compliant comments
/// @title A contract that manages zombie ownership
/// @author Jordan (via CryptoZombies Tutorial)
/// @dev Compliant with OpenZeppelin's implementation of the ERC721 spec draft
contract ZombieOwnership is ZombieAttack, ERC721 {

  using SafeMath for uint256;

  // Used to check who is approved to take the token when user calls takeOwnership(),
  // passing _tokenId. 'Uint' will be the token.
  mapping (uint => address) zombieApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    // ownerZombieCount[] mapping is from Contract ZombieFactory {}.
    return ownerZombieCount[_owner];
  } // end of function balanceOf()

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    // zombieToOwner[] mapping is from Contract ZombieFactory {}.
    return zombieToOwner[_tokenId];
  } // end of function ownerOf()

  function _transfer(address _from, address _to, uint256 _tokenId) private {
      ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
      ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);

      // Changes the zombieToOwner mapping [from Contract ZombieFactory {}] for this
      // so for every '_tokenId' zombie, the mapping shows '_to' owner.
      zombieToOwner[_tokenId] = _to;

      // Fires 'Event Transfer' in ERC721.sol
      Transfer(_from, _to, _tokenId);
  } // end of function _transfer() private {}

  function transfer(address _to, uint256 _tokenId) onlyOwnerOf(_tokenId) public {
    // Public function transfer() is restricted to msg.sender.
    // transfer() calls private function _transfer(), restricted to callable by
    // functions within this contract.
    _transfer(msg.sender, _to, _tokenId);
  } // end of function transfer() public {}

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to; // Token(s) can only be sent to '_to' for a given approved '_tokenId'.
    Approval(msg.sender, _to, _tokenId); // Syntax from ERC721.sol.
  } // end of function approve();

  function takeOwnership(uint256 _tokenId) public {
    // Tests to make msg.sender is approved to take the ERC721 token
    // If test passes, call function '_transfer'.
    require(zombieApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);

    _transfer(owner, msg.sender, _tokenId);
  } // end of function takeOwnership()
} // end of Contract ZombieOwnership {}
