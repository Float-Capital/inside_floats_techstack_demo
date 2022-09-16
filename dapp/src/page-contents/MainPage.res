@react.component
let make = () => {
  <div className="w-full flex flex-col items-center">
    <img
      src="https://i.kym-cdn.com/entries/icons/original/000/024/987/hodlittt.jpg"
      className="max-w-xl"
    />
    <ActionForm />
    <UserTransactions />
    <Balances />
  </div>
}
