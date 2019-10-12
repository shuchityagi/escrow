pragma solidity ^0.5.1;

import "./StandardToken.sol";
import "./../Ownable.sol";
// import "../../math/SafeMath.sol";
// import "../../utils/Address.sol";
/**
 * @title TokenAsset
 * @dev The TokenAsset is the ERC223 token which is Ownable
 * This contract is used to deploy a new asset each time.
 */


contract TokenAsset is StandardToken, Ownable {
    
    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, uint256 _expiry)
    public
    {
        owner = msg.sender;
        symbol = _symbol;
        name = _name;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
    }
}