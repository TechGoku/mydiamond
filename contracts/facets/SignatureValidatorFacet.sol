// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

import {DiamondStorage} from "../diamond/DiamondStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SignatureValidatorFacet {

    using DiamondStorage for DiamondStorage.Layout;
    using ECDSA for bytes32;

    function _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
        internal returns (uint256 validationData)
    {
        DiamondStorage.Layout storage ds = DiamondStorage.layout();
        bytes memory data = abi.encodeWithSignature(
            "validateUserOp((address,uint256,bytes,bytes,uint256,uint256,uint256,uint256,uint256,bytes,bytes),bytes32,uint256[2])",
            userOp,
            userOpHash,
            [ds.passkey.pubKeyX, ds.passkey.pubKeyY]
        );

        (bool success, bytes memory result) = ds.verifierAddress.staticcall(data);
        require(success, "Static call to validateUserOp failed");

        return abi.decode(result, (uint256)); 
    }
}
