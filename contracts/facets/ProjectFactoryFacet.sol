// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibApp} from "../libraries/LibApp.sol";
import {Project} from "../Project.sol";

contract ProjectFactoryFacet {
    event ProjectCreated(string indexed title, uint256 projectId);
    function createProject(string memory uri, string memory _title) external {
        LibApp.AppStorage storage s = appStorage();

        Project newProject = new Project(msg.sender, uri, _title);

        s.projects[++s.projectId] = newProject;

        s.projectsArr.push(newProject);

        s.creatorProjects[msg.sender].push(newProject);

        newProject.mint(msg.sender, s.projectId, newProject.decimals(), "");

        emit ProjectCreated(_title, s.projectId);
    }
    
    function ViewProjectById(uint256 _projectId) external view returns (Project project) {
        LibApp.AppStorage storage s = appStorage();

        project = s.projects[_projectId];
    }

    function viewProjectsByCreator(address creator) external view returns (Project[] memory projects) {
        LibApp.AppStorage storage s = appStorage();

        projects = s.creatorProjects[creator];
    }

    function viewAllProjects() external view returns (Project[] memory projects) {
        LibApp.AppStorage storage s = appStorage();

        projects = s.projectsArr;
    }

    function appStorage() internal pure returns (LibApp.AppStorage storage s) {
        assembly {
            s.slot := 0
        }
    }
}
