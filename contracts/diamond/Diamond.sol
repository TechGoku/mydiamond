// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

import {IDiamondCut} from "./IDiamondCut.sol";
import {DiamondStorage} from "./DiamondStorage.sol";

contract Diamond {
    constructor(address _diamondCutFacet) {
        // Initialize the Diamond contract by adding facets
        IDiamondCut(_diamondCutFacet).diamondCut(
            [
                IDiamondCut.FacetCut({
                    facetAddress: address(new LouiceAccountFacet()),
                    functionSelectors: getSelectors(LouiceAccountFacet)
                }),
                IDiamondCut.FacetCut({
                    facetAddress: address(new SignatureValidatorFacet()),
                    functionSelectors: getSelectors(SignatureValidatorFacet)
                }),
                IDiamondCut.FacetCut({
                    facetAddress: address(new TokenCallbackHandlerFacet()),
                    functionSelectors: getSelectors(TokenCallbackHandlerFacet)
                })
            ],
            address(0),
            ""
        );
    }

    function getSelectors(address facet) internal pure returns (bytes4[] memory selectors) {
        selectors = new bytes4[](facet.functionSelectors.length);
        for (uint256 i = 0; i < facet.functionSelectors.length; i++) {
            selectors[i] = facet.functionSelectors[i];
        }
    }
}
