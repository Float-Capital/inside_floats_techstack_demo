module HodlWallet = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function depositToken(address tokenAddress, uint256 tokenAmount) public",
      "function withdrawToken(address tokenAddress, uint256 tokenAmount) public",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external depositToken: (
    ~contract: t,
    ~tokenAddress: Ethers.ethAddress,
    ~tokenAmount: Ethers.BigNumber.t,
  ) => Promise.t<Ethers.txSubmitted> = "depositToken"

  @send
  external withdrawToken: (
    ~contract: t,
    ~tokenAddress: Ethers.ethAddress,
    ~tokenAmount: Ethers.BigNumber.t,
  ) => Promise.t<Ethers.txSubmitted> = "withdrawToken"
}
