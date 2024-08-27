// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ElectionOracle.sol"; // Import the ElectionOracle contract

contract DeployElectionOracle is Script {
    function run() external {
        // Begin broadcasting transactions
        vm.startBroadcast();

        // Set address for the admin (can be the deployer's address or a specified address)
        address admin = msg.sender;

        // Deploy the ElectionOracle contract, passing the admin address
        ElectionOracle electionOracle = new ElectionOracle(admin);

        // Print the address of the deployed contract
        console.log("ElectionOracle deployed at:", address(electionOracle));

        // End broadcasting transactions
        vm.stopBroadcast();
    }
}
