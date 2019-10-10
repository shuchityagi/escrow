pragma solidity ^0.5.11;
import "./Escrow.sol";


contract EscrowGenerator {

    /** Struct to maintain the basic info in the contract.*/
    struct EscrowStruct {
        address contractAddress;
        address creator;
    }

    EscrowStruct[] public escrowContracts;
    /** Pointer to the last contract depoyed. Helps keep track incase of mass depolyment via scripts */
    address public lastContractAddress;
    /** Mapping Validator to the list of contracts he/she has been appointed to.*/
    mapping(address => address[]) public validatorMapping;
    
    event NewEscrowContract(address contractAddress);

	/**
    * New Escrow
    * Function to deploy a new independent escrow contract. It can be created by anyone
    * and for any number of times. The creator is expected to fund it with VET. There is no limit to
    * the amount of funds.
    */
	function newEscrow( address payable _receiver, address[] memory _validators, uint _minimumVotesRequired, uint _deadline)
    	public
    	payable
    	returns(address newContract)
	{
        require((_validators.length > 0), "Invalid validator quorum.");
        require(_minimumVotesRequired <= _validators.length,"Minimum votes required exceeds the total number of validators.");
        require(msg.value > 0, "Fund the account with appropriate amount");
    	Escrow c = (new Escrow).value(msg.value)(address(msg.sender), _receiver, _validators, _minimumVotesRequired, _deadline);
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