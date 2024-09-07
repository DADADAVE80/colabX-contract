// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

import {ColabX} from "contracts/ColabX.sol";
import {DiamondInit} from "contracts/upgradeInitializers/DiamondInit.sol";

import {DiamondCutFacet} from "contracts/facets/DiamondCutFacet.sol";
import {DiamondLoupeFacet} from "contracts/facets/DiamondLoupeFacet.sol";
import {AccessControlFacet} from "contracts/facets/AccessControlFacet.sol";
// import {}

import {IDiamondCut, FacetCut, FacetCutAction} from "contracts/interfaces/IDiamondCut.sol";
import {IDiamondInit} from "../../contracts/interfaces/IDiamondInit.sol";
import {IDiamondLoupe} from "contracts/interfaces/IDiamondLoupe.sol";
import {IAccessControl} from "contracts/interfaces/IAccessControl.sol";
import {IERC165} from "contracts/interfaces/IERC165.sol";

import {LibDiamond, DiamondArgs} from "contracts/libraries/LibDiamond.sol";

contract DeployColabX is Script {
    ColabX diamond;
    DiamondInit diamondInit;

    DiamondCutFacet diamondCutFacet;
    DiamondLoupeFacet diamondLoupeFacet;
    AccessControlFacet accessControlFacet;

    function run() external {
        vm.startBroadcast();

        // Deploy core diamond template contracts
        diamondInit = DiamondInit(0x0252983fAD6caC37Ca4BcdeF9f1f7DFe3960D041);
        diamondCutFacet = DiamondCutFacet(0x222BeC22E51ee73363Fde9eB6f4212FA7f9780bc);
        diamondLoupeFacet = DiamondLoupeFacet(0x24445Fe462Bf99E581f1f2399effbD133D86Fd2b);
        accessControlFacet = AccessControlFacet(0xa40723313638eB7aC4D43Dc2BC0ADAe713C75D01);

        DiamondArgs memory initDiamondArgs = DiamondArgs({
            init: address(diamondInit),
            // NOTE: "interfaceId" can be used since "init" is the only function in IDiamondInit.
            initCalldata: abi.encode(type(IDiamondInit).interfaceId)
        });

        FacetCut[] memory initCut = new FacetCut[](3);

        bytes4[] memory initCutSelectors = new bytes4[](1);
        initCutSelectors[0] = IDiamondCut.diamondCut.selector;

        bytes4[] memory loupeSelectors = new bytes4[](5);
        loupeSelectors[0] = IDiamondLoupe.facets.selector;
        loupeSelectors[1] = IDiamondLoupe.facetFunctionSelectors.selector;
        loupeSelectors[2] = IDiamondLoupe.facetAddresses.selector;
        loupeSelectors[3] = IDiamondLoupe.facetAddress.selector;
        loupeSelectors[4] = IERC165.supportsInterface.selector;

        bytes4[] memory accessControlSelectors = new bytes4[](6);
        accessControlSelectors[0] = IAccessControl.hasRole.selector;
        accessControlSelectors[1] = IAccessControl.getRoleAdmin.selector;
        accessControlSelectors[2] = IAccessControl.grantRole.selector;
        accessControlSelectors[3] = IAccessControl.revokeRole.selector;
        accessControlSelectors[4] = IAccessControl.renounceRole.selector;
        accessControlSelectors[5] = AccessControlFacet.setRoleAdmin.selector;

        bytes4[] memory projectFactoryFacetSelectors = new bytes4[](4);
        projectFactoryFacetSelectors[0] = 0x6bd06204;
        projectFactoryFacetSelectors[1] = 0x0c313778;
        projectFactoryFacetSelectors[2] = 0xd6e403f3;
        projectFactoryFacetSelectors[3] = 0x29e4b44f;

        initCut[0] = FacetCut({
            facetAddress: address(diamondCutFacet),
            action: FacetCutAction.Add,
            functionSelectors: initCutSelectors
        });

        initCut[1] = FacetCut({
            facetAddress: address(diamondLoupeFacet),
            action: FacetCutAction.Add,
            functionSelectors: loupeSelectors
        });

        initCut[2] = FacetCut({
            facetAddress: address(accessControlFacet),
            action: FacetCutAction.Add,
            functionSelectors: accessControlSelectors
        });

        // deploy the Diamond
        console.log("Msg.sender: ", msg.sender);
        // diamond = ColabX(0x32F237f3b0BE5B5e19A756b187C0EB89926f61a3);
        console.log("Diamond address: ", address(diamond));
        console.log("DiamondInit address: ", address(diamondInit));

        vm.stopBroadcast();
    }
}