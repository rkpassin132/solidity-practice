// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract Calculator {
    uint256 result = 0;

    function add( uint256 _num) public {
        result += _num;
    }

    function subtract(uint256 _num) public {
        result -= _num;
    }

    function multiply(uint256 _num) public {
        result *= _num;
    }

    function divide(uint256 _num) public {
        result /= _num;
    }

    function get() public view returns(uint256) {
        return result;
    }
}