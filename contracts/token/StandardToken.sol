pragma solidity ^0.5.1;
import "../math/SafeMath.sol";
import "./VIP180.sol";
import "./IERC223.sol";
import "./ERC223Receiver.sol";
import "./../utils/Address.sol";

contract StandardToken is VIP180, IERC223 {

    using SafeMath for uint;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    event Burn(address indexed burner, uint256 value);

    function name()
        public
        view
        returns (string memory) {
        return _name;
    }

    function symbol()
        public
        view
        returns (string memory) {
        return _symbol;
    }

    function decimals()
        public
        view
        returns (uint8) {
        return _decimals;
    }

    function totalSupply()
        public
        view
        returns (uint256) {
        return _totalSupply;
    }

     /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _value uint256 the amount of tokens to be transferred
    */
    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        require(_to != address(0),"Receiver's address is required.");
        require(_value <= balances[_from],"Insufficient balance.");
        require(_value <= allowed[_from][msg.sender],"Insufficient Allowance.");
        balances[_from] = SafeMath.sub(balances[_from], _value);
        balances[_to] = SafeMath.add(balances[_to], _value);
        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    *
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param _spender The address which will spend the funds.
    * @param _value The amount of tokens to be spent.
    */
    function approve(address _spender, uint _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param _owner address The address which owns the funds.
    * @param _spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    /**
    * approve should be called when allowed[_spender] == 0. To increment
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    */
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    /**
      * @dev Transfer the specified amount of tokens to the specified address.
      *      Invokes the `tokenFallback` function if the recipient is a contract.
      *      The token transfer fails if the recipient is a contract
      *      but does not implement the `tokenFallback` function
      *      or the fallback function to receive funds.
      *
      * @param _to    Receiver address.
      * @param _value Amount of tokens that will be transferred.
      * @param _data  Transaction metadata.
      */
    function transfer(address _to, uint _value, bytes memory _data) public  returns (bool){
        require(_value > 0, "Value should be greater than zero.");
        if(Address.isContract(_to)) {
            ERC223Receiver receiver = ERC223Receiver(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        balances[msg.sender] = SafeMath.sub(balances[msg.sender],_value);
        balances[_to] = SafeMath.add(balances[_to],_value);
        emit Transfer(msg.sender, _to, _value, _data);
        return true;
    }

    /**
    * @dev Transfer the specified amount of tokens to the specified address.
    *      This function works the same with the previous one
    *      but doesn't contain `_data` param.
    *      Added due to backwards compatibility reasons.
    *
    * @param _to    Receiver address.
    * @param _value Amount of tokens that will be transferred.
    */
    function transfer(address _to, uint _value) public  returns (bool) {
        return transfer(_to, _value, "");
    }

    /**
    * @dev Burns a specific amount of tokens.
    * @param _value The amount of token to be burned.
    */
    function burn(uint256 _value) public {
        require(_value <= balances[msg.sender],"Insufficient balance.");
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        address burner = msg.sender;
        balances[burner] = SafeMath.sub(balances[burner],_value);
        _totalSupply = SafeMath.sub(_totalSupply,_value);
        emit Burn(burner, _value);
    }

}