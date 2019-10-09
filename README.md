#Multi Validator Escrow
The contact follows a decentralized structure for every Escrow.
There is a main contract which in turn creates new independent Escrows contracts inturn.
The address of these escrows can returned to the user so that they can act independently on it, without affecting the other escrows in place. This compartmentalized structure offers more privacy to users.

The owner was not a part of the requirements. Hence there is no concept of ownership in any of the contracts. Although the creator has the ability to mark an escrow inactive or destory the contract.

Validators only come in case of a dispute.

Follows a multisig approch to allow multiple validators to sign a transaction.


Suggestions :
1. A fucntion to update the terms of the escrow before it is locked, to facilitate more flexibility.
2. Both contracts can be made upgradable for future scalability.

Known Loopholes :
1. releasePayment() can be called by the receiver too if no dispute was raised and the escrow has expired. False payments can be pulled by a receiver in case the creator was unable to raise a dispute for any reason. On the other hand, the creator could abort a contract too and pull a refund under similar situation. The overall system is a perfect compromise between both parties but can be worked upon.