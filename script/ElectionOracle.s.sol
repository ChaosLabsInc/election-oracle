// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ElectionOracle.sol";

contract DeployElectionOracle is Script {
    function run() external {
        // Retrieve the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Define the owner, oracle, and election timestamp
        address owner; // Specify the actual owner address here
        address oracle; // Specify the actual oracle address here
        //uint256 expectedEndOfElectionTimestamp = 1730878800; // November 6, 2024, 00:00:00 EST
        //uint256 minEndOfElectionTimestamp = expectedEndOfElectionTimestamp + 24 hours;
        uint256 minEndOfElectionTimestamp = block.timestamp + 1 minutes;

        // Deploy the ElectionOracle contract
        //ElectionOracle electionOracle = new ElectionOracle(owner, oracle, minEndOfElectionTimestamp);
        ElectionOracle electionOracle = new ElectionOracle(owner, oracle, minEndOfElectionTimestamp);

        console.log("ElectionOracle deployed at:", address(electionOracle));

        vm.stopBroadcast();
    }
}
