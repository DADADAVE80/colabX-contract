// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibApp} from "../libraries/LibApp.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";
import {Events} from "../libraries/constants/Events.sol";
import {Project} from "../Project.sol";

contract ProjectFactoryFacet {
    function createProject(string memory uri, string memory _title) external {
        LibApp.AppStorage storage s = appStorage();
        uint256 projectId = ++s.currentProjectId;
        //
        bytes32 role = keccak256(
            abi.encodePacked("DEFAULT_PROJECT_ADMIN", projectId)
        );
        LibDiamond._grantRole(role, msg.sender);

        Project newProject = new Project(address(this), uri, _title);

        s.projects[projectId] = newProject;
        s.projectsArr.push(newProject);
        s.creatorProjects[msg.sender].push(newProject);
        s.creatorProjectId[msg.sender][
            s.creatorProjects[msg.sender].length - 1
        ] = projectId;

        emit Events.ProjectCreated(_title, projectId);
    }

    function createPage(uint256 projectNo, uint256 pageNo) external {
        LibApp.AppStorage storage s = appStorage();
        Project project = s.creatorProjects[msg.sender][projectNo];
        uint256 projectId = s.creatorProjectId[msg.sender][projectNo];

        project.mint(msg.sender, pageNo, project.decimals(), "");

        emit Events.ProjectPageCreated(projectId, pageNo);
    }

    // TODO: Remove after tests
    function drop() external {
        LibDiamond._checkRole(LibDiamond.DEFAULT_ADMIN_ROLE);
        LibApp.AppStorage storage s = appStorage();

        delete s.currentProjectId;
        delete s.projectsArr;
    }

    // function updateProject(uint256 _projectId, string memory __name) external {
    //     LibApp.AppStorage storage s = appStorage();

    //     Project project = s.projects[_projectId];

    //     emit ProjectUpdated(_projectId);
    // }

    function viewProjectById(
        uint256 _projectId
    ) external view returns (Project project) {
        LibApp.AppStorage storage s = appStorage();
        project = s.projects[_projectId];
    }

    function viewProjectsByCreator(
        address creator
    ) external view returns (string[] memory uri, string[] memory title) {
        LibApp.AppStorage storage s = appStorage();

        Project[] storage projects = s.creatorProjects[creator];

        for (uint i; i < projects.length; ) {
            uri[i] = projects[i].uri(i);
            title[i] = projects[i].name();

            unchecked {
                ++i;
            }
        }
    }

    function viewAllProjects()
        external
        view
        returns (address[] memory creators, string[] memory uris, string[] memory titles)
    {
        LibApp.AppStorage storage s = appStorage();
        Project[] storage projects = s.projectsArr;

        uint256 length = projects.length;

        creators = new address[](length);
        uris = new string[](length);
        titles = new string[](length);

        for (uint i; i < projects.length; ) {
            Project project = s.projectsArr[i];

            creators[i] = project.owner();
            uris[i] = project.uri(i);
            titles[i] = project.name();

            unchecked {
                ++i;
            }
        }
    }

    function appStorage() internal pure returns (LibApp.AppStorage storage s) {
        assembly {
            s.slot := 0
        }
    }
}
