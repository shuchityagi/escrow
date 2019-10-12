pragma solidity ^0.5.1;
import "./../Ownable.sol";

contract TokenSupport is Ownable {
    
    // List of all supported tokens
    mapping (address => bool) internal supportedTokens;

    /* @dev add custom supported tokens by passing there network addresses.
    *  @param token : The network address of the token to support.
    */
    function addToken(address token, bool status)
    public
    onlyOwner
    {
        supportedTokens[token] = status;
    }

    function supportsToken(address token)
    public
    view
    returns (bool)
    {
        return supportedTokens[token];
    }
}