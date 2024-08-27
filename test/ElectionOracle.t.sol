// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ElectionOracle.sol";

contract ElectionOracleTest is Test {
    ElectionOracle public electionOracle;
    address public owner;
    address public oracle = address(0x1234);
    address public newOwner = address(0x1111);
    uint256 public minEndOfElectionTimestamp;

    function setUp() public {
        // Set the initial owner to the deploying account (msg.sender)
        owner = msg.sender;

        // Set the minimum end of election timestamp to 1 day from now
        minEndOfElectionTimestamp = block.timestamp + 1 days;

        // Deploy the contract with the specified oracle address and timestamp
        electionOracle = new ElectionOracle(oracle, minEndOfElectionTimestamp);
    }

    //-----------------------------------------
    // Role Management Tests
    //-----------------------------------------

    function testOnlyOwnerCanGrantOracleRole() public {
        // Start acting as newOwner (who doesn't have OWNER role)
        vm.startPrank(newOwner);

        // Expect revert when newOwner tries to grant Oracle role (unauthorized)
        vm.expectRevert("Only owner can call this function");
        electionOracle.grantOracleRole(address(0x9999));

        vm.stopPrank(); // Stop acting as newOwner
    }

    function testOwnerCanGrantAndRevokeOracleRole() public {
        // Grant Oracle role to a specific address
        electionOracle.grantOracleRole(address(0x9999));

        // Verify the Oracle role has been granted
        assertTrue(electionOracle.hasRole(electionOracle.ORACLE_ROLE(), address(0x9999)));

        // Revoke Oracle role
        electionOracle.revokeOracleRole(address(0x9999));

        // Verify the Oracle role has been revoked
        assertFalse(electionOracle.hasRole(electionOracle.ORACLE_ROLE(), address(0x9999)));
    }

    //-----------------------------------------
    // Ownership Transfer Tests
    //-----------------------------------------

    function testOwnershipTransfer() public {
        // Transfer ownership to a new owner
        electionOracle.transferOwnership(newOwner);

        // New owner should now have DEFAULT_ADMIN_ROLE
        assertTrue(electionOracle.hasRole(electionOracle.DEFAULT_ADMIN_ROLE(), newOwner));

        // Verify that the new owner is correctly set in the `owner` field
        assertEq(electionOracle.owner(), newOwner);

        // Start acting as newOwner
        vm.startPrank(newOwner);

        // Verify newOwner can now grant roles (Oracle role)
        electionOracle.grantOracleRole(address(0x9999));

        // Confirm that the role is granted
        assertTrue(electionOracle.hasRole(electionOracle.ORACLE_ROLE(), address(0x9999)));

        vm.stopPrank(); // Stop acting as newOwner
    }

    function testOwnershipTransferToZeroAddress() public {
        // Expect revert when trying to transfer ownership to zero address
        vm.expectRevert("New owner address cannot be the zero address");
        electionOracle.transferOwnership(address(0));
    }

    //-----------------------------------------
    // Finalization Tests
    //-----------------------------------------

    function testOracleRoleCanFinalizeElectionResult() public {
        // Start acting as oracle address
        vm.startPrank(oracle);

        // Warp time to allow finalization after the election period
        vm.warp(minEndOfElectionTimestamp + 1);

        // Oracle finalizes the result to "Trump"
        electionOracle.finalizeElectionResult(ElectionOracle.ElectionResult.Trump);

        // Confirm the finalization was successful
        assertTrue(electionOracle.isElectionFinalized());
        assertEq(uint8(electionOracle.result()), uint8(ElectionOracle.ElectionResult.Trump));

        vm.stopPrank(); // Stop acting as oracle
    }

    function testCannotFinalizeTwice() public {
        // Start acting as oracle address
        vm.startPrank(oracle);
        vm.warp(minEndOfElectionTimestamp + 1);

        // Finalize the result to "Harris"
        electionOracle.finalizeElectionResult(ElectionOracle.ElectionResult.Harris);

        // Ensure finalization cannot happen twice
        vm.expectRevert("Election result is already finalized.");
        electionOracle.finalizeElectionResult(ElectionOracle.ElectionResult.Trump);

        vm.stopPrank(); // Stop acting as oracle
    }

    function testUnauthorizedCannotGrantOrRevokeRoles() public {
        address unauthorized = address(0x5678);

        // Start acting as an unauthorized address
        vm.startPrank(unauthorized);

        // Unauthorized should fail to grant Oracle role
        vm.expectRevert("Only owner can call this function");
        electionOracle.grantOracleRole(address(0x1111));
        vm.stopPrank();

        // Unauthorized should fail to revoke Oracle role
        vm.startPrank(unauthorized);
        vm.expectRevert("Only owner can call this function");
        electionOracle.revokeOracleRole(oracle);
        vm.stopPrank(); // Stop acting as unauthorized address
    }

    function testGetElectionResultBeforeFinalization() public {
        // Expect revert when trying to get the result before finalization
        vm.expectRevert("Election has not been finalized yet");
        electionOracle.getElectionResult();
    }

    function testOldOwnerCannotGrantOrRevokeAfterTransfer() public {
        // Transfer ownership to newOwner
        electionOracle.transferOwnership(newOwner);

        // Old owner (msg.sender) shouldn't be able to grant roles
        vm.expectRevert("Only owner can call this function");
        electionOracle.grantOracleRole(address(0x9999));

        // Old owner (msg.sender) shouldn't be able to revoke roles
        vm.expectRevert("Only owner can call this function");
        electionOracle.revokeOracleRole(oracle);
    }

    function testGetElectionResultAfterFinalization() public {
        // Start acting as oracle address
        vm.startPrank(oracle);
        vm.warp(minEndOfElectionTimestamp + 1);

        // Oracle finalizes the result to "Trump"
        electionOracle.finalizeElectionResult(ElectionOracle.ElectionResult.Trump);

        // Get the final result after finalization and verify it matches
        assertEq(uint8(electionOracle.getElectionResult()), uint8(ElectionOracle.ElectionResult.Trump));

        vm.stopPrank(); // Stop acting as oracle
    }

    function testCannotFinalizeBeforeElectionEnds() public {
        // Start acting as oracle address
        vm.startPrank(oracle);

        // Try to finalize before the election period ends and expect revert
        vm.warp(minEndOfElectionTimestamp - 1);
        vm.expectRevert("Cannot finalize before the end of the election period.");
        electionOracle.finalizeElectionResult(ElectionOracle.ElectionResult.Trump);

        vm.stopPrank(); // Stop acting as oracle
    }
}
