import { useEffect, useState } from 'react'
import './App.css'
import Images from './Images'
import Button from '@mui/material/Button'
import {contractAddress, contractAbi} from "./contract.js"
import { ethers} from "ethers"
import {LinearProgress} from "@mui/material"
import { useContractFunction } from "@usedapp/core"
import BigNumber from 'bignumber.js'

function App() {
//CONNECT METAMASK
  const [accounts, setAccounts] = useState([])
  async function connectAccounts() {
    if (window.ethereum) {
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts"
      })
      setAccounts(accounts)
    }
  }

  useEffect(() => {
    connectAccounts()
  }, [])

  const [selectedImg, setSelectedImg] = useState()

  async function showSims() {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const signer = provider.getSigner()
    const address = await signer.getAddress( )
    const contract = new ethers.Contract(
      contractAddress,
      contractAbi,
      signer
    )
    const latestSim = contract.seeLatestSim()
    console.log('work')
    console.log(BigNumber.from(latestSim))
    return(Images[latestSim-1])
  }

  //MINTING
  async function handleMint() {
    if (window.ethereum) {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      const signer = provider.getSigner()
      const contract = new ethers.Contract(
        contractAddress,
        contractAbi,
        signer
      )
      try {
        const response = await contract.buySim()
        console.log(response)

      } catch(err) {
        console.log(err)
      }
    }
  }

  return (
    <div className="App">
      <div className="container">
        <div className='imgContainer'>
          {Images.map((img, index) => (
            <img key={index} src={img} alt="sim" />
          ))}
        </div>
        {accounts.length && (<div><Button variant="contained" onClick={handleMint}>Mint a Random SIM</Button> </div>)}
{/*         <Button variant='outlined' onClick={showSims}>See Your Sim</Button>
        <img src={ selectedImg } alt="minted" className='minted' /> */}

        <p>Add Your Wallet SIM NFT 0x23e2b96895ccAE234cA87965bfB4f7B9eE62f914s</p>
      </div>
    </div>
  )
}

export default App
