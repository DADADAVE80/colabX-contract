// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Events {
    event ProjectCreated(string indexed title, uint256 indexed projectId);
    event ProjectPageCreated(uint256 indexed projectId, uint256 pageNo);
    event ProjectTitleUpdated(string indexed oldTitle, string indexed newTitle);
    event ProjectUpdated(uint256 projectId);
}