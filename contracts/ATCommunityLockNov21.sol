// SPDX-License-Identifier: MIT
// 
//        _______   ______ _                            
//     /\|__   __| |  ____(_)                           
//    /  \  | |    | |__   _ _ __   __ _ _ __   ___ ___ 
//   / /\ \ | |    |  __| | | '_ \ / _` | '_ \ / __/ _ \
//  / ____ \| |    | |    | | | | | (_| | | | | (_|  __/
// /_/    \_\_|    |_|    |_|_| |_|\__,_|_| |_|\___\___|  Est.2021
// 
// Telegram: https://t.me/at_finance
// Twitter: https://t.co/mTtLSX7ayv
// GitHub: https://github.com/ATFinance
// Email: support@at.finance
// 

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @dev A token holder contract that will allow a beneficiary to extract the
 * tokens after a given release time.
 *
 * Useful for simple vesting schedules like "advisors get all of their tokens
 * after 1 year".
 * 
 * RELEASE DATE: 01 Nov 2021 
 * EPOCH: 1635724800
 * NOTES: Community-2
 * BENEFICIARY: 0xf845407E8574f229c15d285F8F8f07af0a8fFCb4
 */

contract ATCommunityLockNov21 {
    using SafeERC20 for IERC20;

    // ERC20 basic token contract being held
    IERC20 private _token;

    // beneficiary of tokens after they are released
    address private _beneficiary;

    // timestamp when token release is enabled
    uint256 private _releaseTime;

    constructor (IERC20 token_, address beneficiary_, uint256 releaseTime_) {
        // solhint-disable-next-line not-rely-on-time
        require(releaseTime_ > block.timestamp, "TokenTimelock: release time is before current time");
        _token = token_;
        _beneficiary = beneficiary_;
        _releaseTime = releaseTime_;
    }

    /**
     * @return the token being held.
     */
    function token() public view virtual returns (IERC20) {
        return _token;
    }

    /**
     * @return the beneficiary of the tokens.
     */
    function beneficiary() public view virtual returns (address) {
        return _beneficiary;
    }

    /**
     * @return the time when the tokens are released.
     */
    function releaseTime() public view virtual returns (uint256) {
        return _releaseTime;
    }

    /**
     * @notice Transfers tokens held by timelock to beneficiary.
     */
    function release() public virtual {
        // solhint-disable-next-line not-rely-on-time
        require(block.timestamp >= releaseTime(), "TokenTimelock: current time is before release time");

        uint256 amount = token().balanceOf(address(this));
        require(amount > 0, "TokenTimelock: no tokens to release");

        token().safeTransfer(beneficiary(), amount);
    }
}