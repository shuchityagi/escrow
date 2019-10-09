pragma solidity ^0.5.11;

contract Escrow {

    address payable public creator;
    address payable public receiver;
    address payable public validator;
    uint public deadline;
    uint public amountLocked;
    enum State { Created, Locked, Inactive, Disputed }
	State public state;


    constructor(address payable _creator, address payable _validator, address payable _receiver, uint _deadline) public payable {
        creator = _creator;
        validator = _validator;
        receiver = _receiver;
        deadline = _deadline;
        amountLocked = msg.value;
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
    	require(msg.sender == validator, "User not authorised.");
    	_;
	}

    event EscrowLocked();
    event EscrowAborted();
    event ExpiredEscrowAborted();

    function abortEscrow()
    	public
    	onlyCreator
	{
        if(state == State.Created) {
            emit EscrowAborted();
    	    state = State.Inactive;
    	    creator.transfer(address(this).balance);
        }
        //TODO : Improve block.timestamp;
        else if(state == State.Locked && deadline < block.timestamp) {
            emit ExpiredEscrowAborted();
            creator.transfer(address(this).balance);
        }
	}

    function lockEscrow()
    	public
        onlyReceiver()
    	inState(State.Created)
	{
    	emit EscrowLocked();
    	state = State.Locked;
	}

    function releaseEscrow(address _beneficiary)
        public
        onlyValidator()
        inState(State.Locked)
    {
        //TODO : Standard logic for validator. Decide whom to send the funds to.
        //If disputed, change the state too.
    }

    function raiseDispute()
        public
        onlyReceiver()
        inState(State.Locked)
    {
        //TODO : Improve block.timestamp;
        require(deadline >= block.timestamp);
        state = State.Disputed;
    }
}