pragma solidity ^0.4.4;
contract Button {
    address private owner;
    address private lastPresser;
    uint256 private targetBlock;
    bool private started = false;

    event ButtonPressed(address _presser, uint256 _when);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier GameON() {
        require(started == true);
        _;
    }

    modifier GameOFF() {
        require(started == false);
        _;
    }

    function Button() public {
        owner = msg.sender;
    }

    // only owner can start the game
    function start() public onlyOwner GameOFF {
        started = true;
        targetBlock = block.number + 3; //15 Sec i.e 45secs :)
        lastPresser = 0x0;
    }

    // anybody can press the button by sending 3 ETH
    function pressButton() public GameON payable {
        require(msg.value == 3000000000000000000 && block.number <= targetBlock);
        lastPresser = msg.sender;
        targetBlock = targetBlock + 3; // 3 Block Pass
        ButtonPressed(msg.sender, now);
    }

    function getTargetBlock() public  returns(uint256) {
        return targetBlock;
    }

    function whoPressedLast() public  returns(address) {
        return lastPresser;
    }

    function claimTreasure() public GameON {
        require(block.number > targetBlock && msg.sender == lastPresser);
        uint256 amount = (this.balance * 95 ) / 100; //95% for winner, give 5% to poor game developer :)
        lastPresser.transfer(amount);
    }

    function depositEther() public payable onlyOwner { } //load some amount

    function kill() public onlyOwner GameOFF {
        selfdestruct(owner);
    }

    function withdrawBalance() public onlyOwner GameOFF {
        owner.transfer(this.balance);
    }
}
