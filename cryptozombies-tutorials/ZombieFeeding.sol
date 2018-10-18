pragma solidity ^0.4.25;

import "./ZombieFactory.sol";

contract KittyInterface {

  // To simulate zombie eating the CryptoKitty, reads the CryptoKitties data
  // from variable `genes` in function getKitty().
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  ); // end of function getKitty()
} // end of contract KittyInterface{}

// ZombieFeeding.sol inherits from ZombieFactory.sol (previously Contract.sol)
contract ZombieFeeding is ZombieFactory {

  // Declares variable `kittyContract` from contract KittyInterface{}
  KittyInterface kittyContract;

  // This will be used in functions to make sure user owns the zombie.
  modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  } // end of modifier ownerOf()

  // Function setKittyContractAddress() will allow us to setKittyContractAddress
  // and change the CryptoKitties contract address in the future if necessary.
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  } // end of function setKittyContractAddress()

  // Internal function _triggerCooldown() will take argument '_zombie', a Zombie storage pointer.
  // I think argument '_zombie' will be particular to ownly this function.
  function _triggerCooldown(Zombie storage _zombie) internal {
    // Sets when the zombie will be able to attack.
    _zombie.readyTime = uint32(now + cooldownTime);
  } // end of function _triggerCooldown()

  // Internal view function _isReady() will also take a Zombie storage argument
  // named _zombie and returns a bool.
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      // Returns if enough time has passed since the last time the zombie attacked.
      return (_zombie.readyTime <= now);
  } // end of function _isReady()

  // Function is internal so users can't call this function with any DNA they want.
  // Modifier ownerOf(_zombieId) makes sure user owns the zombie of '_zombieId'.
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal onlyOwnerOf(_zombieId) {

    // Declares local `Zombie` struct named `myZombie` (storage pointer).
    // Sets variable to be equal to index _zombieId in our `zombies` array.
    Zombie storage myZombie = zombies[_zombieId];

    // Require _isReady() passes 'myZombie'. User can only execute function feedAndMultiply()
    // if a zombie's cooldown time is over.
    require(_isReady(myZombie));

    // First we need to make sure that _targetDna isn't longer than 16 digits.
    // To do this, we can set _targetDna equal to _targetDna % dnaModulus to only take the
    // last 16 digits.
    _targetDna = _targetDna % dnaModulus;

    // Next our function should declare a uint named newDna, and set it equal to
    // the average of myZombie's DNA and _targetDna (as in the example above).
    uint newDna = (myZombie.dna + _targetDna) / 2;

    // Compares the keccak256 hashes of `_species` and the string "kitty"
    if (keccak256(_species) == keccak256("kitty")){
      // Replaces the last 2 digits of DNA with 99 if species is a kitty.
          // Example: Assume newDna is 334455.
          // Then newDna % 100 is 55, so newDna - newDna % 100 is 334400.
          // Finally add 99 to get 334499.
      newDna = newDna - newDna % 100 + 99;
    } //end if _species == "kitty"

    // Calls function _createZombie from ZombieFactory.sol with parameters
    // "NoName" as name and averaged `newDna` as Dna. Note: no _underscores because
    // these are public variables. Also not sure why DNA isn't all caps here.
    _createZombie("NoName", newDna);

    // Feeding triggers the zombie's cooldown time.
    _triggerCooldown(myZombie);

  } // end of function feedAndMultiply()

  // Public function `feedOnKitty` will take 2 uint parameters, `_zombieId` and
  // `_kittyId`.
  function feedOnKitty(uint _zombieId, uint _kittyId) public {

    // Declare integer `kittyDna`.
    uint kittyDna;

    // Calls function kittyContract.getKitty() with _kittyId.
    //    * Stores genes in kittyDna.
    //    * getKitty() returns 10 variables, we only want the 10th, `genes`.
    //    * `genes` will be saved as `kittyDna`.
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);

    // Calls function `feedAndMultiply` passing variables `_zombieId` and `kittyDna`.
    // Appends parameter "kitty" to the end.
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  } // end of function feedOnKitty()
} // end of contract ZombieFeeding{}
