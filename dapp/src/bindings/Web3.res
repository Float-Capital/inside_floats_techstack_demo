module Providers = {
  type t

  //   let getProvider: unit => Promise.t<
  //     array<string>,
  //   > = %raw(`() => ethereum.request({ method: 'eth_requestAccounts' })`)

  let getWindowEtherem: unit => option<t> = %raw(`
()=> {
    if (typeof window !== undefined) {
    return   window.ethereum
    } else {
    return undefined
    }
}
  `)
}
