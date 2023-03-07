// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract SubOverflow {
    // Modify this function so that on overflow it returns the value 0
    // otherwise it should return x - y
    function subtract(uint256 x, uint256 y) public pure returns (uint256) {
        // Write assembly code that handles overflows
        assembly {
          let result := sub(x, y)
          if lt(x, y) { result := 0 }
          let ptr := mload(0x40)
          let free_mem := add(ptr, 0x20)
          mstore(free_mem, result)
          return(free_mem, 0x20)
        }
    }
}
