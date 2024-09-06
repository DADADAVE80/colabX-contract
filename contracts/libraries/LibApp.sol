// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Project} from "../Project.sol";

contract LibApp {
    struct AppStorage {
        string title;
        uint256 projectId;
        Project[] projectsArr;
        mapping(uint256 => Project) projects;
        mapping(address => Project[]) creatorProjects;
    }

    function appStorage() internal pure returns (AppStorage storage s) {
        assembly {
            s.slot := 0
        }
    }
}