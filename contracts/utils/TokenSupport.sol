pragma solidity ^0.5.11;
import "./../Ownable.sol";

contract TokenSupport is Ownable {
    struct Tkn {
        address addr;
        address sender;
        uint256 value;
        bytes data;
        bytes4 sig;
    }
    Tkn tkn;
    
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

    function getSig(bytes memory _data)
    public
    returns (bytes4 sig)
    {
        uint l = _data.length < 4 ? _data.length : 4;
        for (uint i = 0; i < l; i++) {
            sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));
        }
    }
}