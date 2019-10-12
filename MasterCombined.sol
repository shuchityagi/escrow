pragma solidity ^0.5.1;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}



/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
}

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
 * directly accessed.
 */
library Counters {
    using SafeMath for uint256;

    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        // The {SafeMath} overflow check can be skipped here, see the comment at the top
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}




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


/**
* @title VIP180 interface
*/

interface VIP180 {
  function balanceOf(address who) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool ok);
  function allowance(address owner, address spender) external view returns (uint256);
  function transferFrom(address from, address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @dev Interface of the ERC777Token standard as defined in the EIP.
 *
 * This contract uses the
 * [ERC1820 registry standard](https://eips.ethereum.org/EIPS/eip-1820) to let
 * token holders and recipients react to token movements by using setting implementers
 * for the associated interfaces in said registry. See `IERC1820Registry` and
 * `ERC1820Implementer`.
 */

contract IERC223 {
    /**
     * @dev Returns the total supply of the token.
     */
    uint public _totalSupply;
    
    /**
     * @dev Returns the balance of the `who` address.
     */
    function balanceOf(address who) public view returns (uint);
        
    /**
     * @dev Transfers `value` tokens from `msg.sender` to `to` address
     * and returns `true` on success.
     */
    function transfer(address to, uint value) public returns (bool success);
        
    /**
     * @dev Transfers `value` tokens from `msg.sender` to `to` address with `data` parameter
     * and returns `true` on success.
     */
    function transfer(address to, uint value, bytes memory data) public returns (bool success);

     /**
     * @dev Event that is fired on successful transfer.
     */
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
}


/*
Base class contracts willing to accept ERC223 token transfers must conform to.

Sender: msg.sender to the token contract, the address originating the token transfer.
          - For user originated transfers sender will be equal to tx.origin
          - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
Origin: the origin address from whose balance the tokens are sent
          - For transfer(), origin = msg.sender
          - For transferFrom() origin = _from to token contract
Value is the amount of tokens sent
Data is arbitrary data sent with the token transfer. Simulates ether tx.data

From, origin and value shouldn't be trusted unless the token contract is trusted.
If sender == tx.origin, it is safe to trust it regardless of the token.
*/

contract ERC223Receiver {
    function tokenFallback(address _sender, uint _value, bytes memory _data) public returns (bool ok);
}


contract StandardToken is VIP180, IERC223, Ownable {

    using SafeMath for uint;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    event Burn(address indexed burner, uint256 value);

    constructor(string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals, uint256 tokenTotalSupply)
    public
    {
        _owner = msg.sender;
        _symbol = tokenSymbol;
        _name = tokenName;
        _decimals = tokenDecimals;
        _totalSupply = tokenTotalSupply;
        balances[msg.sender] = _totalSupply;
    }

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


contract Escrow is ERC223Receiver{

    /** Address of the creator of the Escrow who is responsible for funding it. */
    address payable public creator;
    /** Address of the receiving party */
    address payable public receiver;
    /** Addresses of the validators involved */
    address[] public validators;
    /** The timestamp after which the escrow will expire*/
    uint public deadline;
    /** The amount of funds locked in the escrow*/
    uint public amountLocked;
    /** Minimum quorum required to reach a decision in case of a dispute*/
    uint public minimumVotesRequired;
    /** Maximum number of validators allowed */
    uint private maxValidatorsAllowed = 5;
    /** The contract address of the VIP180 token */
    address public tokenAddress;
    struct Tkn {
        address addr;
        address sender;
        uint256 value;
        bytes data;
    }
    /** Token tkn */
    Tkn public tkn;
    /** The token instance */
    StandardToken tokenInstance;
    /** Mapping of all transactions that were sent to the contract. */
    mapping (uint256 => Tkn) public transactions;
    /** The count of transactions loged in the contract */
    uint256 public transactionID = 0;

    /**
    * The escrow can in the following states
    * 1. Created : Default state when the contract is created.
    * 2. Locked : Once the receiver is satified with the terms of the escorw, they can choose to lock it.
    * 3. Inactive : The esscrow is rendered inactive once the funds are moved out of it (refund or withdraw).
    * 4. Disputed : In case of a dispute, either of the party can choose to move the escrow in this state to
    *    let the validators in.
    */
    enum State { Created, Locked, Inactive, Disputed }
	State public state;

    /** Vote count on the number of votes for a withdraw or refund */
    struct VoteCount {
        uint totalCall;
        mapping(address => bool) voter;
    }

    /**
    * Mapping for control limit call based on an action
    **/
    mapping(uint => VoteCount) public voteCountCallMapping;


    event EscrowLocked();
    event EscrowAborted();
    event Voted(string callToAction);
    event DisputeRaised();
    event Finalized(address _add, uint _amount);
    event LogTransaction(address _sender, address _origin, uint _value, bytes _data);

    /**
    * Payable constructor to set to state variables.
    */
    constructor(address payable _creator, address payable _receiver, address[] memory _validators, uint _minimumVotesRequired, uint _deadline, address _tokenAddress)
        public
    {
            require((_validators.length <= maxValidatorsAllowed) && (_validators.length > 0), "Invalid validator quorum.");
            require(_minimumVotesRequired % 2 != 0, "Minimum votes should be an odd number to avoid deadlock.");
            require(_minimumVotesRequired <= maxValidatorsAllowed,"Minimum votes required exceeds the total number of validators.");
            
            creator = _creator;
            validators = _validators;
            receiver = _receiver;
            deadline = _deadline;
            tokenAddress = _tokenAddress;
            minimumVotesRequired = _minimumVotesRequired;

            tokenInstance = StandardToken(tokenAddress);
	}

    /**@dev tokenFallback function is called by default when tokens are sent at the contract's address and burns them.
    *  tkn variable is analogue of msg variable of Ether transaction
    *  @param _sender is the token's address from which the transactions are originating.
    *  tkn.addr is the token's address from which the transactions are originating.
    *  @param _value the number of tokens that were sent   (analogue of msg.value)
    *  @param _data is data of token transaction   (analogue of msg.data)
    *  tkn.sig is 4 bytes signature of function
    *  if data of token transaction is a function execution
    **/

    function tokenFallback(address _sender, uint _value, bytes memory _data)
        public
        returns (bool ok)
    {
            // require(supportsToken(msg.sender),"The token is not supported");
            require(address(_sender) == address(creator),"Fund the token from the same account.");
            require(_value > 0, "Fund the account with appropriate amount");
            // // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
            tkn = Tkn(msg.sender, _sender, _value, _data);
            transactions[transactionID] = tkn;
            amountLocked = _value;
            emit LogTransaction(msg.sender,_sender,_value,_data);
            transactionID++;
    }

    modifier inState(State _state) {
    	require(state == _state, "Does not match the required state.");
    	_;
	}

    modifier onlyCreator() {
    	require(msg.sender == creator, "User not authorised.");
    	_;
	}

	modifier onlyReceiver() {
    	require(msg.sender == receiver, "User not authorised.");
    	_;
	}

    modifier onlyValidator() {
        for (uint i = 0; i < validators.length; i++) {
            if(validators[i]==msg.sender){
                _;
                return;
            }
        }
        revert("Unauthorized user");
	}

    modifier onlyMembers() {
    	require((msg.sender == receiver)||(msg.sender == creator), "User not authorised.");
    	_;
	}

    /**
    * Modifier to identify the call to action and to keep a track of number of votes
    * on each action. Actions can be withdraw or refund.
    * Code 0 : Represents withdraw action;
    * Code 1 : Represents refund action;
    */
    modifier callToAction(uint _code) {

        if(_code == 0) {
            emit Voted('Withdrawn');
            require(voteCountCallMapping[1].voter[msg.sender] == false,"Voter has already voted on another action");
        } else if(_code == 1){
            emit Voted('Refund');
            require(voteCountCallMapping[0].voter[msg.sender] == false,"Voter has already voted on another action");
        }

        require(voteCountCallMapping[_code].voter[msg.sender] == false,"Voter has already voted");
        if (voteCountCallMapping[_code].totalCall == minimumVotesRequired - 1) {
            _;
        }
        /** we increment value after, so this is a second call */
        voteCountCallMapping[_code].voter[msg.sender] = true;
        voteCountCallMapping[_code].totalCall++;
    }

    /**
    * Abort escrow
    *Can only be called by the escrow creator before the contract moves into
    * a locked state or after the contract has expired without getting into a dispute.
    * In both cases, the amount is automatically sent back to the creator.
    */
    function abortEscrow()
    	public
    	onlyCreator
	{
        if((state == State.Created) || (state == State.Locked && deadline < block.timestamp) ) {
            emit EscrowAborted();
    	    state = State.Inactive;
    	    creator.transfer(address(this).balance);
        } else revert("Incorrect state");
	}

    /**
    * Lock escrow
    * Once the receiver is satisfied with the terms of the escrow,
    * they can choose to lock it.
    */
    function lockEscrow()
    	public
        onlyReceiver()
    	inState(State.Created)
	{
    	emit EscrowLocked();
    	state = State.Locked;
	}

    /**
    * Update escrow
    * In case a transferFrom was used instead of the ERC223 functions,
    * the contract will not be able to call the tokenFallback(). To update the metrics of
    * the escrow, this function should be called after depositing the funds.
    */
    function updateEscrow()
    	public
        onlyCreator()
    	inState(State.Created)
	{
    	require(tokenInstance.balanceOf(address(this)) > 0, "Please fund the escrow first");
        amountLocked = tokenInstance.balanceOf(address(this));
	}


    /**
    * Release payment
    *Incase no dispute has been raised from either of the party till
    * the contract expires, any of them can pull the payment in the receiver's account.
    */
    function releasePayment()
        public
        onlyCreator()
        inState(State.Locked)
    {
        uint256 _balance = tokenInstance.balanceOf(address(this));
        require(_balance > 0,"Insufficient Balance");
        require(_balance == amountLocked,"Insufficient Balance.");
        emit Finalized(receiver,_balance);
        state = State.Inactive;
        tokenInstance.transfer(receiver,_balance);
    }


    /**
    * Raise dispute
    * Any member can choose to raise a dispute and move to let the validators
    * come into picture. Meanwhile the funds will be blocked even after the deadline.
    */
    function raiseDispute()
        public
        onlyMembers()
        inState(State.Locked)
    {
        require(deadline >= block.timestamp, "The Escrow has already expired");
        state = State.Disputed;
        emit DisputeRaised();
    }

    /**
    * Withdraw payout
    * only if minimum defined validators confirmed process
    */
    function withdraw()
        public
        onlyValidator
        inState(State.Disputed)
        callToAction(0)
        returns (bool)
    {
        uint256 _balance = tokenInstance.balanceOf(address(this));
        require(_balance > 0,"Insufficient Balance");
        require(_balance == amountLocked,"Insufficient Balance.");
        emit Finalized(receiver,_balance);
        state = State.Inactive;
        tokenInstance.transfer(receiver,_balance);
        return true;

    }

    /**
    * Refund payout
    * only if minimum defined validators confirmed process
    **/
    function refund()
        public
        onlyValidator
        inState(State.Disputed)
        callToAction(1)
        returns (bool)
    {

        uint256 _balance = tokenInstance.balanceOf(address(this));
        require(_balance > 0,"Insufficient Balance");
        require(_balance == amountLocked,"Insufficient Balance.");
        emit Finalized(creator,_balance);
        state = State.Inactive;
        tokenInstance.transfer(creator,_balance);
        return true;
    }
    /**
    * Returns the current stte of the escrow
    */
    function getState()
        internal
        view
        returns(State)
    {
        return(state);
    }
}



contract EscrowGenerator is TokenSupport{

    /** Struct to maintain the basic info in the contract.*/
    struct EscrowStruct {
        address contractAddress;
        address creator;
    }

    EscrowStruct[] private escrowContracts;
    /** Pointer to the last contract depoyed. Helps keep track incase of mass depolyment via scripts */
    address public lastContractAddress;
    /** Mapping Validator to the list of contracts he/she has been appointed to.*/
    mapping(address => address[]) public validatorMapping;
    
    event NewEscrowContract(address contractAddress);

	constructor()
        public
        {
            _owner = msg.sender;
        }
    
    /**
    * New Escrow
    * Function to deploy a new independent escrow contract. It can be created by anyone
    * and for any number of times. The creator is expected to fund it with VET. There is no limit to
    * the amount of funds.
    */
	function newEscrow( address payable _receiver, address[] memory _validators, uint _minimumVotesRequired, uint _deadline, address _tokenAddress)
    	public
    	returns(address newContract)
	{
        require((_validators.length > 0), "Invalid validator quorum.");
        require(_minimumVotesRequired <= _validators.length,"Minimum votes required exceeds the total number of validators.");
        require(_tokenAddress != address(0),"Provide the token address.");
        require(supportsToken(_tokenAddress),"The token is not supported.");
    	Escrow c = (new Escrow)(address(msg.sender), _receiver, _validators, _minimumVotesRequired, _deadline, _tokenAddress);
    	escrowContracts.push(EscrowStruct(address(c),msg.sender));
    	lastContractAddress = address(c);

        for (uint i = 0; i < _validators.length; i++) {
            validatorMapping[_validators[i]].push(address(c));
        }
    	emit NewEscrowContract(address(c));
    	return address(c);
	}

    /**
    * Get contract count
    * Utility function to check the number of escrows that exist in the system.
    */
    function getContractCount()
    	public
    	view
    	returns(uint contractCount)
	{
    	return escrowContracts.length;
	}

}

