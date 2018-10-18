import Web3  from 'web3';
import artifacts from './contracts/FootwearVerify.json';
import Provider from 'truffle-privatekey-provider';
var privateKey = "";
var account ='';

const getProvider = () => {
    return new Provider(privateKey, "https://rinkeby.infura.io/v61hsMvKfFW08T9q4Msu")
}

// function that returns a new web3 contract instance
const getContract = () => {
    let provider = getProvider();
    let web3 = new Web3(provider);
    let contractAddress = "0xb9a14853baec7e8cfbd4b3ec2e3fbfc3b17fe7a6";	
    let contract = new web3.eth.Contract(artifacts.abi, contractAddress);
    contract.options.gasPrice = 2000000000;
    
    return contract
}
// example function that creates a new footwear token
 export const mintToken = (details) => {
    const foot = getContract();
    console.log('creating token');
   
    // foot.methods.mintFootwear(details).send({from: account})
    // .then(function(receipt){
    //     console.log(receipt);
    // });

    foot.methods.mintFootwear(details)
    .send({from: account})
    .on('transactionHash', function(hash){
    console.log(hash);
     })
    .on('confirmation', function(confirmationNumber, receipt){
    console.log(confirmationNumber);
     })
    .on("receipt", function(receipt) {
        // result object contains import information about the transaction
        console.log(receipt.tx);
      })
    .on("error", function(error){
        console.log(error);
    })
      

}

export default mintToken;
