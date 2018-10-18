var FootwearVerify = artifacts.require("./FootwearVerify.sol");

contract('FootwearVerify', function(accounts) {
  
  let myContract;
  let owner       = accounts[0];
  let nonOwner    = accounts[1];
  let catchRevert = require("./exceptions.js").catchRevert;

  it("should mint a new token", async () => {
    let test = "sku: 12345, size: 9.5, nid: 67890";
    let foot = await FootwearVerify.deployed();
    await foot.mintFootwear(owner, "sku: 12345, size: 9.5, nid: 67890", {from: owner});
    let data = await foot.tokenURI(1);
    assert.equal(data, test, "token doesn't match");
 });
 



describe("check only users with permission can mint", function() {
  before(async function() {
      myContract = await FootwearVerify.deployed();
  });
  it("should abort with an error", async function() {
      await catchRevert(myContract.mintFootwear(nonOwner, "{sku: 12345, size: 9.5, nid: 67890}", {from: nonOwner}));
  });
});

});


