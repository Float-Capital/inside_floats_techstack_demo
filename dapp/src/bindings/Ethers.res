type ethAddressStr = string
type ethAddress

module Misc = {
  let unsafeToOption: (unit => 'a) => option<'a> = unsafeFunc => {
    try {
      unsafeFunc()->Some
    } catch {
    | Js.Exn.Error(_obj) => None
    }
  }
}

type ethersBigNumber
type txResult = {
  blockHash: string,
  blockNumber: int,
  byzantium: bool,
  confirmations: int,
  // contractAddress: null,
  // cumulativeGasUsed: Object { _hex: "0x26063", … },
  // events: Array(4) [ {…}, {…}, {…}, … ],
  from: ethAddress,
  gasUsed: ethersBigNumber,
  // logs: Array(4) [ {…}, {…}, {…}, … ],
  // logsBloom: "0x00200000000000008000000000000000000020000001000000000000400020000000000000002000000000000000000000000002800010000000008000000000000000000000000000000008000000000040000000000000000000000000000000000000020000014000000000000800024000000000000000000010000000000000000000000000000000000000000000008000000000000000000000000200000008000000000000000000000000000000000800000000000000000000000000001002000000000000000000000000000000000000000020000000040020000000000000000080000000000000000000000000000000080000000000200000"
  status: int,
  _to: ethAddress,
  transactionHash: string,
  transactionIndex: int,
}
// https://github.com/ethers-io/ethers.js/blob/ef1b28e958b50cea7ff44da43b3c5ff054e4b483/packages/abstract-provider/src.ts/index.ts#L40
type transactionResponse = {blockNumber: int}
type txHash = string
type blockNumber = int
type txSubmitted = {
  hash: txHash,
  wait: (. unit) => Promise.t<txResult>,
}
type txError = {
  code: int, // -32000 = always failing tx ;  4001 = Rejected by signer.
  message: string,
  stack: option<string>,
}

type abi

let makeAbi = (abiArray: array<string>): abi => abiArray->Obj.magic

module BigNumber = {
  type t = ethersBigNumber

  @module("ethers") @scope("BigNumber")
  external fromUnsafe: string => t = "from"
  @module("ethers") @scope("BigNumber")
  external fromInt: int => t = "from"
  @module("ethers") @scope("BigNumber")
  external fromFloat: float => t = "from"

  @send external add: (t, t) => t = "add"
  @send external sub: (t, t) => t = "sub"
  @send external mul: (t, t) => t = "mul"
  @send external div: (t, t) => t = "div"
  @send external mod: (t, t) => t = "mod"
  @send external pow: (t, t) => t = "pow"
  @send external abs: t => t = "abs"

  @send external gt: (t, t) => bool = "gt"
  @send external gte: (t, t) => bool = "gte"
  @send external lt: (t, t) => bool = "lt"
  @send external lte: (t, t) => bool = "lte"
  @send external eq: (t, t) => bool = "eq"

  @send external toString: t => string = "toString"

  @send external toNumber: t => int = "toNumber"
  @send external toNumberFloat: t => float = "toNumber"

  let min = (a, b) => a->gt(b) ? b : a
  let max = (a, b) => a->gt(b) ? a : b
}

type providerType

type walletType = {@as("_address") address: string, provider: providerType}

module Wallet = {
  type t = walletType

  @new @module("ethers")
  external makePrivKeyWallet: (string, providerType) => t = "Wallet"

  type rawSignature
  @send
  external signMessage: (t, string) => Promise.t<rawSignature> = "signMessage"

  let rawSignatureToString: rawSignature => string = Obj.magic
}

module Providers = {
  type t = providerType

  type block = {
    _difficulty: BigNumber.t,
    difficulty: int,
    extraData: ethAddress,
    gasLimit: BigNumber.t,
    gasUsed: BigNumber.t,
    hash: ethAddress,
    miner: ethAddress,
    nonce: ethAddress,
    number: int,
    parentHash: ethAddress,
    timestamp: int,
    transactions: array<ethAddress>,
  }

  @new @module("ethers") @scope("providers")
  external makeProvider: string => t = "JsonRpcProvider"

  @new @module("ethers") @scope("providers")
  external makeProviderWithCurrentProvider: Web3.Providers.t => t = "Web3Provider"

  @send external send: (t, string, array<ethAddress>) => Promise.t<'a> = "send"

  @send external getBalance: (t, ethAddress) => Promise.t<option<BigNumber.t>> = "getBalance"

  @send
  external getBlockNumber: t => Promise.t<int> = "getBlockNumber"

  @send
  external getBlock: (t, int) => Promise.t<Js.nullable<block>> = "getBlock"

  @send
  external lookupAddress: (t, ethAddress) => Promise.t<option<string>> = "lookupAddress"

  @send
  external getSigner: t => option<Wallet.t> = "getSigner"

