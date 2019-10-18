# Multi Validator Escrow

The contact follows a decentralized structure for every Escrow. The Master Escrow is used for deploying a new Escrow with suitable parameters depending upon the need. It also maintains a list of Escrows deployed and let's a validator check all the escrows they are a part of.

The address of these escrows is returned to the user so that they can act independently use it, without affecting the other escrows in place. This compartmentalized structure offers more privacy to users.

ERC223 token standard is specifically used in this scenario because it provides mechanism to control the transfer of tokens into the escrow while still maintaining backward compatibility with the popular VIP180/ERC20 token standards.

## Installation
Clone the repository and cd into it
```
git clone https://github.com/shuchityagi/escrow.git
cd escrow
```
### Running with docker

Make sure you have docker installed. You can install it from [here](https://docs.docker.com/).
once installed, run :
```
docker build -t escrow .
docker run --rm escrow
```
These commands will build a new docker instance and compile the truffle contracts.

### Running without docker

**Prerequisites**
1. Node(10^) and NPM (6^)
2. Truffle

Now to compile the contracts run,
```
truffle build
```
or
```
truffle compile
```
## Flow of execution :
- **Deploy StandardToken.sol**

>The account used for deploying will be the owner of the token contract and will hold the total supply.

- Deploy **EscrowGenerator.sol** (no constructor params required)

>The deployer is the owner of this contract.

- Call **addToken(the_token_contract_address)**

>EscrowGenerator maintains a list of allowed ERC223/VIP180 tokens which will be accepted to fund the Escrow. This is to give more control in terms of token integration. An escrow can be funded with one type of token only. The owner can choose to remove a token from the list too.

- Call **newEscrow()**
>Can be called by any address that wishes to create an escrow. This address will become the escrow creator and will have the responsibility to choose validator, receiver. Only this address will be allowed to fund the escrow and release payment in case no dispute is raised. This function returns the address of a fresh deployed independent escrow.

- Take the address from the previous function and using the ABI, set it up for interaction.

- The escrow creator is expected to fund the contracts with appropriate token.

- From the receiver account, lock the escrow using **lockEscrow()**

>Locking the escrow means that the receiver is satisfied with it's terms. Once locked, the terms cannot be changed.

- Call **releasePayment()**

>By default, the validators are not required to clear every payment. If no disputes were raised by either party, then the creator can simply call this function to make the payment.

- Call **raiseDispute()**

>This can be called by the creator or the receiver **before the deadline for the contract expires** to block the escrow and get the validators involved.

- Validators can then choose to **withdraw()** the payment to receiver's account or **refund()** it back to the creator. Each validator can vote once. And once the minimum decorum of votes is reached, the contract transfers the funds to the elected benefieciary.
