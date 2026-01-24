// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    struct EscrowAgreement {
        uint256 id;
        address buyer;
        address seller;
        address arbiter;
        uint256 amount;
        bool funded;
        bool released;
        bool refunded;
    }

    mapping(uint256 => EscrowAgreement) public escrows;
    uint256 public escrowCount;

    event EscrowCreated(uint256 indexed escrowId, address buyer, address seller, uint256 amount);
    event EscrowFunded(uint256 indexed escrowId);
    event EscrowReleased(uint256 indexed escrowId);
    event EscrowRefunded(uint256 indexed escrowId);

    function createEscrow(address _seller, address _arbiter) external payable returns (uint256) {
        require(msg.value > 0, "Must send funds");
        
        uint256 escrowId = escrowCount++;
        
        escrows[escrowId] = EscrowAgreement({
            id: escrowId,
            buyer: msg.sender,
            seller: _seller,
            arbiter: _arbiter,
            amount: msg.value,
            funded: true,
            released: false,
            refunded: false
        });

        emit EscrowCreated(escrowId, msg.sender, _seller, msg.value);
        emit EscrowFunded(escrowId);

        return escrowId;
    }

    function release(uint256 _escrowId) external {
        EscrowAgreement storage escrow = escrows[_escrowId];
        require(msg.sender == escrow.arbiter || msg.sender == escrow.buyer, "Unauthorized");
        require(escrow.funded && !escrow.released && !escrow.refunded, "Invalid state");

        escrow.released = true;
        payable(escrow.seller).transfer(escrow.amount);

        emit EscrowReleased(_escrowId);
    }

    function refund(uint256 _escrowId) external {
        EscrowAgreement storage escrow = escrows[_escrowId];
        require(msg.sender == escrow.arbiter, "Only arbiter can refund");
        require(escrow.funded && !escrow.released && !escrow.refunded, "Invalid state");

        escrow.refunded = true;
        payable(escrow.buyer).transfer(escrow.amount);

        emit EscrowRefunded(_escrowId);
    }
}
