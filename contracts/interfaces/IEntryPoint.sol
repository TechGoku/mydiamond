// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

interface IEntryPoint {
    function balanceOf(address account) external view returns (uint256);
    function depositTo(address account) external payable;
    function withdrawTo(address payable account, uint256 amount) external;
}
