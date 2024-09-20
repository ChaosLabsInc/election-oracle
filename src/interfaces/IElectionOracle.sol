// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IElectionOracle {
    enum ElectionResult {
        NotSet,
        Trump,
        Harris,
        Other
    }

    function getElectionResult() external view returns (ElectionResult);
    function isElectionFinalized() external view returns (bool);
    function minEndOfElectionTimestamp() external view returns (uint256);
    function resultFinalizationTimestamp() external view returns (uint256);
}
