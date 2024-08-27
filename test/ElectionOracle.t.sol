// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ElectionOracle.sol";

contract ElectionOracleTest is Test {
    ElectionOracle public electionOracle;
    address admin = address(0x1234);

    function setUp() public {
        electionOracle = new ElectionOracle(admin);
    }

    function testProposeAndFinalizeElectionAsAdmin() public {
        vm.startPrank(admin);

        // Propose Harris as the winner
        electionOracle.proposeElectionResult(
            ElectionOracle.ElectionResult.Harris
        );

        // Assert that the proposal has been correctly set
        // Cast result to uint8 since assertEq with enums requires matching standard types
        assertEq(
            uint8(electionOracle.result()),
            uint8(ElectionOracle.ElectionResult.Harris)
        );

        // Assert that the proposal timestamp matches the block timestamp
        assertEq(electionOracle.resultProposalTimestamp(), block.timestamp);

        // Finalize the result
        electionOracle.finalizeElectionResult();

        // Check finalization status
        assertTrue(electionOracle.isResultFinalized());

        // Ensure the final result matches
        assertEq(
            uint8(electionOracle.getElectionResult()),
            uint8(ElectionOracle.ElectionResult.Harris)
        );

        // Ensure the finalization timestamp matches the block timestamp
        assertEq(electionOracle.resultFinalizationTimestamp(), block.timestamp);

        vm.stopPrank();
    }

    function testOnlyAdminCanProposeAndFinalize() public {
        // Try to propose a result without being the admin
        vm.expectRevert();
        electionOracle.proposeElectionResult(
            ElectionOracle.ElectionResult.Trump
        );

        // Try to finalize a result without being the admin
        vm.expectRevert();
        electionOracle.finalizeElectionResult();
    }

    function testOwnershipTransfer() public {
        address newOwner = address(0x5678);
        // Transfer ownership
        electionOracle.transferOwnership(newOwner);
        assertEq(electionOracle.owner(), newOwner);

        vm.prank(newOwner);
        // Verify the new owner can still operate normally.
        electionOracle.transferOwnership(admin);
        assertEq(electionOracle.owner(), admin);
    }
}
