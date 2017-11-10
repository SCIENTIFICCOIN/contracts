pragma solidity ^0.4.13;

import './SCNCToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract  SCNCCrowdsale  is  Crowdsale  {
    using SafeMath for uint256;
    
    mapping (address => uint256) deposited;
    event Refunded(address indexed beneficiary, uint256 weiAmount);
    event Deposited(address indexed beneficiary, uint256 weiAmount);

    function  SCNCCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)  
        Crowdsale(_startTime, _endTime, _rate, _wallet) {        
    }

    function createTokenContract() internal returns (MintableToken) {
        return new SCNCToken();
    }

    function deposit() public payable {
        require(validPurchase());
        deposited[msg.sender] = deposited[msg.sender].add(msg.value);
        Deposited(msg.sender, msg.value);
    }

    function invest(uint256 _value) public returns (uint256) {
        require(now >= startTime && now <= endTime);
        require(_value <= deposited[msg.sender]);
        uint256 tokens = _value.mul(rate);
        tokens = tokens + tokens/5;
        weiRaised = weiRaised.add(_value);
        deposited[msg.sender] = deposited[msg.sender].sub(_value);
        token.mint(msg.sender, tokens);
        wallet.transfer(_value);
        TokenPurchase(msg.sender, msg.sender, _value, tokens);
        return deposited[msg.sender];
    }

    function refund() public {
        require(deposited[msg.sender] > 0);
        uint256 depositedValue = deposited[msg.sender];
        deposited[msg.sender] = 0;
        msg.sender.transfer(depositedValue);
        Refunded(msg.sender, depositedValue);
    }

}