const SCNCCrowdsale = artifacts.require("./SCNCCrowdsale.sol")

// var SCNCToken = artifacts.require("SCNCToken");

module.exports = function(deployer, network, accounts) {
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1000; // one second in the future
  const endTime = parseInt(new Date('2018/2/28').getTime()/1000);
  const rate = new web3.BigNumber(300);
  const wallet = accounts[0];
  deployer.deploy(SCNCCrowdsale, startTime, endTime, rate, wallet);
};