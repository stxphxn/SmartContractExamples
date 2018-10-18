/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".

  Below is the Ownable contract taken from the OpenZeppelin Solidity library.
  OpenZeppelin is a library of secure and community-vetted smart contracts that
  you can use in your own DApps. After this lesson, we highly recommend you check
  out their site to further your learning!

  Give the contract below a read-through. You're going to see a few things we
  haven't learned yet, but don't worry, we'll talk about them afterward.
 */

/*
So the Ownable contract basically does the following:

  1) When a contract is created, its constructor sets the owner to msg.sender
  (the person who deployed it)

  2) It adds an onlyOwner modifier, which can restrict access to certain functions
  to only the owner

  3) It allows you to transfer the contract to a new owner

onlyOwner is such a common requirement for contracts that most Solidity DApps start
with a copy/paste of this Ownable contract, and then their first contract inherits from it.

Since we want to limit setKittyContractAddress() to onlyOwner, we're going to do the
same for our contract.
*/

 // Constructors: function Ownable() is a constructor, which is an optional special
 // function that has the same name as the contract. It will get executed only one
 // time, when the contract is first created.

pragma solidity ^0.4.25;

contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.

    Function Modifiers: modifier onlyOwner(). Modifiers are kind of half-functions
    that are used to modify other functions, usually to check some requirements
    prior to execution. In this case, onlyOwner can be used to limit access so only
    the owner of the contract can run this function. We'll talk more about function
    modifiers in the next chapter, and what that weird _; does.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}
