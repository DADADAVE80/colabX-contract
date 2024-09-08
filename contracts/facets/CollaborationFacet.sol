// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibApp} from "../libraries/LibApp.sol";
import {Project} from "../Project.sol";

contract CollaborationFacet {
    function contribute(uint256 projectId, uint256 pageNo) external {
        LibApp.AppStorage storage s = appStorage();

        Project project = s.projects[projectId];

        Project newProject= new Project(msg.sender, project.uri(pageNo), project.name());

        // newProject.mint();
    }

    function appStorage() internal pure returns (LibApp.AppStorage storage s) {
        assembly {
            s.slot := 0
        }
    }
}
