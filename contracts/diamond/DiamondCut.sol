// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

interface IDiamondCut {
    struct FacetCut {
        address facetAddress;
        bytes4[] functionSelectors;
    }

    function diamondCut(FacetCut[] calldata _diamondCut, address _init, bytes calldata _calldata) external;
}
