// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnergyBilling {
    address public consumerContractAddress;

    uint256 public pricePerUnit = 8;
    uint256 public transactionCount = 0;
    uint256 public billAmount = 0;
    uint256 public lastBillTimestamp;

    event BillGenerated(uint256 amount);

    constructor(address _consumerContractAddress) {
        consumerContractAddress = _consumerContractAddress;
        lastBillTimestamp = block.timestamp; // Initialize the timestamp for the bill cycle
    }

    function recordTransaction(uint256 unitsConsumed) public {
        require(msg.sender == consumerContractAddress, "Only the Consumer contract can record transactions");

        transactionCount++;
        billAmount += unitsConsumed * pricePerUnit;

        if (block.timestamp >= lastBillTimestamp + 30 days) {
            generateBill();
        }
    }

    function generateBill() private {
        emit BillGenerated(billAmount);  // Emit the BillGenerated event

        transactionCount = 0;  // Reset transaction count
        billAmount = 0;        // Reset bill amount
        lastBillTimestamp = block.timestamp;  // Reset the timestamp for the next billing cycle
    }
}
