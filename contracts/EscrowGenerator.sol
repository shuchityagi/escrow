pragma solidity ^0.5.1;
import "./Escrow.sol";
import "./utils/TokenSupport.sol";


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