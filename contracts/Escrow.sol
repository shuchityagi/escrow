pragma solidity ^0.5.1;
import "./token/ERC223Receiver.sol";
import "./utils/TokenSupport.sol";
import "./token/StandardToken.sol";

contract Escrow is TokenSupport, ERC223Receiver{

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
            require(supportsToken(msg.sender),"The token is not supported");
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
        require(_balance == amountLocked,"Insufficient Balance.");
        emit Finalized(receiver,_balance);
        state = State.Inactive;
        tokenInstance.transfer(receiver,_balance);
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