  @send
  external on: (t, string, 'a) => unit = "on"
  @send
  external removeAllListeners: (t, string) => unit = "removeAllListeners"

  @send
  external waitForTransaction: (providerType, txHash) => Promise.t<txResult> = "waitForTransaction"

  @send
  external getTransaction: (t, txHash) => Promise.t<transactionResponse> = "getTransaction"

  @send
  external call: (t, transactionResponse, blockNumber) => Promise.t<string> = "call"

  type feeData = {
    gasPrice: ethersBigNumber,
    maxFeePerGas: ethersBigNumber,
    maxPriorityFeePerGas: ethersBigNumber,
  }
  @send
  external getFeeData: providerType => Promise.t<feeData> = "getFeeData"
}

type providerOrSigner =
  | Provider(Providers.t)
  | Signer(Wallet.t)

let getProviderFromProviderOrSigner: providerOrSigner => providerType = pOrS =>
  switch pOrS {
  | Provider(provider) => provider
  | Signer(signer) => signer.provider
  }
module Contract = {
  type t

  type txOptions = {
    @live gasLimit: option<string>,
    @live value: BigNumber.t,
  }

  type tx = {
    hash: txHash,
    wait: (. unit) => Promise.t<txResult>,
  }

  @new @module("ethers")
  external getContractSigner: (ethAddress, abi, Wallet.t) => t = "Contract"
  @new @module("ethers")
  external getContractProvider: (ethAddress, abi, Providers.t) => t = "Contract"

  let make: (ethAddress, abi, providerOrSigner) => t = (address, abi, providerSigner) => {
    switch providerSigner {
    | Provider(provider) => getContractProvider(address, abi, provider)
    | Signer(signer) => getContractSigner(address, abi, signer)
    }
  }

  @send external on: (t, string, 'a => unit) => unit = "on"
  @send external on2: (t, string, ('a, 'b) => unit) => unit = "on"
  @send external on3: (t, string, ('a, 'b, 'c) => unit) => unit = "on"
  @send external on4: (t, string, ('a, 'b, 'c, 'd) => unit) => unit = "on"
  @send external on5: (t, string, ('a, 'b, 'c, 'd, 'e) => unit) => unit = "on"
  @send external on6: (t, string, ('a, 'b, 'c, 'd, 'e, 'f) => unit) => unit = "on"
  @send external on7: (t, string, ('a, 'b, 'c, 'd, 'e, 'f, 'g) => unit) => unit = "on"

  @send external removeAllListeners: (t, string) => unit = "removeAllListeners"
}

module Utils = {
  type ethUnit = [
    | #wei
    | #kwei
    | #mwei
    | #gwei
    | #microether
    | #milliether
    | #ether
    | #kether
    | #mether
    | #geher
    | #tether
  ]
  @module("ethers") @scope("utils")
  external parseUnitsUnsafe: (. string, ethUnit) => BigNumber.t = "parseUnits"
  let parseUnits = (~amount, ~unit) => Misc.unsafeToOption(() => parseUnitsUnsafe(. amount, unit))

  let parseEther = (~amount) => parseUnits(~amount, ~unit=#ether)
  let parseEtherUnsafe = (~amount) => parseUnitsUnsafe(. amount, #ether)

  @module("ethers") @scope("utils")
  external getAddressUnsafe: string => ethAddress = "getAddress"
  let getAddress: string => option<ethAddress> = addressString =>
    Misc.unsafeToOption(() => getAddressUnsafe(addressString))

  @module("ethers") @scope("utils")
  external formatUnits: (. BigNumber.t, ethUnit) => string = "formatUnits"

  @module("ethers") @scope("utils")
  external hashMessage: string => string = "hashMessage"

  @module("ethers") @scope("utils")
  external arrayify: string => array<string> = "arrayify"

  @module("ethers") @scope("utils")
  external verifyMessage: (string, Wallet.rawSignature) => string = "verifyMessage"

  let formatEther = formatUnits(. _, #ether)

  let tenBN = BigNumber.fromInt(10)

  let make18DecimalsNormalizer = (~decimals) => {
    open BigNumber

    let multiplierOrDivisor = tenBN->pow(Js.Math.abs_int(18 - decimals)->fromInt)
    switch decimals {
    | d if d < 18 => num => num->mul(multiplierOrDivisor)
    | d if d > 18 => num => num->div(multiplierOrDivisor)
    | _ => num => num
    }
  }

  let normalizeTo18Decimals = (num, ~decimals) => {
    make18DecimalsNormalizer(~decimals)(num)
  }

  let formatEtherToPrecision2 = (number: BigNumber.t) => {
    number
    ->formatEther
    ->Float.fromString
    ->Option.getWithDefault(0.)
    ->Js.Float.toFixedWithPrecision(~digits=2)
  }

  /*
  // NOTE: This function is buggy, sometimes it returns "NaN"
  let formatEtherToPrecision = (number: BigNumber.t, digits: int) => {
    let tenToThe = (d: float): float => Js.Math.pow_float(~base=10.0, ~exp=d)

    let rec leastPossibleDigits = (n: float, d: float): float => {
      let m = Js.Math.pow_float(~base=10.0, ~exp=-1.0 *. d)
      if m > n {
        leastPossibleDigits(n, d +. 1.0)
      } else {
        d
      }
    }

    number
    ->formatEther
    ->Float.fromString
    ->Option.getExn
    ->(x => {
      let m = x->leastPossibleDigits(digits->Float.fromInt)->tenToThe
      Js.Math.round(x *. m) /. m
    })
    ->Float.toString
  } */

  let ethAdrToStr: ethAddress => string = Obj.magic
  let ethAdrToLowerStr: ethAddress => string = address =>
    address->ethAdrToStr->Js.String.toLowerCase
}
