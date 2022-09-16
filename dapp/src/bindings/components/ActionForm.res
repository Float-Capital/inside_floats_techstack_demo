type actionType = Deposit | Withdraw

let stringToActionType = string =>
  switch string {
  | "withdraw" => Withdraw
  | "deposit"
  | _ =>
    Deposit
  }
let actionTypeToString = actionType =>
  switch actionType {
  | Deposit => "deposit"
  | Withdraw => "withdraw"
  }

@react.component
let make = () => {
  let (amount, setAmount) = React.useState(_ => "")
  let (action, setAction) = React.useState(_ => Deposit)
  let (web3Provider, setWeb3Provider) = React.useState(_ => None)
  let tokenAddress = "0x6315f3fe0471f44e0cdce9d4757dbd98060b44fe"

  React.useEffect0(() => {
    if %raw(`typeof window !== undefined`) {
      setWeb3Provider(_ => Web3.Providers.getWindowEtherem())
    }

    None
  })

  let handleActionToggle = event => {
    let target = event->ReactEvent.Form.target

    let newAction = target["value"]->stringToActionType

    setAction(_ => newAction)
  }

  let handleSubmit = e => {
    e->ReactEvent.Form.preventDefault
    switch web3Provider {
    | Some(web3Provider) =>
      let provider = Ethers.Providers.makeProviderWithCurrentProvider(web3Provider)

      provider
      ->Ethers.Providers.send("eth_requestAccounts", [])
      ->Promise.thenResolve(_ => {
        let signer = provider->Ethers.Providers.getSigner

        signer->Option.getUnsafe
      })
      ->Promise.then(signer => {
        let contract = Contracts.HodlWallet.make(
          ~address={"0x5722ee7282a04297ab0702cdd8a43879954a8d66"->Ethers.Utils.getAddressUnsafe},
          ~providerOrSigner=Signer(signer),
        )

        switch action {
        | Deposit =>
          Contracts.HodlWallet.depositToken(
            ~contract,
            ~tokenAddress=tokenAddress->Ethers.Utils.getAddressUnsafe,
            ~tokenAmount={amount->Ethers.BigNumber.fromUnsafe},
          )
        | Withdraw =>
          Contracts.HodlWallet.withdrawToken(
            ~contract,
            ~tokenAddress=tokenAddress->Ethers.Utils.getAddressUnsafe,
            ~tokenAmount={amount->Ethers.BigNumber.fromUnsafe},
          )
        }
      })
      ->ignore
    | None => ()
    }
  }
  <form onSubmit=handleSubmit>
    <div className="flex flex-col mb-6 w-96">
      <div className="w-full flex gap-8 my-8 " onChange=handleActionToggle>
        <RadioInput
          name="action"
          value={Deposit->actionTypeToString}
          label="Deposit"
          checked={action == Deposit}
        />
        <RadioInput
          name="action"
          value={Withdraw->actionTypeToString}
          label="Withdraw"
          checked={action == Withdraw}
        />
      </div>
      <Input label="Token Address" value=tokenAddress onChange={_ => ()} />
      <Input
        className="mt-4"
        label="Amount"
        value=amount
        onChange={e => setAmount(_ => (e->ReactEvent.Form.target)["value"])}
      />
    </div>
    <Button> {"Submit"->React.string} </Button>
  </form>
}
