pragma solidity ^0.5.11;
import "./Escrow.sol";


contract EscrowGenerator {

    struct EscrowStruct {
        address contractAddress;
        address creator;
    }
    EscrowStruct[] public escrowContracts;
    address public lastContractAddress;
    mapping(address => address[]) public validatorMapping;
    
    event newEscrowContract(address contractAddress);

	// deploy a new escrow contract
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
    	emit newEscrowContract(address(c));
    	return address(c);
	}

    function getContractCount()
    	public
    	view
    	returns(uint contractCount)
	{
    	return escrowContracts.length;
	}

	// function getEscrow(uint id)
    // 	public
    // 	view
    // 	returns (address _contractAddress, address creator)
    // {
    //     EscrowStruct memory e = escrowContracts[id];
    //     return (e.contractAddress, e.creator);
    // }
}