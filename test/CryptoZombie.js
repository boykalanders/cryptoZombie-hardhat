const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CryptoZombie", function () {
    it("Deploying the CryptoZombie", async function () {
        const [owner] = await ethers.getSigners();

        const zombieContract = await ethers.deployContract("ZombieFactory");

        const tx = await zombieContract.createRandomZombie("MStar");

        const res = await tx.wait();

        console.log(res.logs);
    })
    
})