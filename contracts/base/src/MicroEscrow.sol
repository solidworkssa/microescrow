// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MicroEscrow Contract
/// @author solidworkssa
/// @notice Trustless escrow for secure small transactions.
contract MicroEscrow {
    string public constant VERSION = "1.0.0";


    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETED, REFUNDED }
    
    struct Escrow {
        address payer;
        address payee;
        uint256 amount;
        State state;
        uint256 createdAt;
    }
    
    mapping(uint256 => Escrow) public escrows;
    uint256 public nextEscrowId;
    
    function createEscrow(address _payee) external payable returns (uint256) {
        uint256 id = nextEscrowId++;
        escrows[id] = Escrow({
            payer: msg.sender,
            payee: _payee,
            amount: msg.value,
            state: State.AWAITING_DELIVERY,
            createdAt: block.timestamp
        });
        return id;
    }
    
    function release(uint256 _id) external {
        Escrow storage e = escrows[_id];
        require(msg.sender == e.payer, "Only payer can release");
        require(e.state == State.AWAITING_DELIVERY, "Invalid state");
        e.state = State.COMPLETED;
        payable(e.payee).transfer(e.amount);
    }
    
    function refund(uint256 _id) external {
        Escrow storage e = escrows[_id];
        require(msg.sender == e.payee, "Only payee can refund");
        require(e.state == State.AWAITING_DELIVERY, "Invalid state");
        e.state = State.REFUNDED;
        payable(e.payer).transfer(e.amount);
    }

}
