// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

import {DiamondStorage} from "../diamond/DiamondStorage.sol";

contract LouiceAccountFacet {

    event LouiceAccountInitialized(IEntryPoint indexed entryPoint, PassKeyId indexed passKeyId);

    modifier onlyEntryPoint() {
        _requireFromEntryPoint();
        _;
    }

    function initialize(IEntryPoint anEntryPoint, address _verifierAddress, bytes memory _passkeyId) external {
        DiamondStorage.Layout storage ds = DiamondStorage.layout();
        ds.entryPoint = anEntryPoint;
        ds.verifierAddress = _verifierAddress;

        (uint256 pubKeyX, uint256 pubKeyY, string memory keyId) = abi.decode(_passkeyId, (uint256, uint256, string));
        ds.passkey = PassKeyId(pubKeyX, pubKeyY, keyId);

        emit LouiceAccountInitialized(anEntryPoint, ds.passkey);
    }

    function execute(address dest, uint256 value, bytes calldata data, address approveToken, bytes calldata approveData) external onlyEntryPoint {
        _call(dest, value, data);
        if (approveToken != address(0)) {
            _call(approveToken, 0, approveData);
        }
    }

    function executeBatch(address[] calldata dest, bytes[] calldata func) external onlyEntryPoint {
        require(dest.length == func.length, "wrong array lengths");
        for (uint256 i = 0; i < dest.length; i++) {
            _call(dest[i], 0, func[i]);
        }
    }

    function _call(address target, uint256 value, bytes memory data) internal {
        (bool success, bytes memory result) = target.call{value : value}(data);
        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }

    function getDeposit() public view returns (uint256) {
        return DiamondStorage.layout().entryPoint.balanceOf(address(this));
    }

    function addDeposit() public payable {
        DiamondStorage.layout().entryPoint.depositTo{value : msg.value}(address(this));
    }

    function withdrawDepositTo(address payable withdrawAddress, uint256 amount) public onlyEntryPoint {
        DiamondStorage.layout().entryPoint.withdrawTo(withdrawAddress, amount);
    }
}
