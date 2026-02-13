// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/MicroEscrow.sol";

contract MicroEscrowTest is Test {
    MicroEscrow public c;
    
    function setUp() public {
        c = new MicroEscrow();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
