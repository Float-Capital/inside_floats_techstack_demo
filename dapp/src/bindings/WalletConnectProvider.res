module Provider = {
  type t

  type providerOptions = {rpc: {"1": string}}
  @module("@walletconnect/web3-providers") @new
  external walletConnectProvider: providerOptions => t = "WalletConnectProvider"
}
