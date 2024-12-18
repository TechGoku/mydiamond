// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

library DiamondStorage {
    struct Layout {
        IEntryPoint entryPoint;
        address verifierAddress;
        PassKeyId passkey;
    }

    bytes32 internal constant STORAGE_SLOT = keccak256("diamond.standard.storage");

    function layout() internal pure returns (Layout storage ds) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            ds.slot := slot
        }
    }
}
