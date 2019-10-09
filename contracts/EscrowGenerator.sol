pragma solidity ^0.5.11;
import "./Escrow.sol";


contract EscrowGenerator {

    address[] public contracts;
	address public lastContractAddress;
    struct Escrows {
        address contractAddress;
        address creator;
    }
    mapping(address => Escrows[]) public validatorMapping;
    
    event newEscrowContract(address contractAddress);

	// deploy a new escrow contract
	function newEscrow( address payable _receiver, address[] memory _validators, uint _minimumVotesRequired, uint _deadline)
    	public
    	payable
    	returns(address newContract)
	{
    	Escrow c = (new Escrow).value(msg.value)(address(msg.sender), _receiver, _validators, _minimumVotesRequired, _deadline);
    	contracts.push(address(c));
    	lastContractAddress = address(c);
    	emit newEscrowContract(address(c));
    	return address(c);
	}

    function getContractCount()
    	public
    	view
    	returns(uint contractCount)
	{
    	return contracts.length;
	}

	function getEscrow(uint pos)
    	public
    	view
    	returns(address contractAddress)
	{
    	return address(contracts[pos]);
	}
}